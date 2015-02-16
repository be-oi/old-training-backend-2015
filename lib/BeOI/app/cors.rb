
module BeOI
  class App 

    after do
      headers \
        'Access-Control-Allow-Origin' => 'http://localhost:9000',
        'Access-Control-Allow-Headers' => 'Origin, X-Requested-With, Content-Type, Accept, Authorization'
    end

  end
end
