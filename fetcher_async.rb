require 'open-uri'
require "em-synchrony"
require "em-synchrony/em-http"
require "em-synchrony/fiber_iterator"

start = Time.now
ARGV[0] = "http://#{ARGV[0]}" if ARGV[0].scan(/^http:\/\//).empty?
uri = URI(ARGV[0][-1] == '/' ? ARGV[0] : ARGV[0])
target = ARGV[1][-1] == '/' ? ARGV[1] : ARGV[1] + '/'
Dir.mkdir(target) unless File.directory?(target)
Dir.chdir target
html = open(uri.to_s){|f| f.read.encode('UTF-8')}
images = []
# <img> tags
images += html.scan(/<img.+?src=[\\\'\"]{1,2}(.*?)[\\\'\"]{1,2}/im)
# background url()
images += html.scan(/url\s*?\([\\\'\"]{0,2}(.*?)[\\\'\"]{0,2}\)/im)
images = images.flatten
puts "Found #{images.size} image src's where #{images.uniq.size} are unique"
EM.synchrony do
  conc = images.size > 10 ? 10 : images.size
  srcs = images.map{|i| i.scan(/^http:\/\//).empty? ? "#{uri.scheme}://#{uri.host}:#{uri.port}/#{i}" : i }
  EM::Synchrony::FiberIterator.new(srcs, conc).each do |src|
    print "Downloading #{src} to #{target+File.basename(src)}...\n"
    resp = EventMachine::HttpRequest.new(src).get
    begin
      File.open(target+File.basename(src),'wb') {|f| f.write resp.response }
    rescue Exception => e
      puts e.message
    end
  end
  EventMachine.stop
end
puts "Completed in #{Time.now - start}"
