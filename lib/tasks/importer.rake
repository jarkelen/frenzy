namespace :frenzy do
  task import: :environment do
    DataImporter.new.import
  end
end