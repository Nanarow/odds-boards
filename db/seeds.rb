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
  "trending", "popular", "new", "hot", "controversial",
  "basketball", "football", "baseball", "soccer",
  "movies", "tv_shows", "music", "gaming",
  "crypto", "stocks", "investment", "analysis"
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
  { title: "Best NBA teams this season", body: "Let's discuss which NBA teams are performing the best this season and why.", state: 0, visibility: 0 },
  { title: "New technology trends for 2025", body: "What are the most exciting technology trends emerging this year?", state: 0, visibility: 0 },
  { title: "Movie recommendations thread", body: "Share your favorite movies and why others should watch them.", state: 0, visibility: 0 },
  { title: "Investment strategies for beginners", body: "What are some good investment strategies for those just starting out?", state: 0, visibility: 0 },
  { title: "Latest political developments", body: "Discussion about recent political events and their implications.", state: 0, visibility: 0 },
  { title: "Must-watch TV shows", body: "What TV shows are you currently binging? Share recommendations here.", state: 0, visibility: 0 },
  { title: "Cryptocurrency market analysis", body: "Let's analyze the current state of the cryptocurrency market.", state: 0, visibility: 0 },
  { title: "Upcoming sports events", body: "What major sports events are you looking forward to in the coming months?", state: 0, visibility: 0 },
  { title: "Tech gadget recommendations", body: "Share your favorite tech gadgets and why you recommend them.", state: 0, visibility: 0 },
  { title: "Stock market predictions", body: "What are your predictions for the stock market in the next quarter?", state: 0, visibility: 0 }
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
      views_count: rand(50..500),
      last_activity_at: Time.now - rand(1..30).days,
      state: data[:state],      # New field: 0 = draft, assuming enum
      visibility: data[:visibility] # New field: 0 = public, assuming enum
    )

    # Add 1-3 random tags to each board (avoid duplicates)
    sample_tags = tags.sample(rand(1..3))
    sample_tags.each do |tag|
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

boards.each do |board|
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

# Create votes if they don't exist
puts "Creating votes..."
boards.each do |board|
  # Add 5-15 votes to each board
  voters = users.sample(rand(5..15))
  voters.each do |voter|
    unless Vote.exists?(voter: voter, votable: board)
      Vote.create!(
        voter: voter,
        votable: board,
        is_upvote: true,  # Only upvotes
        created_at: Time.now - rand(1..30).days
      )
    end
  end

  # Add 3-10 votes to some comments
  board.comments.sample(rand(3..10)).each do |comment|
    voters = users.sample(rand(3..7))
    voters.each do |voter|
      unless Vote.exists?(voter: voter, votable: comment)
        Vote.create!(
          voter: voter,
          votable: comment,
          is_upvote: true,  # Only upvotes
          created_at: Time.now - rand(1..30).days
        )
      end
    end
  end
end

puts "Seed data added successfully!"
puts "Total users: #{User.count}"
puts "Total categories: #{Category.count}"
puts "Total tags: #{Tag.count}"
puts "Total boards: #{Board.count}"
puts "Total taggings: #{Tagging.count}"
puts "Total comments: #{Comment.count}"
puts "Total votes: #{Vote.count}"
