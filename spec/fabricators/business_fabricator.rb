Fabricator(:business) do
  name {Faker::Company.name}
  city {Faker::Address.city}
  state {Faker::Address.state}
  address {Faker::Address.street_address}
  url {Faker::Internet.domain_name}
end