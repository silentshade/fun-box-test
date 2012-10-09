require 'open-uri'
require 'parallel'

class Fetcher
  attr_reader :start, :uri, :target
  def initialize(uri,target)
    @start = Time.now
    uri = "http://#{uri}" if uri.scan(/^http:\/\//).empty?
    @uri = URI(uri)
    @target = target[-1] == '/' ? target.to_s : "#{target}/"
    Dir.mkdir(@target) unless File.directory?(@target)
    Dir.chdir @target
  end

  def fetch_html
    images = []
    html = open(@uri.to_s){|f| f.read.encode('UTF-8')}
    # <img> tags
    images += html.scan(/<img.+?src=[\\\'\"]{1,2}(.*?)[\\\'\"]{1,2}/im)
    # background url()
    images += html.scan(/url\s*?\([\\\'\"]{0,2}(.*?)[\\\'\"]{0,2}\)/im)
    images = images.flatten
    puts "Found #{images.size} image src's where #{images.uniq.size} are unique"
    images.uniq
  end

  def fetch_images(images)
    Parallel.map(images, :in_threads => 8) do |img|
      src = img.scan(/^http/).empty? ? "#{@uri.scheme}://#{@uri.host}:#{@uri.port}/#{img}" : img
      print "Downloading #{src} to #{@target+File.basename(img)}...\n"
      begin
        open(@target+File.basename(img),'wb') do |image|
          image << open(src).read rescue print "Can't download image #{src}\n"
        end
      rescue Exception => e
        puts puts e.message
      end
    end    
  end
end

if ARGV.size == 2
  fetcher = Fetcher.new(*ARGV)
  fetcher.fetch_images fetcher.fetch_html
  puts "Completed in #{Time.now - fetcher.start}"
end
