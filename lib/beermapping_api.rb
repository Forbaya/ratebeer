class BeermappingApi
  def self.places_in(city)
    city = city.downcase
    Rails.cache.fetch(city, expires_in: 12.hours) { fetch_places_in(city) }
  end

  def self.place(city, id)
    places = self.places_in(city)
    places.find { |x| x.id == id }
  end
  
  private

  def self.fetch_places_in(city)
    url = "http://beermapping.com/webservice/loccity/#{key}/"

    response = HTTParty.get "#{url}#{ERB::Util.url_encode(city)}"
    places = response.parsed_response["bmp_locations"]["location"]

    return [] if places.is_a?(Hash) and places['id'].nil?

    places = [places] if places.is_a?(Hash)
    places.map do | place |
      Place.new(place)
    end
  end

  def self.key
    "96ce1942872335547853a0bb3b0c24db"
  end
end
