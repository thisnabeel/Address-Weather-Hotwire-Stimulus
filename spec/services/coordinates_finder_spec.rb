# spec/services/coordinates_finder_spec.rb
require 'rails_helper'
require 'webmock/rspec'

RSpec.describe CoordinatesFinder, type: :service do
  describe '.call' do
    it 'returns coordinates for a valid place_id' do
      place_id = 'ChIJ674hC6Y_WBQRujtC6Jay33k'

      # Stub the HTTP request using WebMock
      stub_request(:get, /maps.googleapis.com/).
        with(query: hash_including(place_id: place_id, key: ENV['GOOGLE_MAPS_API_KEY'])).
        to_return(
          body: {
            status: 'OK',
            results: [
              {
                geometry: {
                  location: {
                    lat: 30.0444196,
                    lng: 31.2357116
                  }
                }
              }
            ]
          }.to_json,
          headers: { 'Content-Type': 'application/json' }
        )

      coordinates = CoordinatesFinder.call(place_id)
      expect(coordinates).to eq('30.0444196,31.2357116')
    end

    it 'returns nil for an invalid place_id' do
      place_id = 'InvalidPlaceID'

      # Stub the HTTP request with an error response
      stub_request(:get, /maps.googleapis.com/).
        to_return(body: { status: 'INVALID_REQUEST' }.to_json, headers: { 'Content-Type': 'application/json' })

      coordinates = CoordinatesFinder.call(place_id)
      expect(coordinates).to be_nil
    end
  end
end