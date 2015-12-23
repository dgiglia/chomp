source 'https://rubygems.org'

gem 'rails', '4.2.0'
gem 'haml-rails', '~> 0.9.0'
gem 'bootstrap-sass', '~> 3.3.5'
gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.1.0'
gem 'jquery-rails'
gem 'pg'
gem 'bcrypt', '~> 3.1.10'
gem 'bootstrap_form'
gem 'nested_form'
gem 'carrierwave'
gem 'mini_magick'
gem 'figaro'
gem 'sidekiq'

group :development do
  gem 'thin'
  gem "better_errors"
  gem "binding_of_caller"
  gem "letter_opener"
end

group :development, :test do
  gem 'pry'
  gem 'pry-nav'
  gem 'rspec-rails', '~> 3.1'
end

group :test do
  gem 'database_cleaner', '1.2.0'
  gem 'shoulda-matchers'
  gem 'fabrication'
  gem 'faker'
  gem 'capybara'
  gem 'capybara-email', github: 'dockyard/capybara-email'
  gem 'launchy'
end

group :production, :staging do
  gem 'rails_12factor'
  gem 'carrierwave-aws'
end
