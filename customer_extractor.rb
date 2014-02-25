require 'csv'
require 'open-uri'
require 'capybara'
require 'capybara-webkit'
require './tor'
require 'pry'

Capybara.run_server = false
Capybara.current_driver = :webkit
Capybara.app_host = "http://hotpads.com/"


class HotPads

  include Capybara::DSL

  def parse page_num = 1
    visit(search_url(page_num))
    sleep 1

    # begin
      page.click_on 'more info'
      [
        (page.find('#propertyName').text rescue ''),
        page.find('div#propertyInformation div#address div.street-address').text,
        page.find('div#mainInfo div#propertyInformation div#address span.locality').text,
        page.find('div#mainInfo div#propertyInformation div#address span.region').text,
        page.find('div#mainInfo div#propertyInformation div#address span.postal-code').text,
        (page.find('div#mainInfo div#propertyInformation').text.scan(/Property size: [0-9]*/).first.gsub(/\D/, '') rescue '')
      ]
  end

  private

    def coordinates
      {
        sea: {
          min_lat: '43.6437421854845',
          max_lat: '50.66662386577475',
          min_lon: '-131.37282954545447',
          max_lon: '-110.27907954545447',
          lat:     '47.155183025629626',
          lon:     '-120.82595454545447'
        },
        slc: {
          min_lat: '37.319255873094725',
          max_lat: '41.60864226722881',
          min_lon: '-116.81867840909104',
          max_lon: '-111.19917157315354',
          lat:     '39.49702272727275',
          lon:     '-114.00892499112229'
        }
      }
    end

    # Hot Pad's Washington Default Search
    def search_url page_num, region = :slc
      'search#' +
      "page=#{page_num}&" +
      'resultsPerPage=1&' +
      'searcher=text&' +
      'dupeGrouping=building&' +
      "minLat=#{coordinates[region][:min_lat]}&" +
      "maxLat=#{coordinates[region][:max_lat]}&" +
      "minLon=#{coordinates[region][:min_lon]}&" +
      "maxLon=#{coordinates[region][:max_lon]}&" +
      "lat=#{coordinates[region][:lat]}&" +
      "lon=#{coordinates[region][:lon]}&" +
      'zoom=15&' +
      'locationName=&previewId=&' +
      'previewType=none&' +
      'detailsOpen=false&' +
      'includeVaguePricing=false&' +
      'listingTypes=rental,&' +
      'propertyTypes=medium,large,garden,&' +
      'dupeGrouping=building'
    end

end

hot_pads = HotPads.new

CSV.open("hot_pads_extraction.csv", "w") do |csv|
  csv << %w[property_name street_address city state zip_code unit count]
  (201..219).each do |num|
    array = hot_pads.parse(num)
    puts "page number: #{num}"
    puts array
    Tor.switch_endpoint if num % 100 == 0
    unless array.to_a.empty?
      csv << array
    end
  end
end
