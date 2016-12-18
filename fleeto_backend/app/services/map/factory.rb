module Map
  class Factory

    class << self
      def new_service_adaptor(service_type, adaptor_type = nil)
        adaptor_type ||= Rails.configuration.map_adaptors[service_type]
        Map.const_get(adaptor_type.to_s.camelize).const_get(service_type.to_s.camelize)
      end
    end

  end
end