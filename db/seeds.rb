# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# Seed data with duplicate prevention
puts "Adding seed data without removing existing records..."

# Create users if they don't exist
puts "Creating users..."
user_data = [
  { email: "john@example.com", username: "john", first_name: "John", last_name: "Smith", bio: "Passionate about technology and innovation." },
  { email: "jane@example.com", username: "jane", first_name: "Jane", last_name: "Johnson", bio: "Sports enthusiast and amateur photographer." },
  { email: "michael@example.com", username: "michael", first_name: "Michael", last_name: "Williams", bio: "Book lover and coffee addict." },
  { email: "sarah@example.com", username: "sarah", first_name: "Sarah", last_name: "Brown", bio: "Traveler, always planning the next adventure." },
  { email: "david@example.com", username: "david", first_name: "David", last_name: "Jones", bio: "Music lover and occasional guitarist." },
  { email: "lisa@example.com", username: "lisa", first_name: "Lisa", last_name: "Miller", bio: "Cooking enthusiast who loves trying new recipes." },
  { email: "robert@example.com", username: "robert", first_name: "Robert", last_name: "Davis", bio: "Nature lover and hiking enthusiast." },
  { email: "emily@example.com", username: "emily", first_name: "Emily", last_name: "Garcia", bio: "Tech professional with interests in AI and machine learning." },
  { email: "james@example.com", username: "james", first_name: "James", last_name: "Wilson", bio: "Movie buff who enjoys classic films." },
  { email: "linda@example.com", username: "linda", first_name: "Linda", last_name: "Lee", bio: "Fitness enthusiast and nutrition advocate." },
  { email: "admin@example.com", username: "admin", first_name: "Admin", last_name: "User", bio: "System administrator" }
]

users = []
user_data.each do |data|
  user = User.find_by(email: data[:email])
  if user.nil?
    # With Devise, you can create a user with password directly, and it will hash it
    user = User.new(
      email: data[:email],
      username: data[:username],
      first_name: data[:first_name],
      last_name: data[:last_name],
      bio: data[:bio],
      password: "123456" # Devise will handle the password hashing
    )
    if user.save
      puts "Created user: #{user.email}"
    else
      puts "Failed to create user #{user.email}: #{user.errors.full_messages.join(', ')}"
    end
  else
    puts "User #{data[:email]} already exists"
  end
  users << user
end

# Create categories if they don't exist
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
      creator: users.sample,
      name: data[:name],
      description: data[:description]
    )
    puts "Created category: #{category.name}"
  else
    puts "Category #{data[:name]} already exists"
  end
  categories << category
end

# Create tags if they don't exist
puts "Creating tags..."
tag_names = [
  "Trending", "Popular", "New", "Hot", "Controversial",
  "Basketball", "Football", "Baseball", "Soccer",
  "Movies", "TV Shows", "Music", "Gaming",
  "Crypto", "Stocks", "Investment", "Analysis"
]

tags = []
tag_names.each do |name|
  tag = Tag.find_by(name: name.downcase.humanize)
  if tag.nil?
    tag = Tag.create!(
      creator: users.sample,
      name: name
    )
    puts "Created tag: #{tag.name}"
  else
    puts "Tag #{name} already exists"
  end
  tags << tag
end

# Create boards if they don't exist
puts "Creating boards..."
board_data = [
  { title: "Best NBA teams this season", body: "Let's discuss which NBA teams are performing the best this season and why." },
  { title: "New technology trends for 2023", body: "What are the most exciting technology trends emerging this year?" },
  { title: "Movie recommendations thread", body: "Share your favorite movies and why others should watch them." },
  { title: "Investment strategies for beginners", body: "What are some good investment strategies for those just starting out?" },
  { title: "Latest political developments", body: "Discussion about recent political events and their implications." },
  { title: "Must-watch TV shows", body: "What TV shows are you currently binging? Share recommendations here." },
  { title: "Cryptocurrency market analysis", body: "Let's analyze the current state of the cryptocurrency market." },
  { title: "Upcoming sports events", body: "What major sports events are you looking forward to in the coming months?" },
  { title: "Tech gadget recommendations", body: "Share your favorite tech gadgets and why you recommend them." },
  { title: "Stock market predictions", body: "What are your predictions for the stock market in the next quarter?" }
]

boards = []
board_data.each do |data|
  board = Board.find_by(title: data[:title])
  if board.nil?
    board = Board.create!(
      author: users.sample,
      category: categories.sample,
      title: data[:title],
      body: data[:body],
      status: [ "draft", "published" ].sample,
      upvotes_count: rand(0..100),
      views_count: rand(50..500),
      last_activity_at: Time.now - rand(1..30).days
    )

    # Add 1-3 random tags to each board (avoid duplicates)
    sample_tags = tags.sample(rand(1..3))
    sample_tags.each do |tag|
      # Check if this tagging already exists
      unless Tagging.exists?(board: board, tag: tag)
        Tagging.create!(board: board, tag: tag)
        puts "Tagged board '#{board.title}' with '#{tag.name}'"
      end
    end

    puts "Created board: #{board.title}"
  else
    puts "Board '#{data[:title]}' already exists"
  end
  boards << board
end

# Create comments if they don't exist
puts "Creating comments..."
comment_texts = [
  "I completely agree with your points.",
  "Thanks for sharing this information!",
  "I have a different perspective on this issue.",
  "This is really interesting to consider.",
  "Could you elaborate more on your third point?",
  "I've been following this topic for a while, and I think you're spot on.",
  "Have you considered the alternative view?",
  "This is exactly what I needed to hear today.",
  "I'm not sure I agree, but I appreciate your viewpoint.",
  "Great analysis! You've given me a lot to think about."
]

# Only add comments to boards created in this seed run
boards.each do |board|
  # If the board already has comments, skip it
  if board.comments.any?
    puts "Board '#{board.title}' already has comments, skipping"
    next
  end

  # Create 2-5 top-level comments
  rand(2..5).times do
    parent_comment = Comment.create!(
      board: board,
      commenter: users.sample,
      body: comment_texts.sample,
      depth: 0
    )

    # Create 0-3 replies for each top-level comment
    rand(0..3).times do
      child_comment = Comment.create!(
        board: board,
        commenter: users.sample,
        parent: parent_comment,
        body: comment_texts.sample,
        depth: 1
      )

      # Create 0-2 replies for each second-level comment
      rand(0..2).times do
        Comment.create!(
          board: board,
          commenter: users.sample,
          parent: child_comment,
          body: comment_texts.sample,
          depth: 2
        )
      end
    end
  end
  puts "Added comments to board: #{board.title}"
end

puts "Seed data added successfully!"
puts "Total users: #{User.count}"
puts "Total categories: #{Category.count}"
puts "Total tags: #{Tag.count}"
puts "Total boards: #{Board.count}"
puts "Total taggings: #{Tagging.count}"
puts "Total comments: #{Comment.count}"
