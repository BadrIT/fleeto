module Map
  module Base
    class DistanceMatrix


      # from and to, each can be a single hash({latitude: <some_lat>, longitude: <some_long>}) or array of such hashes
      def initialize(options = {})
        @options = self.class.default_options.deep_merge(options)

        # normalize input locations to be in array format
        @options[:from] = [@options[:from]] unless @options[:from].is_a?(Array)
        @options[:to] = [@options[:to]] unless @options[:to].is_a?(Array)
      end

      # :nocov:
      def execute
        raise NotImplementedError
      end
    end
  end
end