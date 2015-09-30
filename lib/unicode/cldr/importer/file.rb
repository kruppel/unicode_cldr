require 'json'

module Unicode
  module Cldr
    module Importer
      class File
        MATCHER = /([^\/]+)\/([^\/]+)\/([^\/]+)\.json$/.freeze

        attr_reader :package, :path, :type, :locale

        def initialize(package, path)
          relative_path = path.gsub("#{package.path}/", '')
          _str, type, code, _subpackage = relative_path.match(MATCHER).to_a

          @package = package
          @path    = path
          @type    = type
          @locale  = Locale[code]
        end

        def read
          json = JSON.parse(::File.read(path))
          content = json[type][locale.code][Cldr::Inflector.camelize(package.id)]
          content = Cldr::Inflector.underscore_keys(content) unless content.nil?

          yield content
        end
      end
    end
  end
end
