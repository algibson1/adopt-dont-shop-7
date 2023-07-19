require 'rails_helper'

RSpec.describe 'Admin Application Show Page' do

  it "Rejecting Pet for Adoption" do
    happy_tails = Shelter.create!(name: "Happy Tails", foster_program: true, city: "San Francisco", rank: 3)
    sparky = happy_tails.pets.create!(name: "Sparky", adoptable: true, age: 2, breed: "Beagle")
    phylis = Application.create!(name: "Phylis", street_address: "1234 main circle", city: "Littleton", state: "CO", zipcode: "80241", reason_for_adoption: "I have a huge yard", status: "Pending")
    PetApplication.create!(application: phylis, pet: sparky, status: "Pending")

    visit "/admin/applications/#{phylis.id}"

    expect(page).to have_button("Reject")
    expect(page).to have_button("Accept")

    within "#pet-#{sparky.id}" do
      click_button "Reject"
      expect(page).to have_content("Rejected")
      expect(page).not_to have_button("Reject")
      expect(page).not_to have_button("Accept")
    end

  end

  it "Accepting Pet for Adoption" do
    happy_tails = Shelter.create!(name: "Happy Tails", foster_program: true, city: "San Francisco", rank: 3)
    sparky = happy_tails.pets.create!(name: "Sparky", adoptable: true, age: 2, breed: "Beagle")
    phylis = Application.create!(name: "Phylis", street_address: "1234 main circle", city: "Littleton", state: "CO", zipcode: "80241", reason_for_adoption: "I have a huge yard", status: "Pending")
    PetApplication.create!(application: phylis, pet: sparky, status: "Pending")

    visit "/admin/applications/#{phylis.id}"

    expect(page).to have_button("Accept")
    expect(page).to have_button("Reject")

    within "#pet-#{sparky.id}" do
      click_button "Accept"
      expect(page).to have_content("Accepted")
      expect(page).not_to have_button("Reject")
      expect(page).not_to have_button("Accept")
    end

  end

  it "does not affect other petapplications when one is accepted" do
    happy_tails = Shelter.create!(name: "Happy Tails", foster_program: true, city: "San Francisco", rank: 3)
    sparky = happy_tails.pets.create!(name: "Sparky", adoptable: true, age: 2, breed: "Beagle")
    phylis = Application.create!(name: "Phylis", street_address: "1234 main circle", city: "Littleton", state: "CO", zipcode: "80241", reason_for_adoption: "I have a huge yard", status: "Pending")
    PetApplication.create!(application: phylis, pet: sparky, status: "Pending")
    johnny = Application.create!(name: 'Johnny', street_address: '1234 main st.', city: 'Westminster', state: 'CO', zipcode: '80241',  reason_for_adoption: "I love animals", status: "Pending" )
    PetApplication.create!(application: johnny, pet: sparky, status: "Pending")

    visit "/admin/applications/#{phylis.id}"

    within "#pet-#{sparky.id}" do
      expect(page).to have_content("Accept")
      expect(page).to have_content("Reject")
      expect(page).to have_content("Pending")
    end

    visit "/admin/applications/#{johnny.id}"

    within "#pet-#{sparky.id}" do
      expect(page).to have_button("Accept")
      expect(page).to have_button("Reject")
      expect(page).to have_content("Pending")
      click_button("Accept")
      expect(page).to_not have_button("Accept")
      expect(page).to_not have_button("Reject")
      expect(page).to have_content("Accepted")
    end

    visit "/admin/applications/#{phylis.id}"

    within "#pet-#{sparky.id}" do
      expect(page).to have_content("Accept")
      expect(page).to have_content("Reject")
      expect(page).to have_content("Pending")
    end
  end

  it "does not affect other pet applications when one is rejected" do
    happy_tails = Shelter.create!(name: "Happy Tails", foster_program: true, city: "San Francisco", rank: 3)
    sparky = happy_tails.pets.create!(name: "Sparky", adoptable: true, age: 2, breed: "Beagle")
    phylis = Application.create!(name: "Phylis", street_address: "1234 main circle", city: "Littleton", state: "CO", zipcode: "80241", reason_for_adoption: "I have a huge yard", status: "Pending")
    PetApplication.create!(application: phylis, pet: sparky, status: "Pending")
    johnny = Application.create!(name: 'Johnny', street_address: '1234 main st.', city: 'Westminster', state: 'CO', zipcode: '80241',  reason_for_adoption: "I love animals", status: "Pending" )
    PetApplication.create!(application: johnny, pet: sparky, status: "Pending")
    
    visit "/admin/applications/#{phylis.id}"

    within "#pet-#{sparky.id}" do
      expect(page).to have_content("Accept")
      expect(page).to have_content("Reject")
      expect(page).to have_content("Pending")
    end

    visit "/admin/applications/#{johnny.id}"

    within "#pet-#{sparky.id}" do
      expect(page).to have_button("Accept")
      expect(page).to have_button("Reject")
      expect(page).to have_content("Pending")
      click_button("Reject")
      expect(page).to_not have_button("Accept")
      expect(page).to_not have_button("Reject")
      expect(page).to have_content("Rejected")
    end

    visit "/admin/applications/#{phylis.id}"

    within "#pet-#{sparky.id}" do
      expect(page).to have_content("Accept")
      expect(page).to have_content("Reject")
      expect(page).to have_content("Pending")
    end
  end
end