module PhantomGraph
  module Error

    class NoExecutable < StandardError
      def initialize
        msg = "No phantomjs executable found at #{PhantomGraph.setting.phantomjs}\n"
        msg << ">> Please install phantomjs - http://phantomjs.org/download.html"
        super(msg)
      end
    end

    class InvalidSource < StandardError
      def initialize(msg = nil)
        super("Invalid Source: #{msg}")
      end
    end

  end
end