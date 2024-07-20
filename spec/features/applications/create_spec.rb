require "rails_helper"

RSpec.describe "Application Creation" do

  it "is linked to from the pet index page" do
    visit "/pets"

    expect(page).to have_link("Start an Application", href: "/applications/new")
  end

  it "has a form to create a new application" do
    visit "/pets"
    click_link("Start an Application")

    expect(page).to have_content("Please fill out your information below")
    expect(page).to have_field(:name)
    expect(page).to have_field(:street_address)
    expect(page).to have_field(:city)
    expect(page).to have_field(:state)
    expect(page).to have_field(:zipcode)
    expect(page).to_not have_field(:reason_for_adoption)
    expect(page).to have_button("Submit")
  end

  it "can generate a new application and redirect to show page" do
    visit "/applications/new"

    fill_in(:name, with: "Jennifer")
    fill_in(:street_address, with: "253 Doggie Lane")
    fill_in(:city, with: "Kitty City")
    fill_in(:state, with: "WA")
    fill_in(:zipcode, with: "35467")
    click_button("Submit")

    app = Application.last

    expect(current_path).to eq("/applications/#{app.id}")
    expect(page).to have_content("Jennifer")
    expect(page).to have_content("253 Doggie Lane")
    expect(page).to have_content("Kitty City")
    expect(page).to have_content("WA")
    expect(page).to have_content("35467")
    expect(page).to have_content("In Progress")
  end

  describe "when given invalid input" do
    it "should raise error if user doesn't fill out name" do
      visit "/applications/new"

      fill_in(:street_address, with: "253 Doggie Lane")
      fill_in(:city, with: "Kitty City")
      fill_in(:state, with: "WA")
      fill_in(:zipcode, with: "35467")
      click_button("Submit")

      expect(current_path).to eq("/applications/new")
      expect(page).to have_content("Error: Name can't be blank")
    end

    it "should raise error if user doesn't fill out address" do
      visit "/applications/new"

      fill_in(:name, with: "Jennifer")
      fill_in(:city, with: "Kitty City")
      fill_in(:state, with: "WA")
      fill_in(:zipcode, with: "35467")
      click_button("Submit")

      expect(current_path).to eq("/applications/new")
      expect(page).to have_content("Error: Street address can't be blank")
    end

    it "should raise error if user doesn't fill out city" do
      visit "/applications/new"

      fill_in(:name, with: "Jennifer")
      fill_in(:street_address, with: "253 Doggie Lane")
      fill_in(:state, with: "WA")
      fill_in(:zipcode, with: "35467")
      click_button("Submit")

      expect(current_path).to eq("/applications/new")
      expect(page).to have_content("Error: City can't be blank")
    end

    it "should raise error if user doesn't fill out state" do
      visit "/applications/new"

      fill_in(:name, with: "Jennifer")
      fill_in(:street_address, with: "253 Doggie Lane")
      fill_in(:city, with: "Kitty City")
      fill_in(:zipcode, with: "35467")
      click_button("Submit")

      expect(current_path).to eq("/applications/new")
      expect(page).to have_content("Error: State can't be blank")
    end

    it "should raise error if user doesn't fill out zipcode" do
      visit "/applications/new"

      fill_in(:name, with: "Jennifer")
      fill_in(:street_address, with: "253 Doggie Lane")
      fill_in(:city, with: "Kitty City")
      fill_in(:state, with: "WA")
      click_button("Submit")

      expect(current_path).to eq("/applications/new")
      expect(page).to have_content("Error: Zipcode can't be blank")
    end

    it "may have multiple errors" do
      visit "/applications/new"

      fill_in(:name, with: "Jennifer")
      fill_in(:state, with: "WA")
      fill_in(:zipcode, with: "35467")
      click_button("Submit")

      expect(current_path).to eq("/applications/new")
      expect(page).to have_content("Error: Street address can't be blank, City can't be blank")
    end
  end
end