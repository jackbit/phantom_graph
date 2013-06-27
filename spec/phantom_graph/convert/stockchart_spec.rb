#encoding: UTF-8
require 'spec_helper'

describe PhantomGraph::Convert::Stockchart do

  it { PhantomGraph::Convert::Stockchart.should respond_to :attributes }

  def json_str(data="")
    "{
      rangeSelector : {
        selected : 1
      },

      title : {
        text : 'AAPL Stock Price'
      },
      
      series : [{
        name : 'AAPL',
        data : #{data},
        tooltip: {
          valueDecimals: 2
        }
      }]
    }"
  end

  before do
    data = File.open("#{File.expand_path(File.dirname(__FILE__))}/stock.json", "r"){|io| io.read}
    @json_str = json_str(data)
    PhantomGraph.configure do |config|
      config.logger    = true
    end
  end

  context "initialize" do
    before do
      @highchart = PhantomGraph::Convert::Stockchart.new(@json_str, {auto_process: false})
    end

    it "should have merged options" do
      @highchart.options[:constr].should == "StockChart"
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
      expect{ PhantomGraph::Convert::Stockchart.new(@json_str, {phantom_js_path: nil}) }.to raise_error PhantomGraph::Error::NoExecutable
    end
  end

  context "processing" do
    it "should generate image" do
      @highchart = PhantomGraph::Convert::Stockchart.new(@json_str, {image_file_path: File.expand_path(File.dirname(__FILE__))})
      File.size?(@highchart.image.path).should_not be_nil
    end
  end
  
end