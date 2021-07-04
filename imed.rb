require 'csv'
require 'json'

new_arr = []

table = CSV.parse(File.read("7.csv").scrub, headers: true)

for row in table do
  new_row = []
  row.each_with_index do |attribute, index|
    # Date
    if index == 4
      new_row << Date.parse(row[4].split("t")[0])
    # Image
    elsif index == 5
      if attribute[1] == nil
        new_row << "False"
      else
        new_row << "True"
      end
    # Sitename, City
    elsif index == 6
      if attribute[1] == nil
        new_row << " "
        new_row << " "
      else
        parsed = JSON.parse(attribute[1])
        if parsed[0]["name"] == nil
          new_row << " "
        else
          if attribute[1].include?("amazon")
            new_row << "amazon"
          elsif attribute[1].include?("ebay")
            new_row << "ebay"
          else
            new_row << attribute[1].downcase.gsub("www.", "").gsub(".com","")
          end
        end

        if parsed[0]["city"] == nil
          new_row << " "
        else
          new_row << parsed[0]["city"].downcase
        end
      end
    #Price
    elsif index == 8
      new_row << attribute[1].to_f
    elsif index == 11
      if attribute[1] == "TRUE"
        new_row << "TRUE"
      else
        new_row << "FALSE"
      end
    elsif index == 12
      if attribute[1] == nil
        new_row << "FALSE"
      else
        if attribute[1].downcase == "free" || attribute[1] == "FREE Shipping. FREE Returns."
          new_row << "TRUE"
        else
          new_row << "CONDITIONAL"
        end
      end
    else
      if attribute[1] == nil
        new_row << attribute[1]
      else
        new_row << attribute[1].downcase
      end
    end
  end
  new_arr << new_row
end

sorted = new_arr.sort {|a,b| b[9] <=> a[9]}

CSV.open("final.csv", "w") do |csv|
  for x in sorted do
    csv << x
  end
end
