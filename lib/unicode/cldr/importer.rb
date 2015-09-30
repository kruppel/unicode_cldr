module Unicode
  module Cldr
    module Importer
      extend self

      DESTINATION = File.expand_path('../../../config/locale', __dir__)

      def read
        data = {}

        Package.all.each do |package|
          package.files.each do |file|
            locale = file.locale

            next if locale.nil?

            code = locale.code
            data[code] ||= { 'cldr' => {} }

            file.read do |content|
              next if content.nil?

              id = package.id
              data[code]['cldr'][id] ||= {}
              data[code]['cldr'][id].merge!(content)
            end
          end
        end

        yield data if block_given?

        data
      end

      def import
        FileUtils.mkdir_p(DESTINATION)

        read do |data|
          data.each do |code, content|
            puts "Writing #{DESTINATION}/#{code}.yml..."

            ::File.open("#{DESTINATION}/#{code}.yml", 'w') do |file|
              translations       = {}
              translations[code] = content

              file.write(translations.to_yaml)
            end
          end
        end
      end
    end
  end
end

require 'unicode/cldr/importer/locale'
require 'unicode/cldr/importer/file'
require 'unicode/cldr/importer/package'
