# encoding: utf-8
#ARGV = [123,'/tmp/google']
require './fetcher.rb'
require 'rspec'
require 'spec_helper'

describe Fetcher do
  let(:fetcher) { Fetcher.new PAGE_URL,TARGET_PATH}
  describe "#initialize", 'должен создать переменные инстанса' do
    it "start должен быть Time" do 
      fetcher.start.should be_a Time 
    end
    it "должен сделать uri абсолютным" do
      uri = PAGE_URL.scan(/^http:\/\//).empty? ? "http://#{PAGE_URL}" : PAGE_URL
      uri.scan(/^http:\/\//).should_not be_empty
    end

    it "должен сделать URI из uri" do
      fetcher.uri.should be_a URI
    end
    context "target" do
      it "должен быть String" do
        fetcher.target.should be_an_instance_of String
      end
      it "должен заканчиваться на слэш /" do
        fetcher.target[-1].should == "/"
      end
    end

    it "должен создать директорию с путем target если она не существует" do
      Dir.mkdir(fetcher.target) unless File.directory?(fetcher.target)
    end

    it "должен изменить текущую директорию на target" do
      Dir.chdir(fetcher.target)
    end
  end

  describe "#fetch_html" do
    let(:html) { open(fetcher.uri.to_s){|f| f.read.encode('UTF-8')} }

    context "должен получить html" do
      it "он быть строкой" do
        html.should be_a String
      end
      it "не должен быть пустым" do
        html.should_not be_empty
      end
    end

    context "должен обработать html" do
      let(:images) do  
        (html.scan(/<img.+?src=[\\\'\"]{1,2}(.*?)[\\\'\"]{1,2}/im) + html.scan(/url\s*?\([\\\'\"]{0,2}(.*?)[\\\'\"]{0,2}\)/im)).flatten
      end
      it "добавить найденные соответствия в массив images" do
        images.should be_a Array
      end
      context "все элементы массива images" do
        it "должны быть строками" do
          images.select{|el| !el.is_a? String}.empty?.should be_true
        end
        it "не должны быть пустыми" do
          images.select{|el| el.empty? }.empty?.should be_true
        end
      end
    end

  end

  context "#fetch_images" do
    let(:images) { fetcher.fetch_html }
    context "должен получить массив images" do
      it "он должен быть уникальным" do
        images.uniq.should == images
      end
    end
    
  end
end