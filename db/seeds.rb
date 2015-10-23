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

flint = Business.create!(name: 'Flintworks',
  address: '958 Old School Road',
  city: 'Frontier City',
  state: 'Oregon',
  url: 'www.example4.com', 
  category: american,
)

binbox = Business.create!(name: 'binBOX',
  address: '8467 Main St',
  city: 'Golding',
  state: 'Virginia',
  url: 'www.example5.com', 
  category: indian,
)


bob = User.create!(name: "Bob", email: "bob@example.com", password: "password", city: 'Sandy', state: 'California', avatar: "face_icons/man6.png")
thadeus = User.create!(name: "Thadeus", email: "thadeus@example.com", password: "password", city: 'Oxford', state: 'Maine', avatar: "face_icons/man5.png")
antilles = User.create!(name: "Antilles", email: "antilles@example.com", password: "password", city: 'Rochester', state: 'Minnesota', avatar: "face_icons/man1.png")
anne = User.create!(name: "Anne Fusioni", email: "anne@example.com", password: "password", city: 'Bolden', state: 'Louisiana', avatar: "face_icons/woman9.png")
jen = User.create!(name: "Jennifer Fullbright", email: "jen@example.com", password: "password", city: 'Chicago', state: 'Illinois', avatar: "face_icons/woman8.png")
tasha = User.create!(name: "Natasha Schoiles", email: "tasha@example.com", password: "password", city: 'Lake City', state: 'Arizona', avatar: "face_icons/woman7.png")

Review.create!(user: bob, rating: 2, business: duck , comment: "Terrible service.")
Review.create!(user: thadeus, rating: 5, business: duck , comment: "Delicious food at a great price.")
Review.create!(user: tasha, rating: 4, business: duck , comment: "This restaurant is awesome.")
Review.create!(user: antilles, rating: 1, business: port , comment: "Hair in my food!")
Review.create!(user: tasha, rating: 4, business: port , comment: "This restaurant is soooooo good.")
Review.create!(user: bob, rating: 2, business: port , comment: "Not worth the wait.")
Review.create!(user: bob, rating: 2, business: steakhouse , comment: "This restaurant is terrible.")
Review.create!(user: thadeus, rating: 3, business: steakhouse , comment: "It's ok. Costs a pretty penny, though.")
Review.create!(user: jen, rating: 1, business: steakhouse , comment: "This restaurant is terrible.")
Review.create!(user: anne, rating: 4, business: flint , comment: "Would dine again.")
Review.create!(user: antilles, rating: 2, business: flint , comment: "Customer service is great. The food was gross.")
Review.create!(user: jen, rating: 4, business: flint , comment: "This restaurant was decent and quiet.")
Review.create!(user: anne, rating: 4, business: binbox , comment: "Loved it!")
Review.create!(user: jen, rating: 5, business: binbox , comment: "This restaurant is awesome.")
Review.create!(user: bob, rating: 1, business: binbox , comment: "Worst experience ever.")
