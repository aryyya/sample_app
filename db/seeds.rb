User.create!(
  name: 'Example User',
  email: 'user@example.com',
  password: 'password',
  password_confirmation: 'password',
  admin: true,
  activated: true,
  activated_at: Time.zone.now)

99.times do |n|
  name = Faker::Name.name
  email = "#{name.gsub(/[^0-9a-z]/i, '').downcase}@example.com"
  password = 'password'
  User.create!(
    name: name,
    email: email,
    password: password,
    password_confirmation: password,
    activated: true,
    activated_at: Time.zone.now)
end

users = User.order(:created_at).take(6)
50.times do
  content = Faker::Lorem.sentence(5)
  users.each { |user| user.microposts.create!(content: content) }
end
