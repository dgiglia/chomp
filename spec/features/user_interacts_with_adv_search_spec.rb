require 'spec_helper'

feature "User interacts with advanced search", :elasticsearch do

  background do
    cat = Fabricate(:category)
    lucky_star = Fabricate(:business, name: "The Lucky Star", category: cat)
    dominoes = Fabricate(:business, name: "Lucky Dominoes", category: cat)
    city = Fabricate(:business, name: "Star City", category: cat)
    sally = Fabricate(:business, name: "Little Sally's", city: "Chicago", category: cat)

    Fabricate(:review, business: lucky_star, rating: 5, comment: "awesome restaurant!!!")
    Fabricate(:review, business: dominoes, rating: 3)
    Fabricate(:review, business: city,  rating: 4)
    Fabricate(:review, business: city,  rating: 5)
    
    refresh_index
    sign_in
    click_on "Advanced Search"
  end

  scenario "user searches with title" do
    within(".advanced_search") do
      fill_in "query", with: "Lucky"
      click_button "Search"
    end

    expect(page).to have_content("2 eateries found")
    expect(page).to have_content("The Lucky Star")
    expect(page).to have_content("Lucky Dominoes")
  end

  scenario "user searches with name and city" do
    within(".advanced_search") do
      fill_in "query", with: "Chicago"
      click_button "Search"
    end
    expect(page).to have_content("Little Sally's")
    expect(page).to have_no_content("Lucky")
  end
  
  scenario "user filters search results with average rating" do
    within(".advanced_search") do
      fill_in "query", with: "Star"
      check "Include Reviews"
      select "4.4", from: "average_rating_from"
      select "4.6", from: "average_rating_to"

      click_button "Search"
    end
    expect(page).to have_content "Star City"
    expect(page).to have_no_content "Lucky"
  end
end

def refresh_index
  Business.import
  Business.__elasticsearch__.refresh_index!
end