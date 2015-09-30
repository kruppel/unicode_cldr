require 'yaml'

module Unicode
  module Cldr
    class Importer

      class Locale

        attr_reader :name, :code

        class << self

          def languages
            @languages ||= YAML.load_file(
              ::File.expand_path('../../../../config/languages.yml', __dir__)
            )
          end

          def [](code)
            all[code]
          end

          def all
            @cache ||= languages.each_with_object({}) do |(_, metadata), cache|
              code = metadata['unicode_code']
              cache[code] = new(metadata)
            end
          end

        end

        def initialize(metadata)
          @name = metadata['name']
          @code = metadata['unicode_code']
        end

      end

    end
  end
end
