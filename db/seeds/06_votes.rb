puts "Creating votes..."
$boards.each do |board|
  # Add 5-15 upvotes to each board
  voters = $users.sample(rand(5..15))
  voters.each do |voter|
    unless Vote.exists?(voter: voter, votable: board)
      Vote.create!(
        voter: voter,
        votable: board,
        is_upvote: true,
        created_at: board.created_at + rand(1..60).days
      )
    end
  end

  # Add 3-10 upvotes to some comments
  board.comments.sample(rand(3..10)).each do |comment|
    voters = $users.sample(rand(3..7))
    voters.each do |voter|
      unless Vote.exists?(voter: voter, votable: comment)
        Vote.create!(
          voter: voter,
          votable: comment,
          is_upvote: true,
          created_at: comment.created_at + rand(1..30).days
        )
      end
    end
  end
end
