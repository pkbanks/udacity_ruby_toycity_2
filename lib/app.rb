require 'json'
require 'date'

# things to keep in mind:
# • Keep your methods short.
# • include:
# 		- a method that has default values for arguments.
#			- a method that has an options hash.
# • use return values appropriately
# • incorporate methods that make semantic sense

def setup_files
	# taken from udacity instructions
	# will be called by the start method
	path = File.join(File.dirname(__FILE__), '../data/products.json')
	file = File.read(path)
	$products_hash = JSON.parse(file)							# $ denotes a global variable so that it can be accessed outside of the method
	$report_file = File.new("report.txt", "w+")  	# $ denotes a global variable so that it can be accessed outside of the method
end

def create_report
	# will be called by the start method
	
	# Print "Sales Report" in ascii art
	print_sales_report_header

	puts line_break("=", 75)

	# Print today's date
	puts "Date: #{date_today}"

	# Print Products Report
	print_products_report

	# Print Brands Report
	print_brands_report

end

def print_brands_report
	
	# Print "Brands" in ascii art
	print_brands_report_header

end

# --------------- Toy and Product Helper Methods ---------------


def print_products_report(include_header = true)
	# method generates a products report
	# reliant upon the 'items' list in $products_hash file

	print_products_report_header if include_header

	# For each product in the data set:
	$products_hash['items'].each do | toy |
		print_toy_report(toy)
	end

end

def print_toy_report(toy)

	# prints the toy segment of the products report
	# toy = a hash from the $products_hash['items'] array, providing details of a toy

	toy_units_sold = get_toy_units_sold(toy)		# we will use this calculated value a few times

	# Print the name of the toy
	puts toy['title']
	puts line_break()

	# Print the retail price of the toy
	retail_price =  get_toy_price(toy)
	puts "Retail Price: #{format_float_to_string(retail_price, {sym: '$'})}"

	# Calculate and print the total number of purchases
	puts "Total Purchases: #{toy_units_sold}"

	# Calculate and print the total amount of sales
	toy_total_sales = get_toy_total_sales(toy)
	puts "Total Sales: #{format_float_to_string(toy_total_sales, {sym: '$'})}"

	# Calculate and print the average price the toy sold for
	average_price = toy_total_sales/toy_units_sold
	puts "Average Price: #{format_float_to_string(average_price, {sym: '$'})}"

	# Calculate and print the average discount (% or $) based off the average sales price
	toy_average_discount_amount = retail_price - average_price
	puts "Average Discount: #{format_float_to_string(toy_average_discount_amount, {sym: '$'})}"

	toy_average_discount_percent = toy_average_discount_amount / retail_price * 100
	puts "Average Discount Percentage: #{format_float_to_string(toy_average_discount_percent, {sym: '%'})}"

	puts line_break()
	puts ''

end

def print_products_report_header
	# prints a products report header in ascii art
	puts "                     _            _       "
	puts "                    | |          | |      "
	puts " _ __  _ __ ___   __| |_   _  ___| |_ ___ "
	puts "| '_ \\| '__/ _ \\ / _` | | | |/ __| __/ __|"
	puts "| |_) | | | (_) | (_| | |_| | (__| |_\\__ \\"
	puts "| .__/|_|  \\___/ \\__,_|\\__,_|\\___|\\__|___/"
	puts "| |                                       "
	puts "|_|                                       "
	puts ''		# empty line break for bottom margin
end

def get_toy_price(toy)
	# returns a float, the retail price of a toy
	# toy = a hash from the $products_hash['items'] array, providing details of a toy
	return toy['full-price'].to_f
end

def get_toy_units_sold(toy)
	# returns an integer, the quantity sold of a given toy
	# toy = a hash from the $products_hash['items'] array, providing details of a toy
	return toy['purchases'].length
end

def get_toy_total_sales(toy)
	# returns a float, the total proceeds earned from sales of a given toy
	# toy = a hash from the $products_hash['items'] array, providing details of a toy

	total_sales = 0
  
  toy['purchases'].each do |purchase|
    total_sales += purchase['price']
  end
  
  return total_sales

end

# --------------- Brand Helper Methods ---------------

def print_brands_report(include_header = true)

	brand_data = {}		# this is a hash we will use to compile and store
										# toy/product data, aggregated by brand

	# print brands header
	print print_brands_report_header if include_header

	# grab the product and purchase data, arranged by brand
	brand_data = get_brand_data

	# print brand data
	print_brand_data(brand_data)		# we could refactor this, but i like showing the steps taken to populate and utilize the hash
	
