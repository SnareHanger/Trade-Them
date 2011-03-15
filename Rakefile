#http://blog.aizatto.com/2007/05/27/activerecord-migrations-without-rails/
require 'active_record'
require 'yaml'

task :default => :migrate

desc "Migrate the database through scripts in db/migrate. Target specific version with VERSION=x"
task :migrate => :environment do
  ActiveRecord::Migrator.migrate('db/migrate', ENV["VERSION"] ? ENV["VERSION"].to_i : nil )
end

task :environment do
  #ActiveRecord::Base.establish_connection YAML::load(File.open('database.yml'))

   ActiveRecord::Base.establish_connection(
     :adapter => "sqlite3",
     :database => "db/tradethem.sqlite3"
   )

  #ActiveRecord::Base.logger = Logger.new(File.open('database.log', 'a'))
end

