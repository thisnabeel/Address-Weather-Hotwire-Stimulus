class CoordinatesFinder
    def self.call(place_id)
        url = "https://maps.googleapis.com/maps/api/geocode/json?place_id=#{place_id}&key=#{ENV["GOOGLE_MAPS_API_KEY"]}"
        coordinates = HTTParty.get(url)["results"][0]["geometry"]["location"]
        return "#{coordinates["lat"]},#{coordinates["lng"]}"
    end
end