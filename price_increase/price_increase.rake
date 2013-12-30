require 'csv'

task :prices do
    
    CSV.foreach("./n.csv", { headers: false }) do |csv|
      puts csv[1]
    end
    

    # CSV.open("#{Rails.root}/lib/data/beresford_product_list_output.csv", "w") do |csv|
    #   products.each do |product|
    #     csv << [product.css('td')[0].content.strip, product.css('td')[1].content.strip, product.css('td')[2].content.strip]
    #     puts csv
    #   end
    # end
    
end