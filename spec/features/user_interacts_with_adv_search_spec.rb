require 'spec_helper'

feature "User interacts with advanced search", :elasticsearch do

  background do
    cat = Fabricate(:category)
    Fabricate(:business, name: "The Lucky Star", category: cat)
    Fabricate(:business, name: "Lucky Dominoes", category: cat)
    Fabricate(:business, name: "Star City", category: cat)
    Fabricate(:business, name: "Little Sally's", city: "Chicago", category: cat)
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
end

def refresh_index
  Business.import
  Business.__elasticsearch__.refresh_index!
end