puts "Creating users..."
user_data = [
  { email: "john@example.com", username: "john", first_name: "John", last_name: "Smith", bio: "Passionate about technology and innovation.", avatar: "avatars/avatar-1.png" },
  { email: "jane@example.com", username: "jane", first_name: "Jane", last_name: "Johnson", bio: "Sports enthusiast and amateur photographer.", avatar: "avatars/avatar-2.png" },
  { email: "michael@example.com", username: "michael", first_name: "Michael", last_name: "Williams", bio: "Book lover and coffee addict.", avatar: "avatars/avatar-3.png" },
  { email: "sarah@example.com", username: "sarah", first_name: "Sarah", last_name: "Brown", bio: "Traveler, always planning the next adventure.", avatar: "avatars/avatar-4.png" },
  { email: "david@example.com", username: "david", first_name: "David", last_name: "Jones", bio: "Music lover and occasional guitarist.", avatar: "avatars/avatar-5.png" },
  { email: "lisa@example.com", username: "lisa", first_name: "Lisa", last_name: "Miller", bio: "Cooking enthusiast who loves trying new recipes.", avatar: "avatars/avatar-6.png" },
  { email: "robert@example.com", username: "robert", first_name: "Robert", last_name: "Davis", bio: "Nature lover and hiking enthusiast.", avatar: "avatars/avatar-7.png" },
  { email: "emily@example.com", username: "emily", first_name: "Emily", last_name: "Garcia", bio: "Tech professional with interests in AI and machine learning.", avatar: "avatars/avatar-8.png" },
  { email: "james@example.com", username: "james", first_name: "James", last_name: "Wilson", bio: "Movie buff who enjoys classic films.", avatar: "avatars/avatar-9.png" },
  { email: "linda@example.com", username: "linda", first_name: "Linda", last_name: "Lee", bio: "Fitness enthusiast and nutrition advocate.", avatar: "avatars/avatar-10.png" }
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
      password: "123456"
    )
    if user.save
      if data[:avatar].present? && File.exist?(Rails.root.join("db/seeds/#{data[:avatar]}"))
        user.avatar.attach(
          io: File.open(Rails.root.join("db/seeds/#{data[:avatar]}")),
          filename: File.basename(data[:avatar]),
          content_type: "image/png"
        )
        puts "Attached avatar to user: #{user.email}"
      end
      puts "Created user: #{user.email}"
    else
      puts "Failed to create user #{user.email}: #{user.errors.full_messages.join(', ')}"
    end
  else
    puts "User #{data[:email]} already exists"
  end
  users << user
end

$users = users
