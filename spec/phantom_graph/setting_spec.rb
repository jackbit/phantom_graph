#encoding: UTF-8
require 'spec_helper'

describe PhantomGraph::Setting do

  def current_file(filename)
    PhantomGraph.setting.current_file(filename)
  end

  before do
    PhantomGraph.configure do |config|
      config.phantomjs = "/usr/local/bin/phantomjs"
      config.logger    = true
    end
  end

  context "when initialize" do
    describe "default options" do
      it "should have phantom_js_path" do
        PhantomGraph.setting.default_options[:phantom_js_path].should eq(PhantomGraph.setting.phantomjs)
      end

      it "should have logger" do
        PhantomGraph.setting.default_options[:logger].should be_true
      end

      it "should have auto_process" do
        PhantomGraph.setting.default_options[:auto_process].should be_true
      end

      it "should have highcharts_convert_path" do
        PhantomGraph.setting.default_options[:highcharts_convert_path].should eq(current_file("highcharts-convert.js"))
      end

      it "should have highcharts_theme_path" do
        PhantomGraph.setting.default_options[:highcharts_theme_path].should eq(current_file("gray.js"))
      end

      it "should have highstock_path" do
        PhantomGraph.setting.default_options[:highstock_path].should eq(current_file("highstock.js"))
      end

      it "should have highcharts_path" do
        PhantomGraph.setting.default_options[:highcharts_path].should eq(current_file("highcharts.js"))
      end

      it "should have jquery_path" do
        PhantomGraph.setting.default_options[:jquery_path].should eq(current_file("jquery.js"))
      end
    end

    describe "file" do
      it "should exist phantomjs binnary" do
        File.exist?(PhantomGraph.setting.phantomjs).should be_true
      end

      it "should exist highcharts-convert.js" do
        File.exist?(current_file("highcharts-convert.js")).should be_true
      end

      it "should exist highcharts-convert.js" do
        File.exist?(current_file("highcharts-convert.js")).should be_true
      end

      it "should exist gray.js" do
        File.exist?(current_file("gray.js")).should be_true
      end

      it "should exist highstock.js" do
        File.exist?(current_file("highstock.js")).should be_true
      end

      it "should exist highcharts.js" do
        File.exist?(current_file("highcharts.js")).should be_true
      end
      
      it "should exist jquery.js" do
        File.exist?(current_file("jquery.js")).should be_true
      end


    end
  end

end