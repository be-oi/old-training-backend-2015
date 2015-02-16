
module BeOI
  class App 

    # Either :authenticated, :user, :contestant, :admin
    # authenticated: has a correct authentication token (verified Google account)
    # user: authenticated and the user exists in our db
    # contestant: user and marked as contestant
    # admin: user and marked as admin
    set(:auth) do |*roles| 
      condition do 
        begin
          @subject_id = validated_subject_id!
        rescue UnauthorizedError => e
          halt 401, {'Content-Type' => 'text/plain'}, 'Authentication error: '+e.message
        end
        return roles.include?(:authenticated) || 
          (roles.include?(:user) && user?) || 
          (roles.include?(:admin) && admin?) ||
          (roles.include?(:contestant) && contestant?) 
      end
    end

    def user
      @user ||= begin
        users = BeOI::DB[:users]
        @user = users.where(:auth_subject_id=>@subject_id).single_record || {}
        @user.update(last_login: DateTime.now) if user[:auth_subject_id] # not working?
        @user
      end
    end

    def user?
      return !user[:auth_subject_id].nil?
    end

    def admin?
      return user? && !!user[:is_admin] 
    end

    def contestant?
      return user? && !!user[:is_contestant]
    end 

    def validated_subject_id!
      authorization = request.env['HTTP_AUTHORIZATION']
      raise UnauthorizedError, 'no authorization header' unless authorization
      token = authorization.split(' ').last
      BeOI::auth_subject!(token)
    end

    def user_already_signed_up?
      user.nil?
    end

  end
end
