require 'csv'
require 'open-uri'
require 'capybara'
require 'capybara-webkit'
require 'pry'
require 'nokogiri'

Capybara.run_server = false
Capybara.current_driver = :webkit
Capybara.app_host = "https://tools.usps.com/"

class AddressVerifier
  include Capybara::DSL 
  
  def self.parse(address)
    visit(search_url(address))
    
    if page.has_content?('Unfortunately')
      address = Address.new
    else
      doc = Nokogiri::HTML(page.html).css('#result-list')
      address = Address.new
      address.line1               = doc.css('.address1').text
      address.city                = doc.css('.city').text
      address.state               = doc.css('.state').text
      address.zip_code            = doc.css('.zip').text
      address.zip_code_4          = doc.css('.zip4').text
      address.delivery_point_code = doc.css('.details').css('dd')[2].text
      address.check_digit         = doc.css('.details').css('dd')[3].text
    end
    address
  end

  private
    
    def self.search_url address
      "go/ZipLookupResultsAction!input.action?" + 
      "resultMode=0&" +
      "companyName=&" +
      "address1=#{address.line1}&" +
      "address2=&" +
      "city=#{address.city}&" +
      "state=#{address.state}&" +
      "urbanCode=&" +
      "postalCode=#{address.zip_code}" +
      "&zip="
    end

end

class Address < Struct.new(:line1, :city, :state, :zip_code, :zip_code_4, 
                           :delivery_point_code, :check_digit)
  def delivery_point
    "#{zip_code}#{zip_code_4}#{delivery_point_code}#{check_digit}"
  end
end
