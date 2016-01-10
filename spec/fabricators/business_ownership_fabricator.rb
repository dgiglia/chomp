Fabricator(:business_ownership) do
  contact_phone {Faker::PhoneNumber.phone_number}
  contact_address {Faker::Address}
  message {Faker::Lorem.paragraph(2)}
end