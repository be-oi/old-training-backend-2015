
module BeOI
  class App 

    after do
      headers \
        'Cache-Control' => 'private, max-age=0, s-maxage=0, no-cache'
    end

  end
end
