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

$boards.each do |board|
  if board.comments.any?
    puts "Board '#{board.title}' already has comments, skipping"
    next
  end

  # Create 2-5 top-level comments
  rand(2..5).times do
    created_at = board.created_at + rand(1..5).days
    parent_comment = Comment.create!(
      board: board,
      commenter: $users.sample,
      body: comment_texts.sample,
      depth: 0,
      created_at: created_at,
      updated_at: created_at
    )

    # Create 0-3 replies
    rand(0..3).times do
      child_created_at = parent_comment.created_at + rand(1..5).days
      child_comment = Comment.create!(
        board: board,
        commenter: $users.sample,
        parent: parent_comment,
        body: comment_texts.sample,
        depth: 1,
        created_at: child_created_at,
        updated_at: child_created_at
      )

      # Create 0-2 replies
      rand(0..2).times do
        grandchild_created_at = child_comment.created_at + rand(1..5).days
        Comment.create!(
          board: board,
          commenter: $users.sample,
          parent: child_comment,
          body: comment_texts.sample,
          depth: 2,
          created_at: grandchild_created_at,
          updated_at: grandchild_created_at
        )
      end
    end
  end
  puts "Added comments to board: #{board.title}"
end
