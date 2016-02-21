# coding: utf-8
require 'rails_helper'

describe "BeermappingApi" do
  describe "in case of cache miss" do
    before :each do
      Rails.cache.clear
    end

    it "When HTTP GET returns one entry, it is parsed and returned" do

      canned_answer = <<-END_OF_STRING
<?xml version='1.0' encoding='utf-8' ?><bmp_locations><location><id>12411</id><name>Gallows Bird</name><status>Brewery</status><reviewlink>http://beermapping.com/maps/reviews/reviews.php?locid=12411</reviewlink><proxylink>http://beermapping.com/maps/proxymaps.php?locid=12411&amp;d=5</proxylink><blogmap>http://beermapping.com/maps/blogproxy.php?locid=12411&amp;d=1&amp;type=norm</blogmap><street>Merituulentie 30</street><city>Espoo</city><state></state><zip>02200</zip><country>Finland</country><phone>+358 9 412 3253</phone><overall>91.66665</overall><imagecount>0</imagecount></location></bmp_locations>
    END_OF_STRING

      stub_request(:get, /.*espoo/).to_return(body: canned_answer, headers: { 'Content-Type' => "text/xml" })

      places = BeermappingApi.places_in("espoo")

      expect(places.size).to eq(1)
      place = places.first
      expect(place.name).to eq("Gallows Bird")
      expect(place.street).to eq("Merituulentie 30")
    end
  end
  
  describe "in case of cache hit" do
    it "When HTTP GET return zero entries, return empty places_in array" do
      canned_answer = <<-END_OF_STRING
      <?xml version='1.0' encoding='utf-8' ?><bmp_locations><location><id></id><name></name><status></status><reviewlink></reviewlink><proxylink></proxylink><blogmap></blogmap><street></street><city></city><state></state><zip></zip><country></country><phone></phone><overall></overall><imagecount></imagecount></location></bmp_locations>
      END_OF_STRING

      stub_request(:get, /.*helsinki/).to_return(body: canned_answer, headers: { 'Content-Type' => "text/xml" })
      places = BeermappingApi.places_in("helsinki")
      expect(places).to be_empty
    end

    it "When HTTP GET returns multiple entries, return them with places_in array" do
      canned_answer = <<-END_OF_STRING
      <?xml version='1.0' encoding='utf-8' ?><bmp_locations><location><id>6742</id><name>Pullman Bar</name><status>Beer bar</status><reviewlink>http://beermapping.com/maps/reviews/reviews.php?locid=6742</reviewlink><proxylink>http://beermapping.com/maps/proxymaps.php?locid=6742&amp;d=5</proxylink><blogmap>http://beermapping.com/maps/blogproxy.php?locid=6742&amp;d=1&amp;type=norm</blogmap><street>Kaivokatu 1</street><city>Helsinki</city><state></state><zip>00100</zip><country>Finland</country><phone></phone><overall>72.500025</overall><imagecount>0</imagecount></location>

<location><id>6743</id><name>Belge</name><status>Beer bar</status><reviewlink>http://beermapping.com/maps/reviews/reviews.php?locid=6743</reviewlink><proxylink>http://beermapping.com/maps/proxymaps.php?locid=6743&amp;d=5</proxylink><blogmap>http://beermapping.com/maps/blogproxy.php?locid=6743&amp;d=1&amp;type=norm</blogmap><street>Kluuvikatu 5</street><city>Helsinki</city><state></state><zip>00100</zip><country>Finland</country><phone></phone><overall>67.499925</overall><imagecount>0</imagecount></location></bmp_locations>
      END_OF_STRING

      stub_request(:get, /.*helsinki/).to_return(body: canned_answer, headers: { 'Content-Type' => "text/xml" })

      places = BeermappingApi.fetch_places_in("helsinki")

      expect(places.size).to eq(2)

      place = places.first
      expect(place.name).to eq("Pullman Bar")
      place = places.last
      expect(place.name).to eq("Belge")
    end
  end
end
