Fabricator(:user) do
  name {Faker::Name.name}
  email {Faker::Internet.email}
  password 'password'
  avatar {"/assets/face_icons/man6.png"}
end