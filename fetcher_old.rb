require 'open-uri'
require 'parallel'

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
Parallel.map(images.uniq, :in_threads => 8) do |img|
  src = img.scan(/^http/).empty? ? "#{uri.scheme}://#{uri.host}:#{uri.port}/#{img}" : img
  print "Downloading #{src} to #{target+File.basename(img)}...\n"
  open(target+File.basename(img),'wb') do |image|
    image << open(src).read rescue print "Can't download image #{src}\n"
  end
end
puts "Completed in #{Time.now - start}"
