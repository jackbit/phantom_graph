module PhantomGraph
  module Convert
    class Highchart
      CH_OPTIONS = {widht: 300, scale: 2.5, constr: "Chart"}

      def initialize( opts, js_json, callback_json = nil )
        PhantomGraph.setting.default_options.merge( opts )
        prepare_tmp_files
        self.callback  = callback_json
        self.json      = graph_json
      end

      def image
        @image_file.read
      end

      def process
        log(to_s)
        log(`#{build_cmd}`)
      end

      def log(msg)
        logger.info( msg ) if options[:logger]
      end

      def json=( json )
        @json = json
        @json_file.write( json )
        @json_file.flush
        process if self.options[:auto_process]
      end

      def callback=( json )
        json = "function(chart) {\n#{json}\n}"
        @callback_file.write( json )
        @callback_file.flush
      end

      def to_s
        "<PhantomGraph::Highchart path='#{options[:phantom_js_path]}' " + 
        "highcharts_convert_path='#{options[:highcharts_convert_path]}' " +
        "config_temp='#{@json_file.path}' image_temp='#{@image_file.path}' " + 
        "phantom_js_command='#{build_cmd}'\njson: #{@json.inspect}\n>"
      end

    private
      def build_cmd
        check_error_if_no_phantomjs 
        raise 'Requires HighCharts Convert JS path to be set' unless File.exists?( options[:highcharts_convert_path].to_s )
        raise 'Requires config file' unless @json_file
        raise 'Requires out file' unless @image_file
        cmd = "#{options[:phantom_js_path]} #{options[:highcharts_convert_path]} -infile #{@json_file.path} -outfile #{@image_file.path} -scale 2.5 -width 300 -constr Chart"
        cmd += " -theme #{options[:highcharts_theme_path]}" if options[:highcharts_theme_path]
        cmd
      end

      def check_error_if_no(filekey)
        case filekey
          when :phantom_js_path
            raise PhantomGraph::Error::NoExecutable.new('Requires Phantom JS path to be set') unless File.exists?( options[filekey].to_s )
      end

      def prepare_tmp_files
        @json_file     = Tempfile.new( ['json',     '.json'] )
        @callback_file = Tempfile.new( ['callback', '.json'] )
        @image_file    = Tempfile.new( ['image',    '.png']  )
      end

      def logger
        @logger =|| Logger.new(STDOUT)
      end

      def options 
        @options ||= PhantomGraph.setting
      end
    end
  end
end