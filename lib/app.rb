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

	# Print today's date
	puts date_today

	# Print "Products" in ascii art
	prints_products_report_header

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

def date_today()
	# returns today's date
	# to print, simply call puts to this method
	t = Date.today
	return t
end

def prints_products_report_header
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


# For each product in the data set:
	# Print the name of the toy
	# Print the retail price of the toy
	# Calculate and print the total number of purchases
	# Calculate and print the total amount of sales
	# Calculate and print the average price the toy sold for
	# Calculate and print the average discount (% or $) based off the average sales price

# Print "Brands" in ascii art

# For each brand in the data set:
	# Print the name of the brand
	# Count and print the number of the brand's toys we stock
	# Calculate and print the average price of the brand's toys
	# Calculate and print the total sales volume of all the brand's toys combined

def start
  setup_files # load, read, parse, and create the files
  create_report # create the report!
end

start # call start method to trigger report generation

