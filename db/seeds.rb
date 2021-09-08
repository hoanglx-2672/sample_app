# Create a main sample user.
User.create!(name: "Example User",
    email: "example@gmail.com",
    password: "123456",
    password_confirmation: "123456",
    admin: true)
  # Generate a bunch of additional users.
20.times do |n|
  name = Faker::Name.name
  email = "example-#{n+1}@gmail.com"
  password = "password"
  User.create!(name: name,
    email: email,
    password: password,
    password_confirmation: password)
end
