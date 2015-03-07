
class BeOI::App < Sinatra::Application

  get '/api/users-uva-ids' do
    result = BeOI::DB[:users]
    result = result.where("uva_user_id IS NOT NULL AND is_contestant = TRUE")
    result = result.select(:name, :uva_user_id)
    result = result.all
    result.to_json    
  end

  post '/api/users/me', :auth => [:user] do 
    if params['uva_user_id']
      users = BeOI::DB[:users]
      users.where(:user_id=>user[:user_id]).update( uva_user_id: params['uva_user_id'] )
    end
    user.slice(:user_id, :is_admin, :is_contestant).to_json
  end

  get '/api/uva_problems' do
    problem_sets = BeOI::DB[:uva_problem_sets]
    problem_sets = problem_sets.order(Sequel.desc(:uva_problem_sets__deadline))
    problem_sets = problem_sets.all
    result = problem_sets.map { |pset|
      pset[:problems] = BeOI::DB[:uva_problems].where(:uva_problem_set_id => pset[:uva_problem_set_id]).all
      pset
    }
    result.to_json
  end

end
