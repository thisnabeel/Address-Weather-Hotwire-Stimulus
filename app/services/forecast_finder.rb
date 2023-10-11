class ForecastFinder
    def self.call(coordinates)
        url = "https://weather.visualcrossing.com/VisualCrossingWebServices/rest/services/timeline/#{coordinates}?key=#{ENV["VISUAL_CROSSING_API_KEY"]}"
        response = HTTParty.get(url)
        json = JSON.parse(response.body)
        return json
    end
end