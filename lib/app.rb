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
	# returns a string that is the report
	# we can 'puts' this method to a file
	# will be called by the start method

	report_string = ''
	
	# Print "Sales Report" in ascii art
	report_string += get_sales_report_header

	report_string += line_break("=", 75) + "\n"		# line break

	# Print today's date
	report_string += "Date: #{date_today}"

	# # Print Products Report
	report_string += get_products_report

	# # Print Brands Report
	report_string += get_brands_report

	return report_string

end

def print_brands_report
	
	# Print "Brands" in ascii art
	print_brands_report_header

end

# --------------- Toy and Product Helper Methods ---------------


def get_products_report(include_header = true)
	# method generates a products report
	# optional argument 'include_header', if true, includes a products header in ascii-art
	# reliant upon the 'items' list in $products_hash file

	report = ''

	report += get_products_report_header if include_header

	# For each product in the data set:
	$products_hash['items'].each do | toy |
		report += get_toy_report(toy)
	end

	return report

end

def get_toy_report(toy)

	# returns a string, the toy segment of the products report
	# toy = a hash from the $products_hash['items'] array, providing details of a toy

	result = ''

	toy_units_sold = get_toy_units_sold(toy)		# we will use this calculated value a few times

	# Print the name of the toy
	result += toy['title'] + "\n"
	result += line_break() + "\n"

	# Print the retail price of the toy
	retail_price =  get_toy_price(toy)
	result += "Retail Price: #{format_float_to_string(retail_price, {sym: '$'})}" + "\n"

	# Calculate and print the total number of purchases
	result += "Total Purchases: #{toy_units_sold}" + "\n"

	# Calculate and print the total amount of sales
	toy_total_sales = get_toy_total_sales(toy)
	result += "Total Sales: #{format_float_to_string(toy_total_sales, {sym: '$'})}" + "\n"

	# Calculate and print the average price the toy sold for
	average_price = toy_total_sales/toy_units_sold
	result += "Average Price: #{format_float_to_string(average_price, {sym: '$'})}" + "\n"

	# Calculate and print the average discount (% or $) based off the average sales price
	toy_average_discount_amount = retail_price - average_price
	result += "Average Discount: #{format_float_to_string(toy_average_discount_amount, {sym: '$'})}" + "\n"

	toy_average_discount_percent = toy_average_discount_amount / retail_price * 100
	result += "Average Discount Percentage: #{format_float_to_string(toy_average_discount_percent, {sym: '%'})}" + "\n"

	result += line_break() + "\n\n"

	return result

end

def get_products_report_header
	# returns a string, a products report header in ascii art
	result = "\n"
	result += "                     _            _       \n"
	result += "                    | |          | |      \n"
	result += " _ __  _ __ ___   __| |_   _  ___| |_ ___ \n"
	result += "| '_ \\| '__/ _ \\ / _` | | | |/ __| __/ __|\n"
	result += "| |_) | | | (_) | (_| | |_| | (__| |_\\__ \\\n"
	result += "| .__/|_|  \\___/ \\__,_|\\__,_|\\___|\\__|___/\n"
	result += "| |                                       \n"
	result += "|_|                                       \n"
	result += "\n"		# empty line break for bottom margin
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

def get_brands_report(include_header = true)

	# returns a string, the brands section of a products report
	# include_header is an optional argument, if true, it includes a ascii-art header
	# requires use of the $products_hash data in the products.json file

	brands_report = ''

	brand_data = {}		# this is a hash we will use to compile and store
										# toy/product data, aggregated by brand

	# print brands header
	brands_report += print_brands_report_header + "\n" if include_header

	# grab the product and purchase data, arranged by brand
	brand_data = get_brand_data

	# print brand data
	brands_report += output_brand_data(brand_data)		# we could refactor this, but i like showing the steps taken to populate and utilize the hash
	
	return brands_report

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

def output_brand_data(brand_data)

	# returns a string, the print out of the brand data report
	output = ''
	
	# For each brand in the data set:
	brand_data.each do | brand, data |
		
		# Print the name of the brand
	  output += data[:brand_name].upcase + "\n"
	  
	  output += line_break + "\n"
	  
	  # Count and print the number of the brand's toys we stock
		output += "Number of Products: #{data[:toy_stock]}" + "\n"
	  
	  # Calculate and print the average price of the brand's toys
	  output += "Average price: #{format_float_to_string(data[:cumulative_price] / data[:toy_count], {sym: '$'})}" + "\n"
	  
	  # Calculate and print the total revenue of all the brand's toy sales combined
	  output += "Total revenue: #{format_float_to_string(data[:total_revenue], {sym: '$'})}" + "\n"
	  
	  output += line_break + "\n\n"

	end

	return output
end

def print_brands_report_header
	# returns a string, the report header in ascii art
	
	header = ''

	header += " _                         _     " + "\n"
	header += "| |                       | |    " + "\n"
	header += "| |__  _ __ __ _ _ __   __| |___ " + "\n"
	header += "| '_ \\| '__/ _` | '_ \\ / _` / __|" + "\n"
	header += "| |_) | | | (_| | | | | (_| \\__ \\" + "\n"
	header += "|_.__/|_|  \\__,_|_| |_|\\__,_|___/" + "\n"
	
end



# --------------- Other Helper Methods ---------------


def get_sales_report_header
	# returns a string, a sales report header in ascii art
	result = ''
	result += "  ____        _             ____                       _   \n"
	result += " / ___|  __ _| | ___  ___  |  _ \\ ___ _ __   ___  _ __| |_ \n"
	result += " \\___ \\ / _` | |/ _ \\/ __| | |_) / _ \\ '_ \\ / _ \\| '__| __|\n"
	result += "  ___) | (_| | |  __/\\__ \\ |  _ <  __/ |_) | (_) | |  | |_ \n"
	result += " |____/ \\__,_|_|\\___||___/ |_| \\_\\___| .__/ \\___/|_|   \\__|\n"
	result += "                                     |_|                   \n"
	return result
end


def date_today(format_args = '%B%e, %Y')
	# returns today's date
	# to print, simply call puts to this method
	# see strftime() documentation for formatting options

	t = Date.today().strftime(format_args)
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
  # create_report # create the report!

  fname = 'report.txt'
  report_file = File.open(fname, 'w')
  report_file.puts create_report
  report_file.close

end


start # call start method to trigger report generation
