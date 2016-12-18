module Map
  module Google
    class DistanceMatrix < ::Map::Base::DistanceMatrix

      API_KEY = ENV["GOOGLE_DISTANCE_MATRIX_API_KEY"]
      API_URL = "https://maps.googleapis.com/maps/api/distancematrix/json"

      def execute
        uri = URI("#{API_URL}")
        uri.query = URI.encode_www_form(query_params)
        response = Net::HTTP.get_response(uri)
        JSON.parse(response.body)["rows"]
      end

      private

      def query_params
        {
          origins: convert_locations_to_url_params(@options[:from]),
          destinations: convert_locations_to_url_params(@options[:to]),
          key: API_KEY,
          units: @options[:units],
          departure_time: "now"
        } 
      end

      def convert_locations_to_url_params(locations)
        locations.map{|location| "#{location[:lat]},#{location[:long]}"}.join("|")
      end

      def self.default_options
        {
          units: "metric",
          mode: "driving"
        }
      end

    end
  end
end