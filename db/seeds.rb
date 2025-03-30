# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

puts "Adding seed data without removing existing records..."

# Load seed files in order (numeric prefixes ensure correct sequence)
Dir[Rails.root.join('db', 'seeds', '*.rb')].sort.each do |file|
  puts "Loading #{file}..."
  load file
end

puts "Seed data added successfully!"
puts "Total users: #{User.count}"
puts "Total categories: #{Category.count}"
puts "Total tags: #{Tag.count}"
puts "Total boards: #{Board.count}"
puts "Total taggings: #{Tagging.count}"
puts "Total comments: #{Comment.count}"
puts "Total votes: #{Vote.count}"
