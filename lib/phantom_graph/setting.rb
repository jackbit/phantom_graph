module PhantomGraph
  class Setting < PhantomGraph::Base
    attributes :default_options
    attr_writer :phantomjs

    [:phantom_js_path, 
     :highcharts_convert_path, 
     :highcharts_theme_path, 
     :logger, 
     :auto_process, 
     :highstock_path,
     :jquery_path,
     :highcharts_path
     ].each do |m|
      define_method("#{m}=") do |val|
        @default_options[m]=val
      end
    end

    def initialize
      @default_options = { 
        logger:                  false, 
        auto_process:            true, 
        phantom_js_path:         phantomjs, 
        highcharts_convert_path: current_file("highcharts-convert.js"), 
        highcharts_theme_path:   current_file("gray.js"),
        highstock_path:          current_file("highstock.js"),
        highcharts_path:         current_file("highcharts.js"),
        jquery_path:             current_file("jquery.js")
      }
    end

    def phantomjs
      @phantomjs ||= (defined?(Bundler) ? `bundle exec which phantomjs` : `which phantomjs`).chomp
    end

    def current_file(filename)
      File.expand_path(File.dirname(__FILE__)) + "/js/#{filename}"
    end
  end

  class << self
    attr_accessor :setting
  end

  # Configure Phantomjs someplace sensible,
  # like config/initializers/phantom_graph.rb
  #
  # @example
  #   PhantomGraph.configure do |config|
  #     config.phantomjs               = "/usr/local/bin/phantomjs"
  #     config.logger                  = true
  #     config.highcharts_convert_path = "#{Rails.root}/app/assets/javascripts/highcharts-convert.js"
  #     config.highcharts_theme_path   = "#{Rails.root}/app/assets/javascripts/highcharts-theme.js"
  #     config.highcharts_path         = "#{Rails.root}/app/assets/javascripts/highcharts.js"
  #     config.highstock_path          = "#{Rails.root}/app/assets/javascripts/highstock.js"
  #     config.jquery_path             = "#{Rails.root}/app/assets/javascripts/jquery.js"
  #   end

  def self.setting
    @setting ||= PhantomGraph::Setting.new
  end

  def self.configure
    yield(setting)
  end
end