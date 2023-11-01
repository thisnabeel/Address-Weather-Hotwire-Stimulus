# spec/services/address_suggestor_spec.rb
require 'rails_helper'
require 'webmock/rspec'

RSpec.describe AddressSuggestor, type: :service do
  describe '.call' do
    it 'returns suggestions for a valid address' do
      address = '1600 Amphitheatre Parkway, Mountain View, CA'

      # Stub the HTTP request using WebMock
      stub_request(:get, /maps.googleapis.com/).
        with(query: hash_including(input: address.parameterize, key: ENV['GOOGLE_MAPS_API_KEY'])).
        to_return(
          body: {
            predictions: [
              { description: 'Some suggestion' },
              { description: 'Another suggestion' }
            ]
          }.to_json,
          headers: { 'Content-Type': 'application/json' }
        )

      suggestions = AddressSuggestor.call(address)

      expect(suggestions).to be_an(Array)
      expect(suggestions.size).to eq(2)
      expect(suggestions.first['description']).to eq('Some suggestion')
      expect(suggestions.last['description']).to eq('Another suggestion')
    end

    it 'returns an empty array for an invalid address' do
      address = 'Invalid Address'

      # Stub the HTTP request with an empty response
      stub_request(:get, /maps.googleapis.com/).
        to_return(body: { predictions: [] }.to_json, headers: { 'Content-Type': 'application/json' })

      suggestions = AddressSuggestor.call(address)

      expect(suggestions).to be_an(Array)
      expect(suggestions).to be_empty
    end
  end
end