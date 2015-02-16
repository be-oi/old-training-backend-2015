
class BeOI::App < Sinatra::Application

  get '/api/online-results' do

    result = BeOI::DB[:results]
    result = result.join(:users,:user_id=>:results__user_id)
    result = result.join(:contests,:contest_id=>:results__contest_id)
    result = result.where(:is_contestant=>true) 
    result = result.select(
        :results__user_id,
        :results__contest_id,
        :results__score,
        :results__rank,
        :results__creation_time,
        :users__name___user_name, 
        :contests__name___contest_name) 
    result = result.reverse_order(:creation_time) 
    result = result.all
    result.each { |e| e[:score] = e[:score].to_s('F') } # use decimal notation (instead of scientific) for score
    result.to_json    
  end

  get '/api/upcoming-contests' do
    result = BeOI::DB[:contests]
    result = result.where('end_time > now()')
    result = result.order(:start_time) 
    result = result.all
    result.to_json    
  end

  get '/api/contest/:contest_id' do

    result = {
      :contest_id => 1,
      :name => 'Codeforce #222'
    }

    result.to_json
  end

end
