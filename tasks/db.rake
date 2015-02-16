require 'open3'

namespace :db do

  class String
  def red;            "\033[31m#{self}\033[0m" end
  def bold;           "\033[1m#{self}\033[22m" end
  end

  def exec(*cmds)
    cumul_output = ""

    cmds.each do |cmd|
      begin
        puts cmd.bold
        output, status = Open3.capture2e(cmd)
        if status.success?
          puts output
        else 
          fail output.red
        end
        cumul_output += output
      rescue => detail
        fail detail.message.red
      end
    end
    cumul_output.lines.map(&:chomp)
  end

  def pg_cmd(cmd, username='postgres')
    ctx = ["--host=#{adapter[:host]}"]
    cmd = cmd.split(' ')
      .insert(1, ctx)
      .join(' ')
  end

  desc "Ping the current database (showing which one it is)"
  task :ping do
    puts BeOI::DB.test_connection  ? "Success" : "Fail"
  end

  desc "Open a command line shell on the database using the user from the configuration"
  task :shell do
    system pg_cmd("psql --dbname=#{adapter[:database]}")
  end

  desc "Create the database, load the latest schema and seed with devel data"
  task :init => [:"db:create", :"db:migrate"]

  desc "Load the latest schema (restore + migrate) and seed with the devel data"
  task :rebuild =>  [:"db:restore", :"db:migrate"] #, :"db:seed"

  desc "Create the database and the db user, based on the configuration (fail if exists)"
  task :create do
    create_role_sql = "CREATE USER #{user} WITH PASSWORD 'md5#{Digest::MD5.hexdigest(adapter[:password])}' VALID UNTIL 'infinity';"
    create_db_sql = "CREATE DATABASE #{database} WITH OWNER=#{user} ENCODING='UTF8';"
    
    exec pg_cmd("psql -c \"#{create_role_sql}\""),
         pg_cmd("psql -c \"#{create_db_sql}\"")
  end

  desc "Run migrations on the current database"
  task :migrate do
    puts 'Migrating latest database changes...'.bold
    Sequel.extension :migration
    Sequel::Migrator.apply(BeOI::DB, Path.dir.parent/"db/migrations")
  end

  desc "Restore from a given backup (the most recent in db/backup/<env>/) with appropriate ownership. Override the existing schema and data!"
  task :restore, :from do |t, args|
    from = "db/backup/#{args[:from] || environment}"
    unless file = Dir.glob("#{from}/*.sql").sort.last
      raise "No database backup found in #{from}".red
    end
    puts "Restoring from #{file}...".bold
    exec pg_cmd("psql #{database} < #{file}") # fixme: if import fails, this will succeed anyway (and so continue)

    puts "Setting the ownership...".bold
    objects = exec pg_cmd("psql -qAt -c \"SELECT tablename FROM pg_tables WHERE schemaname = 'public';\" #{database}"),
                   pg_cmd("psql -qAt -c \"SELECT table_name FROM information_schema.views WHERE table_schema = 'public';\" #{database}"),
                   pg_cmd("psql -qAt -c \"SELECT sequence_name FROM information_schema.sequences WHERE sequence_schema = 'public';\" #{database}")
    objects.each { |object|
      exec pg_cmd("psql -c \"ALTER TABLE #{object.chomp} OWNER TO #{user}\" #{database}")
    }
  end
  task :restore => [:"db:cleanup"]

  desc "Create a database backup in db/backup/<env>/ to be imported with db:restore"
  task :backup, :which do |t, args|
    which     = (args[:which] || environment).to_sym
    timestamp = Time.now.strftime("%Y%m%d%H%M%S")
    file      = "beoi-#{timestamp}.sql"
    target    = "db/backup/#{which}/"
    database  = adapter(which)[:database]
    puts "Performing backup to #{file}...".bold
    Dir::Tmpname.create(file) { |path|
      FileUtils::mkdir_p(target)
      exec pg_cmd "pg_dump --no-owner --no-acl --file=#{path} --dbname=#{database}"
      FileUtils.mv(path, File.join(target, file))
    }
  end

  desc "Seed the database with devel data"
  task :seed do 
    puts "Seeding the db with the dataset --- NOT WORKING".bold
    raise "not implemented"
    # BeOI::Database::Seeder.new.fixtures!(true)
  end

  desc "Ensure an empty database schema"
  task :cleanup do
    puts "Removing db schema...".bold
    exec pg_cmd("psql -d #{database} -c \"DROP SCHEMA IF EXISTS public CASCADE;\""),
         pg_cmd("psql -d #{database} -c \"CREATE SCHEMA public AUTHORIZATION #{user};\"")
  end

  desc "Ensure an empty database (data)"
  task :empty do
    puts "Emptying the db...".bold
    raise "not implemented"
  end

  desc "Drop the database and the db user from the configuration"
  task :drop do
    exec pg_cmd("dropdb --if-exists #{database}"),
         pg_cmd("psql -c \"DROP ROLE IF EXISTS #{user}\"")
  end

end
