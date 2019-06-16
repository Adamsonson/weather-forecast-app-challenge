require 'net/http'
require 'json'
require 'httparty'

class City < ApplicationRecord
  before_save :downcase_name
  validate :city_exist?
  # before_create :add_timezone
  validates :name, presence: true, uniqueness: { case_sensitive: false }, length: { maximum: 40 }

  class << self
    # Retrieves the weather json
    def get_weather(name, type = 'forecast')
      api_key = '9a7b845155f83f747b6d779db8d8e652'

      # TODO: Change units based on locale
      uri = URI("http://api.openweathermap.org/data/2.5/#{type}?q=#{URI.encode(name)}&units=metric&appid=#{api_key}")

      # Download and parse the JSON from the api
      res = JSON.parse(Net::HTTP.get(uri))
    end

    # Revtrieves the photo url from api
    def get_city_picture(name)
      name = name.strip.gsub!(/\s/, '-') if name =~ /\s/
      uri = URI("https://api.teleport.org/api/urban_areas/slug:#{URI.encode(name)}/images/")

      pho = JSON.parse(Net::HTTP.get(uri))

      pho = pho["photos"][0]["image"]["web"]
    end
  end

private

  # Converts city name to all lower-case.
  def downcase_name
    name.downcase!
  end

  # Checks if inserted city exists
  def city_exist?
    return false if self.payload.nil?
    if (self.payload['cod'] == '404')
      self.errors[:base] << 'city does not exist'
    else
      true
    end
  end

  # Lookup the correct timezone based on the latitude and longitude. (https://github.com/panthomakos/timezone)
  def add_timezone
    res = City.get_weather(name)

    begin
      self.timezone = Timezone.lookup(res['city']['coord']['lat'], res['city']['coord']['lon']).name
    rescue Timezone::Error::Base => e
      puts "Timezone Error: #{e.message}"
    end
  end
end
