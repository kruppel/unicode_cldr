module Unicode
  module Cldr
    class Importer

      DESTINATION = File.expand_path('../../../config/locale', __dir__)

      attr_reader :data

      def import
        @data = {}

        FileUtils.mkdir_p(DESTINATION)
        Package.all.each { |package| import_package(package) }
        write
      end

      private

      def import_file(file)
        id   = file.package.id
        code = file.locale.code

        file.read do |content|
          next if content.nil?

          data[code]['cldr'][id].merge!(content)
        end
      end

      def import_package(package)
        package.files.each do |file|
          locale = file.locale
          code   = locale.code

          next if file.locale.nil?

          data[code] ||= { 'cldr' => {} }
          data[code]['cldr'][id] ||= {}

          import_file(file)
        end
      end

      def write
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

require 'unicode/cldr/importer/locale'
require 'unicode/cldr/importer/file'
require 'unicode/cldr/importer/package'
