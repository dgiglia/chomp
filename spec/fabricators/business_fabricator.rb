Fabricator(:business) do
  name { sequence(:name) { |i| Faker::Company.name + "#{i}" } }
  city {Faker::Address.city}
  state {Faker::Address.state}
  address {Faker::Address.street_address}
  url {Faker::Internet.domain_name}
end