class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  class << self
    def enum_string(attribute, values, options = {})
      values.each do |value|
        define_method "#{value}?" do
          self.send(attribute) == value
        end

        scope value, ->{ where(attribute => value) }
      end
    end
  end
end
