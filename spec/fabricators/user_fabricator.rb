Fabricator(:user) do
  name {Faker::Name.name}
  email { sequence(:email) { |i| "user#{i}@example.com" } }
  city {Faker::Address.city}
  state {Faker::Address.state}
  password 'password'
  avatar {"/assets/face_icons/man6.png"}
end