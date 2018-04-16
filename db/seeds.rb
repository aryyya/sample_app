User.create!(name: 'Example User', email: 'user@example.com', password: 'password', password_confirmation: 'password')

249.times do |n|
  name = Faker::Name.name
  email = "#{name.gsub(/[^0-9a-z]/i, '').downcase}@example.com"
  password = 'password'
  User.create!(name: name, email: email, password: password, password_confirmation: password)
end
