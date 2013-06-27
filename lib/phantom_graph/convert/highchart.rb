module PhantomGraph
  module Convert
    class Highchart < PhantomGraph::Base
      CH_OPTIONS = {width:              600, 
                    scale:              1, 
                    constr:             "Chart",
                    filename:           nil, 
                    json_file_path:     "/tmp", 
                    image_file_path:    "/tmp", 
                    callback_file_path: "/tmp"}
      attributes :callback_file, :json_file, :image_file, :json

      def initialize( js_json, opts = {}, callback_json = nil )
        options.merge!(PhantomGraph.setting.default_options.merge(opts))
        prepare_tmp_files
        flush_callback(callback_json) if callback_json
        flush_json(js_json)
      end

      def options
        @options ||= CH_OPTIONS
      end

      def image
        f = File.new([options[:image_file_path], random_filename].join("/"), "w+")
        f.write(self.image_file.read)
        f.close
        f
      end

      def result
        image
      end

      def random_filename
        return @options[:filename] if @options[:filename]
        "#{rand(100000)}-#{Time.now.to_i}.png"
      end

      def process
        log(to_s)
        log(`#{build_cmd}`)
      end

      def logger
        @logger ||= ::Logger.new(STDOUT)
      end

      def flush_json(js_json)
        self.json = js_json
        json_file.write(js_json)
        json_file.flush
        process if options[:auto_process]
      end

      def flush_callback(callback_json)
        callback_file.write("function(chart) {\n#{callback_json}\n}")
        callback_file.flush
      end

      def to_s
        "<ImageHighchart path='#{options[:phantom_js_path]}' " + 
        "highcharts_convert_path='#{options[:highcharts_convert_path]}' " +
        "config_temp='#{json_file.path}' image_temp='#{image_file.path}' " + 
        "phantom_js_command='#{build_cmd}'\njson: #{json.inspect}\n>"
      end

      def build_cmd
        [:phantom_js_path, :json_file, :image_file].each do |key|
          check_error(key)
        end
        cmd  = "#{options[:phantom_js_path]} #{options[:highcharts_convert_path]} "
        cmd += "-infile #{json_file.path} -outfile #{image_file.path} "
        cmd += "-scale #{options[:scale]} "   if options[:scale]
        cmd += "-width #{options[:width]} "   if options[:width]
        cmd += "-width #{options[:height]} "  if options[:height]
        cmd += "-constr #{options[:constr]}"  if options[:constr]
        cmd += " -theme #{options[:highcharts_theme_path]}" if options[:highcharts_theme_path]
        cmd
      end

      def check_error(filekey)
        if filekey == :phantom_js_path
          raise PhantomGraph::Error::NoExecutable.new unless File.exists?( options[filekey].to_s )
        else
          raise PhantomGraph::Error::InvalidSource.new(filekey) unless send(filekey)
        end
      end

      def prepare_tmp_files
        self.json_file     = Tempfile.new( ['json',     '.json'], options[:json_file_path] )
        self.callback_file = Tempfile.new( ['callback', '.json'], options[:callback_file_path] )
        self.image_file    = Tempfile.new( ['chart',    file_ext],  options[:image_file_path]  )
      end

      def log(msg)
        logger.debug(msg) if options[:logger]
      end

      def file_ext
        options[:filename] ? options[:filename].match(/\.\w+$/i).to_s.downcase : ".png"
      end

        
    end
  end
end