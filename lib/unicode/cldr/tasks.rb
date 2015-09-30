require 'fileutils'
require 'json'
require 'yaml'

SUBMODULES_PATH = File.expand_path(
  "../../../../submodules",
  __FILE__
).freeze

TRANSLATIONS_PATH = File.expand_path(
  "../../../../config/locale",
  __FILE__
).freeze

LANGUAGES_PATH = File.expand_path(
  '../../../../config/languages.yml',
  __FILE__
).freeze

CLDR_PACKAGES = Dir.chdir(SUBMODULES_PATH) { Dir['*'] }.freeze
FILE_MATCHER = /\/submodules\/([^\/]+)\/([^\/]+)\/([^\/]+)\/([^\/]+)\.json$/.freeze

def camelize(str)
  str.gsub(/(?:_|(\/))([a-z\d]*)/i) { "#{$1}#{$2.capitalize}" }
end

def underscore(str)
  str.gsub(/([A-Z\d]+)([A-Z][a-z])/, '\1_\2')
    .gsub(/([a-z\d])([A-Z])/, '\1_\2')
    .tr('-', '_')
    .downcase
end

def underscore_keys(hash)
  hash.each_with_object({}) do |(key, value), memo|
    memo[underscore(key)] = value.is_a?(Hash) ? underscore_keys(value) : value.to_s
  end
end

namespace :cldr do
  desc 'Clears config/locale'
  task :clean do
    puts "Clearing #{TRANSLATIONS_PATH}..."
    FileUtils.rm_rf TRANSLATIONS_PATH
  end

  desc 'List supported languages'
  task :languages do
    YAML.load_file(LANGUAGES_PATH).each do |locale, language|
      code = language['unicode_code']
      delimiter = code.length < 8 ? "\t\t" : "\t"

      puts "#{code}#{delimiter}#{language['name']}"
    end
  end

  desc 'Import CLDR'
  task :import => :clean do
    languages = YAML.load_file(LANGUAGES_PATH)
    supported_locales = languages.each_with_object({}) do |(locale, language), memo|
      memo[language['unicode_code']] = locale
    end

    data = {}
    CLDR_PACKAGES.each do |package|
      files = Dir[
        File.expand_path(
          "../../../../submodules/#{package}/main/**/*.json",
          __FILE__
        )
      ]

      files.each do |file|
        _str, _package, data_type, locale, _subpackage = file.match(FILE_MATCHER).to_a

        next unless supported_locales.has_key?(locale)

        json = JSON.parse(File.read(file))
        nested_json = json[data_type][locale][camelize(package)]

        next if nested_json.nil?

        content = underscore_keys(nested_json)

        data[locale] ||= { 'cldr' => {} }
        data[locale]['cldr'][package] ||= {}
        data[locale]['cldr'][package].merge!(content)
      end
    end

    data.each do |locale, content|
      FileUtils.mkdir_p(TRANSLATIONS_PATH)

      puts "Writing #{TRANSLATIONS_PATH}/#{locale}.yml..."

      File.open("#{TRANSLATIONS_PATH}/#{locale}.yml", 'w') do |file|
        translations = {}
        translations[locale] = content
        file.write(translations.to_yaml)
      end
    end
  end
end
