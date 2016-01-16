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
  approved: true,
)

port = Business.create!(name: 'Port 1521',
  address: '1521 Park Avenue',
  city: 'New York',
  state: 'New York',
  url: 'www.example2.com', 
  category: french,
  approved: true,
)

steakhouse = Business.create!(name: 'Steakhouse 66',
  address: '42 Sile Street',
  city: 'Frogbottom',
  state: 'Florida',
  url: 'www.example3.com', 
  category: american,
  approved: true,
)

flint = Business.create!(name: 'Flintworks',
  address: '958 Old School Road',
  city: 'Frontier City',
  state: 'Oregon',
  url: 'www.example4.com', 
  category: american,
  approved: true,
)

binbox = Business.create!(name: 'binBOX',
  address: '8467 Main St',
  city: 'Golding',
  state: 'Virginia',
  url: 'www.example5.com', 
  category: indian,
  approved: true,
)


bob = User.create!(name: "Bob", email: "bob@example.com", password: "password", city: 'Sandy', state: 'California', avatar: "face_icons/man6.png")
thadeus = User.create!(name: "Thadeus", email: "thadeus@example.com", password: "password", city: 'Oxford', state: 'Maine', avatar: "face_icons/man5.png")
antilles = User.create!(name: "Antilles", email: "antilles@example.com", password: "password", city: 'Rochester', state: 'Minnesota', avatar: "face_icons/man1.png")
anne = User.create!(name: "Anne Fusioni", email: "anne@example.com", password: "password", city: 'Bolden', state: 'Louisiana', avatar: "face_icons/woman9.png")
jen = User.create!(name: "Jennifer Fullbright", email: "jen@example.com", password: "password", city: 'Chicago', state: 'Illinois', avatar: "face_icons/woman8.png")
tasha = User.create!(name: "Natasha Schoiles", email: "tasha@example.com", password: "password", city: 'Lake City', state: 'Arizona', avatar: "face_icons/woman7.png")
admin = User.create!(name: "General Organa", email: "admin@example.com", password: "admin", city: 'Alderaan', state: 'New York', avatar: "face_icons/woman4.png", admin: true)

review1 = Review.create!(user: bob, rating: 2, business: duck , comment: "Terrible service.")
review2 = Review.create!(user: thadeus, rating: 5, business: duck , comment: "Delicious food at a great price.")
review3 = Review.create!(user: tasha, rating: 4, business: duck , comment: "This restaurant is awesome.")
review4 = Review.create!(user: antilles, rating: 1, business: port , comment: "Hair in my food!")
review5 = Review.create!(user: tasha, rating: 4, business: port , comment: "This restaurant is soooooo good.")
review6 = Review.create!(user: bob, rating: 2, business: port , comment: "Not worth the wait.")
review7 = Review.create!(user: bob, rating: 2, business: steakhouse , comment: "This restaurant is terrible.")
review8 = Review.create!(user: thadeus, rating: 3, business: steakhouse , comment: "It's ok. Costs a pretty penny, though.")
review9 = Review.create!(user: jen, rating: 1, business: steakhouse , comment: "This restaurant is terrible.")
review10 = Review.create!(user: anne, rating: 4, business: flint , comment: "Would dine again.")
review11 = Review.create!(user: antilles, rating: 2, business: flint , comment: "Customer service is great. The food was gross.")
review12 = Review.create!(user: jen, rating: 4, business: flint , comment: "This restaurant was decent and quiet.")
review13 = Review.create!(user: anne, rating: 4, business: binbox , comment: "Loved it!")
review14 = Review.create!(user: jen, rating: 5, business: binbox , comment: "This restaurant is awesome.")
review15 = Review.create!(user: bob, rating: 1, business: binbox , comment: "Worst experience ever.")

Favorite.create!(user: thadeus, business: duck)
Favorite.create!(user: tasha, business: duck)
Favorite.create!(user: tasha, business: port)
Favorite.create!(user: anne, business: flint)
Favorite.create!(user: jen, business: flint)
Favorite.create!(user: anne, business: binbox)
Favorite.create!(user: jen, business: binbox)

Connection.create!(leader: anne, follower: jen)
Connection.create!(leader: tasha, follower: jen)
Connection.create!(leader: antilles, follower: anne)
Connection.create!(leader: jen, follower: anne)
Connection.create!(leader: thadeus, follower: tasha)
Connection.create!(leader: anne, follower: tasha)
Connection.create!(leader: bob, follower: antilles)
Connection.create!(leader: jen, follower: thadeus)
Connection.create!(leader: tasha, follower: thadeus)

BusinessOwnership.create!(owner: thadeus, business: binbox, approved: true, contact_phone: "555-5555", contact_address: "123 Place Way, Place, State")
BusinessOwnership.create!(owner: jen, business: port, approved: true, contact_phone: "555-5555", contact_address: "123 Place Way, Place, State")
BusinessOwnership.create!(owner: antilles, business: duck, approved: true, contact_phone: "555-5555", contact_address: "123 Place Way, Place, State")

Reply.create!(review: review15, user: thadeus, comment: "I'm sorry you had a bad experience. Please let us know what we can do better next time")
Reply.create!(review: review13, user: thadeus, comment: "So happy you liked it! Hope to see you again!")
Reply.create!(review: review4, user: jen, comment: "This never should have happened. We are investigating the cause.")
Reply.create!(review: review5, user: jen, comment: "Thank you! Can't wait to have you as a customer again!")
Reply.create!(review: review2, user: antilles, comment: "Happy to serve you!")
Reply.create!(review: review3, user: antilles, comment: "Come again soon!")