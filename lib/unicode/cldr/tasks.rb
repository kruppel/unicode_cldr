require 'unicode/cldr'

namespace :cldr do
  desc 'List supported languages'
  task :languages do
    Unicode::Cldr::Importer::Locale.all.each do |code, locale|
      delimiter = code.length < 8 ? "\t\t" : "\t"

      puts "#{code}#{delimiter}#{locale.name}"
    end
  end

  desc 'Import CLDR'
  task :import do
    Unicode::Cldr::Importer.import
  end
end
