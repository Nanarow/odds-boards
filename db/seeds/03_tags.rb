puts "Creating tags..."
tag_names = [
  "trending", "popular", "new", "hot", "controversial",
  "basketball", "football", "baseball", "soccer",
  "movies", "tv_shows", "music", "gaming",
  "crypto", "stocks", "investment", "analysis"
]

tags = []
tag_names.each do |name|
  tag = Tag.find_by(name: name)
  if tag.nil?
    tag = Tag.create!(
      creator: $users.sample,
      name: name
    )
    puts "Created tag: #{tag.name}"
  else
    puts "Tag #{name} already exists"
  end
  tags << tag
end

$tags = tags
