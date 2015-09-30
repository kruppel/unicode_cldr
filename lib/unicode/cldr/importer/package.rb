require 'fileutils'

module Unicode
  module Cldr
    module Importer
      class Package
        DIRECTORY = ::File.expand_path('../../../../submodules', __dir__)

        attr_reader :id, :path, :data

        class << self
          def all
            Dir.chdir(DIRECTORY) { Dir['*'] }.map { |id| new(id) }
          end
        end

        def initialize(id)
          @id = id
          @path = ::File.expand_path(id, DIRECTORY)
        end

        def files
          Dir["#{path}/{main,supplemental}/**/*.json"].map { |file| File.new(self, file) }
        end
      end
    end
  end
end