end

def get_brand_data


	# this helper method is useful for printing the brands report
	# using the data from the $products_hash file

	# returns a hash with pertinent product and purchase data

	brand_data = {}		# we will populate and return this hash

	# Let's populate our data hash.
	$products_hash['items'].each do | toy |
		# For each product in the data set:
	
		brand = toy['brand']

		# if the brand of the product is not in our hash,
		# add the brand and populate default values
		unless brand_data.has_key? brand
			brand_data[brand] = {}
	    brand_data[brand][:brand_name] = brand
	    brand_data[brand][:toy_count] = 0
	    brand_data[brand][:toy_stock] = 0
	    brand_data[brand][:cumulative_price] = 0  # we will use this to calculate the average price across many toys/products
	    brand_data[brand][:total_revenue] = 0
	  end

	  # add product data to our brand hash
		brand_data[brand][:toy_count] += 1
		brand_data[brand][:toy_stock] += toy['stock']
		brand_data[brand][:cumulative_price] += toy['full-price'].to_f
		
		# for each sale, add the purchase price to our total revenue
		toy['purchases'].each do | purchase |
	  	brand_data[brand][:total_revenue] += purchase['price'].to_f
		end

	end

	return brand_data

end

def print_brand_data(brand_data)
	
	# For each brand in the data set:
	brand_data.each do | brand, data |
		
		# Print the name of the brand
	  puts data[:brand_name].upcase
	  
	  puts line_break
	  
	  # Count and print the number of the brand's toys we stock
		puts "Number of Products: #{data[:toy_stock]}"
	  
	  # Calculate and print the average price of the brand's toys
	  puts "Average price: #{format_float_to_string(data[:cumulative_price] / data[:toy_count], {sym: '$'})}"
	  
	  # Calculate and print the total revenue of all the brand's toy sales combined
	  puts "Total revenue: #{format_float_to_string(data[:total_revenue], {sym: '$'})}"
	  
	  puts line_break
	  puts ''

	end
end

def print_brands_report_header(bottom_margin = true)
	puts " _                         _     "
	puts "| |                       | |    "
	puts "| |__  _ __ __ _ _ __   __| |___ "
	puts "| '_ \\| '__/ _` | '_ \\ / _` / __|"
	puts "| |_) | | | (_| | | | | (_| \\__ \\"
	puts "|_.__/|_|  \\__,_|_| |_|\\__,_|___/"
	puts
	puts ''		# empty line break for bottom margin
end



# --------------- Other Helper Methods ---------------


def print_sales_report_header
	# prints a sales report header in ascii art
	puts "  ____        _             ____                       _   "
	puts " / ___|  __ _| | ___  ___  |  _ \\ ___ _ __   ___  _ __| |_ "
	puts " \\___ \\ / _` | |/ _ \\/ __| | |_) / _ \\ '_ \\ / _ \\| '__| __|"
	puts "  ___) | (_| | |  __/\\__ \\ |  _ <  __/ |_) | (_) | |  | |_ "
	puts " |____/ \\__,_|_|\\___||___/ |_| \\_\\___| .__/ \\___/|_|   \\__|"
	puts "                                     |_|                   "
end


def date_today()
	# returns today's date
	# to print, simply call puts to this method
	t = Date.today
	return t
end

def line_break(break_character = '*', character_length = 20)
	# returns a string of character(s) break_character and length character_length
	# ideal for printing line breaks in report

	# break_character (string) - the character(s) we want to print out
	# character_length (int) - the number of times we print break_character
	
	result = ''

	character_length.times do | character |
		result += break_character
	end

	return result

end

def format_float_to_string(num, opts = {})

	# takes a float (num) and returns a string formatted for printing
	
	opts = { decimals: 2, sym: '' }.merge!(opts)			# defaults to 2-decimals and no symbol (e.g., $, %)

	result = sprintf("%.#{opts[:decimals]}f", num)

	case opts[:sym]
		when '$'
			result = '$' + result
		when '%'
			result = result + '%'
		else
			result = result + ''
	end
	return result
end

# --------------- Execute Here ---------------

def start
  setup_files # load, read, parse, and create the files
  create_report # create the report!
end


start # call start method to trigger report generation
