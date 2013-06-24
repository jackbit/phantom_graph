#encoding: UTF-8
require 'spec_helper'

describe PhantomGraph::Convert::Highchart do
  def json_str
    "{
        chart: {
          type: 'line',
          marginRight: 130,
          marginBottom: 25
        },
        title: {
          text: 'Monthly Average Temperature',
          x: -20 
        },
        subtitle: {
          text: 'Source: WorldClimate.com',
          x: -20
        },
        xAxis: {
          categories: ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec']
        },
        yAxis: {
          title: {
              text: 'Temperature (°C)'
          },
          plotLines: [{
              value: 0,
              width: 1,
              color: '#808080'
          }]
        },
        tooltip: {
          valueSuffix: '°C'
        },
        legend: {
          layout: 'vertical',
          align: 'right',
          verticalAlign: 'top',
          x: -10,
          y: 100,
          borderWidth: 0
        },
        series: [{
            name: 'Tokyo',
            data: [7.0, 6.9, 9.5, 14.5, 18.2, 21.5, 25.2, 26.5, 23.3, 18.3, 13.9, 9.6]
        }, {
            name: 'New York',
            data: [-0.2, 0.8, 5.7, 11.3, 17.0, 22.0, 24.8, 24.1, 20.1, 14.1, 8.6, 2.5]
        }, {
            name: 'Berlin',
            data: [-0.9, 0.6, 3.5, 8.4, 13.5, 17.0, 18.6, 17.9, 14.3, 9.0, 3.9, 1.0]
        }, {
            name: 'London',
            data: [3.9, 4.2, 5.7, 8.5, 11.9, 15.2, 17.0, 16.6, 14.2, 10.3, 6.6, 4.8]
        }]
      }"
  end

  before do
    PhantomGraph.configure do |config|
      config.logger    = true
    end
  end

  context "initialize" do
    before do
      @highchart = PhantomGraph::Convert::Highchart.new(json_str, {auto_process: false})
    end

    it "should have merged options" do
      @highchart.options.should eq(PhantomGraph.setting.default_options.merge(PhantomGraph::Convert::Highchart::CH_OPTIONS))
    end

    it "should have temporary json file" do
      @highchart.json_file.should_not be_nil
    end

    it "should have temporary image file" do
      @highchart.image_file.should_not be_nil
    end

    it "should have temporary callback file" do
      @highchart.image_file.should_not be_nil
    end
  end

  context "error" do
    it "should raise No Executable if phantomjs file not exist" do
      expect{ PhantomGraph::Convert::Highchart.new(json_str, {phantom_js_path: nil}) }.to raise_error PhantomGraph::Error::NoExecutable
    end
  end

  context "processing" do
    it "should generate image" do
      @highchart = PhantomGraph::Convert::Highchart.new(json_str, {image_file_path: File.expand_path(File.dirname(__FILE__))})
      File.size?(@highchart.image.path).should_not be_nil
    end
  end
  
end