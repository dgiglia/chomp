# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

italian = Category.create!(name: 'Italian')
indian = Category.create!(name: 'Indian')
american = Category.create!(name: 'American')
chinese = Category.create!(name: 'Chinese')
thai = Category.create!(name: 'Thai')
brazilian = Category.create!(name: 'Brazilian')
japanese = Category.create!(name: 'Japanese')
french = Category.create!(name: 'French')

duck = Business.create!(name: 'The Little Duck',
  address: '456 Place Avenue',
  city: 'Borisville',
  state: 'Indiana',
  url: 'www.example.com', 
  category: chinese,
)

port = Business.create!(name: 'Port 1521',
  address: '1521 Park Avenue',
  city: 'New York',
  state: 'New York',
  url: 'www.example2.com', 
  category: french,
)

steakhouse = Business.create!(name: 'Steakhouse 66',
  address: '42 Sile Street',
  city: 'Frogbottom',
  state: 'Florida',
  url: 'www.example3.com', 
  category: american,
)


bob = User.create!(name: "Bob", email: "bob@example.com", password: "password", city: 'Sandy', state: 'California', avatar: "/assets/face_icons/man6.png")
thadeus = User.create!(name: "Thadeus", email: "thadeus@example.com", password: "password", city: 'Oxford', state: 'Maine', avatar: "/assets/face_icons/man5.png")
antilles = User.create!(name: "Antilles", email: "antilles@example.com", password: "password", city: 'Rochester', state: 'Minnesota', avatar: "/assets/face_icons/man1.png")

Review.create!(user: bob, rating: 2, business: duck , comment: "This restaurant is terrible.")
Review.create!(user: thadeus, rating: 5, business: duck , comment: "This restaurant is awesome.")
Review.create!(user: antilles, rating: 2, business: port , comment: "This restaurant is terrible.")
Review.create!(user: bob, rating: 4, business: port , comment: "This restaurant is awesome.")
Review.create!(user: bob, rating: 2, business: steakhouse , comment: "This restaurant is terrible.")
Review.create!(user: thadeus, rating: 3, business: steakhouse , comment: "This restaurant is awesome.")
