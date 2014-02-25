require 'open-uri'
require 'nokogiri'

class PhoneFinder
  def initialize(q)
    @q = q
    @doc = nil
  end

  def phone_number
    most_common_phone_number
  end

  def phone_numbers
    get_phone_numbers
  end

  private
    def phone_regex
      {
        sea: /[2-4|8][0|2|5|6|7|8][0|3|5|6|7|8](?:\)\ |[^0-9])[0-9]{3}[^0-9][0-9]{4}/,
        slc: /[3|4|8][0|3|8][0|1|5|6|7|8](?:\)\ |[^0-9])[0-9]{3}[^0-9][0-9]{4}/
      }
    end

    def get_phone_numbers
      html = doc.to_s.encode!('UTF-16', 'UTF-8', :invalid => :replace, :replace => '')
      html = html.encode!('UTF-8', 'UTF-16')
      html.scan(phone_regex[:slc])
         .map{ |v| v.gsub(/[^0-9]/, '') }

    end

    def first_phone_number
      if get_phone_numbers
        get_phone_numbers.to_a.first
      end
    end

    def most_common_phone_number
      if get_phone_numbers
        get_phone_numbers.group_by do |number|
          number
        end.values.max_by(&:size).to_a.first
      else
        ''
      end
    end

    def q
      queryfy(@q)
    end

    def queryfy string
      string.gsub(' ', '+')
    end

    def search_url
      "https://www.google.com/" +
      "search?q=#{q}" +
      "&safe=active"
    end

    def doc
      @doc ||= Nokogiri::HTML(open(search_url))
    end

end
