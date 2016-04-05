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
	puts date_today

	# Print "Products" in ascii art
	print_products_report_header

	puts ''		# empty line break

	# Print Products Report
	print_products_report

	# Print Brands Report
	print_brands_report

end


def print_sales_report_header
	# prints a sales report header in ascii art
	puts "  ____        _             ____                       _   "
	puts " / ___|  __ _| | ___  ___  |  _ \\ ___ _ __   ___  _ __| |_ "
	puts " \\___ \\ / _` | |/ _ \\/ __| | |_) / _ \\ '_ \\ / _ \\| '__| __|"
	puts "  ___) | (_| | |  __/\\__ \\ |  _ <  __/ |_) | (_) | |  | |_ "
	puts " |____/ \\__,_|_|\\___||___/ |_| \\_\\___| .__/ \\___/|_|   \\__|"
	puts "                                     |_|                   "
end

def print_products_report
	# method generates a products report
	# reliant upon the 'items' list in $products_hash file

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
	puts "Retail Price: $#{sprintf('%.2f', retail_price)}"

	# Calculate and print the total number of purchases
	puts "Total Purchases: #{toy_units_sold}"

	# Calculate and print the total amount of sales
	toy_total_sales = get_toy_total_sales(toy)
	puts "Total Sales: $#{sprintf('%.2f', toy_total_sales)}"

	# Calculate and print the average price the toy sold for
	average_price = toy_total_sales/toy_units_sold
	puts "Average Price: $#{sprintf('%.2f', average_price)}"

	# Calculate and print the average discount (% or $) based off the average sales price
	toy_average_discount_amount = retail_price - average_price
	puts "Average Discount: $#{sprintf('%.2f',toy_average_discount_amount)}"

	toy_average_discount_percent = toy_average_discount_amount / retail_price * 100
	puts "Average Discount Percentage: #{sprintf('%.2f',toy_average_discount_percent)}%"

	puts line_break()
	puts ''

end

def print_brands_report
	
	# Print "Brands" in ascii art
	print_brands_report_header

end

# --------------- Toy and Product Helper Methods ---------------

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


def print_brands_report_header
	puts " _                         _     "
	puts "| |                       | |    "
	puts "| |__  _ __ __ _ _ __   __| |___ "
	puts "| '_ \\| '__/ _` | '_ \\ / _` / __|"
	puts "| |_) | | | (_| | | | | (_| \\__ \\"
	puts "|_.__/|_|  \\__,_|_| |_|\\__,_|___/"
	puts
end


# For each brand in the data set:
	# Print the name of the brand
	# Count and print the number of the brand's toys we stock
	# Calculate and print the average price of the brand's toys
	# Calculate and print the total sales volume of all the brand's toys combined



# --------------- Other Helper Methods ---------------

def date_today()
	# returns today's date
	# to print, simply call puts to this method
	t = Date.today
	return t
end

def line_break(break_character = '*', character_length = 20)
	# returns a string of break_character and length character_length
	# ideal for printing line breaks in report

	# break_character (string) - the character(s) we want to print out
	# character_length (int) - the number of times we print break_character
	
	result = ''

	character_length.times do | character |
		result += break_character
	end

	return result

end

# --------------- Execute Here ---------------

def start
  setup_files # load, read, parse, and create the files
  create_report # create the report!
end


start # call start method to trigger report generation
# scratchpad

