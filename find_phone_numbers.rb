require './phone_finder'
require 'csv'



CSV.foreach('./hot_pads_extraction_final.csv', {:col_sep => "\t"}) do |row|
  q = [
    row[0],
    row[1],
    row[2],
    row[3],
    row[4]
  ]

  phone_number = PhoneFinder.new(q.join(' ').strip.gsub(/\s+/, '+')).phone_number

  CSV.open("output.csv", "ab") do |csv|
    new_row = (q + [phone_number.to_s] + [row[5]])
     csv << new_row
     puts new_row
  end

end
