module Unicode
  module Cldr
    module Inflector
      module_function

      def camelize(str)
        str.gsub(%r{(?:_|(\/))([a-z\d]*)}i) { "#{$1}#{$2.capitalize}" }
      end

      def underscore(str)
        str.gsub(/([A-Z\d]+)([A-Z][a-z])/, '\1_\2')
          .gsub(/([a-z\d])([A-Z])/, '\1_\2')
          .tr('-', '_')
          .downcase
      end

      def underscore_keys(hash)
        hash.each_with_object({}) do |(key, value), memo|
          if value.is_a?(Hash)
            memo[underscore(key)] = underscore_keys(value)
          else
            memo[underscore(key)] = value.to_s
          end
        end
      end
    end
  end
end
