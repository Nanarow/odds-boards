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
      password: "123456"
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

$users = users
