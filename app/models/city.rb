require 'net/http'
require 'json'
require 'faker'

class City < ApplicationRecord
  belongs_to :user

  before_save :downcase_name
  validate :city_exist?
  # before_create :add_timezone
  validates :name, presence: true, uniqueness: { case_sensitive: false }, length: { maximum: 40 }

  class << self
    def get_weather(name, type = 'forecast')
      api_key = '9a7b845155f83f747b6d779db8d8e652'

      uri = URI("http://api.openweathermap.org/data/2.5/#{type}?q=#{CGI.escape(name)}&units=metric&appid=#{api_key}")

      res = JSON.parse(Net::HTTP.get(uri))
    end

    # Revtrieves the photo url from api
    def get_city_picture(name)
      name = name.strip.gsub!(/\s/, '-') if name =~ /\s/
      uri = URI("https://api.teleport.org/api/urban_areas/slug:#{CGI.escape(name)}/images/")

      pho = JSON.parse(Net::HTTP.get(uri))

      if pho['status'] == 404
        pho = "https://www.touropia.com/gfx/d/small-towns-in-brazil/iguape.jpg?v=98b61a48722deeff9138c5d25a96bc12"
      else
        pho = pho["photos"][0]["image"]["web"]
      end
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

  # Lookup the correct timezone based on the latitude and longitude. (https://github.com/panthomakos/timezone) -not working, still need to finish
  def add_timezone
    res = City.get_weather(name)

    begin
      self.timezone = Timezone.lookup(res['city']['coord']['lat'], res['city']['coord']['lon']).name
    rescue Timezone::Error::Base => e
      puts "Timezone Error: #{e.message}"
    end
  end
end
