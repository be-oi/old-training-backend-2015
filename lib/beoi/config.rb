module BeOI
  module Config

    def root_folder
      Path.backfind('.[config.ru]')
    end

    def config
      @config ||= begin
        config = Hash.new
        ['database', 'jwt'].each do |cfg|
          path = "config/#{cfg}.yml"
          file = Path.backfind(path)
          config_error(path) unless file && file.exist?
          config_error(file) unless (envs = file.load).is_a?(Hash)
          # Merge all envs and their keys
          envs.each do |env, settings|
            unless config.key?(env)
              config[env] = Hash.new
            end
            config[env][cfg] = settings
          end
        end
        symbolize_keys(config)
      end
    end

    def symbolize_keys(tuple)
      tuple.each_with_object({}){|(k,v),h| h[k.to_sym] = v}
    end 

    def environment
      @environment ||= begin
        env   = ENV['BEOI_ENV']
        env ||= Path.backfind('.beoi').read.strip rescue nil
        env ||= 'devel'
        env.to_sym
      end    
    end

    def adapter(env = environment)
      unless adapter = symbolize_keys(config[env]['database'])
        raise "Unable to find an adapter for `#{env}`"
      end
      adapter
    end

    def sequel_db(env = environment)
      @sequel_db ||= ::Sequel.connect(adapter(env))
    end

    def database
      adapter[:database]
    end

    def user
      adapter[:user]
    end

    def jwt_client_id(env = environment)
      config[env]['jwt']['client_id']
    end

    def jwt_client_secret(env = environment)
      config[env]['jwt']['client_secret']
    end 

    def config_error(file)
      raise "Unable to load `#{file}`. Please check the configuration."
    end

  end
end
