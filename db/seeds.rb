# Create a main sample user.
User.create!(name: "Example User",
    email: "example@gmail.com",
    password: "123456",
    password_confirmation: "123456",
    admin: true,
    activated: true,
    activated_at: Time.zone.now)
  # Generate a bunch of additional users.
40.times do |n|
  name = Faker::Name.name
  email = "example-#{n+1}@gmail.com"
  password = "password"
  User.create!(name: name,
    email: email,
    password: password,
    password_confirmation: password,
    activated: true,
    activated_at: Time.zone.now)
end
