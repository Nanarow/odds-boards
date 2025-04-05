puts "Creating boards..."
board_data = [
  { title: "Best NBA teams this season", body: "Let's discuss which NBA teams are performing the best this season and why." },
  { title: "New technology trends for 2025", body: "What are the most exciting technology trends emerging this year?" },
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
    created_at = Time.now - rand(1..90).days
    board = Board.create!(
      author: $users.sample,
      category: $categories.sample,
      title: data[:title],
      body: data[:body],
      state: rand(0..1),       # 0: is_draft, 1: is_published
      visibility: rand(0..1),  # 0: is_private, 1: is_public
      created_at: created_at,
      updated_at: created_at
    )

    # Add 1-3 random tags
    sample_tags = $tags.sample(rand(1..3))
    sample_tags.each do |tag|
      unless Tagging.exists?(board: board, tag: tag)
        Tagging.create!(board: board, tag: tag)
        puts "Tagged board '#{board.title}' with '#{tag.name}'"
      end
    end

    puts "Created board: #{board.title} (State: #{board.state}, Visibility: #{board.visibility})"
  else
    puts "Board '#{data[:title]}' already exists"
  end
  boards << board
end

$boards = boards
