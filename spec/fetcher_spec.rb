# encoding: utf-8
ARGV = ['google.com','/tmp/google']
require './fetcher.rb'
require 'rspec'

describe Fetcher do
  before(:all) do
    @fetcher = Fetcher.new(*ARGV)
  end
  context "#initialize" do

    it "должен создать переменную класса start" do 
      @fetcher.start.should be_an_instance_of Time 
    end
    context "должен создать переменную класса uri:" do
      it "она должна быть URI HTTP или HTTPS" do 
        @fetcher.uri.should be_an_instance_of URI::HTTP or be_an_instance_of URI::HTTPS
      end
    end
    context "должен создать переменную класса target" do
      it "она должна быть строкой" do
        @fetcher.target.should be_an_instance_of String
      end
      it "она должна заканчиваться на слэш /" do
        @fetcher.target[-1].should == "/"
      end
    end

    it "должен создать директорию с путем target если она не существует" do
      Dir.mkdir(@fetcher.target) unless File.directory?(@fetcher.target)
    end

    it "должен изменить ткущую директорию на target" do
      Dir.chdir(@fetcher.target)
    end

  context "#fetch_html"
    it "должен вернуть массив со ссылками на избражения" do
      @fetcher.fetch_html.should be_an_instance_of Array
    end
    it "элементы массива должны быть строками" do
      @fetcher.fetch_html.select{|el| !el.is_a? String}.empty?.should be_true
    end
  end
end