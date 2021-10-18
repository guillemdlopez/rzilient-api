# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Laptop.destroy_all

laptop_names = ['Macbook Pro 13', 'Lenovo Thinkpad', 'HP 850 G5']
laptop_codes = ['AP1', 'LN1', 'HP1']
laptop_prices = [60, 41, 39]


puts "Generating some test data..."

laptop_names.each_with_index do |laptop, i|
    Laptop.create!(code: laptop_codes[i], name: laptop, price: laptop_prices[i])
end


puts "We are done! :)"
puts "#{Laptop.count} laptops were created!"