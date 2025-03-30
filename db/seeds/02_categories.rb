puts "Creating categories..."
category_data = [
  { name: "Sports", description: "Everything related to sports and athletics." },
  { name: "Entertainment", description: "Movies, TV shows, music, and more." },
  { name: "Technology", description: "Latest tech news, gadgets, and innovations." },
  { name: "Politics", description: "Political discussions and current events." },
  { name: "Finance", description: "Investing, markets, and financial advice." }
]

categories = []
category_data.each do |data|
  category = Category.find_by(name: data[:name])
  if category.nil?
    category = Category.create!(
      creator: $users.sample,
      name: data[:name],
      description: data[:description]
    )
    puts "Created category: #{category.name}"
  else
    puts "Category #{data[:name]} already exists"
  end
  categories << category
end

$categories = categories
