
class BeOI::App < Sinatra::Application

  post '/api/signup', :auth => [:authenticated] do
    halt 418, {'Content-Type' => 'text/plain'}, 'Already signed up!' if user? 

    users = BeOI::DB[:users]
    newuser = users.where(:signup_token=>params['token']).single_record

    halt 403, {'Content-Type' => 'text/plain'}, 'Invalid token' if newuser.nil?
    users.where(:signup_token=>params['token']).update( auth_subject_id: @subject_id )

    { 
      :status => "ok"
    }.to_json
  end

  post '/api/me', :auth => [:user, :admin] do

    users = BeOI::DB[:users]
    users.where(:user_id=>user[:user_id]).update( 
      social_email: params['email'],  
      social_name: params['name'], 
      social_picture: params['picture'])
    
    user.slice(:user_id, :is_admin, :is_contestant).to_json
  end

end
