module BeOI
  module Database
    class Seeder

      def fixtures!(empty = true)
        with_db do |db|
          empty! if empty
          seed!()
          sequences!
        end
      end

      def opts
        { }
      end

      def with_db(transaction = true, &bl)
        return yield(@db) if defined?(@db)
        BeOI::DB.connect(opts) do |db|
          @db = db
          if transaction
            db.in_transaction{ yield(db) }
          else
            yield(db)
          end
          @db = nil
        end
      end

      def empty!
        with_db do |db|
          base_relvar_names(true).each do |m|
            db.relvar(m.to_sym).delete
          end
        end
      end

      def seed!
        path = Path.backfind("db/seeds")
        raise "No seeds found in #{path}" unless path && path.directory?

        Alf.connect(path, opts) do |source|
          with_db do |target|

            Dir.foreach(path) do |item|
              puts item
            end

            # base_relvar_names.each do |m|
            #   puts "path: #{path/"#{m}.rash"} -- #{(path/"#{m}.rash").exists?}" 
            #   next unless (path/"#{m}.rash").exists?
            #   target.relvar(m).affect source.query(m)
            # end
          end
        end
      end

    end # class Seeder
  end # module Database
end # module BeOI
