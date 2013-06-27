module PhantomGraph
  module Convert
    class Stockchart < PhantomGraph::Convert::Highchart

      def options
        @options ||= CH_OPTIONS.merge(constr: "StockChart")
      end

    end
  end
end