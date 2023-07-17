require 'rails_helper'

RSpec.describe 'Admin Application Show Page' do
  # 13. Rejecting a Pet for Adoption
  # As a visitor
  # When I visit an admin application show page ('/admin/applications/:id')
  # For every pet that the application is for, I see a button to reject the application for that specific pet
  # When I click that button
  # Then I'm taken back to the admin application show page
  # And next to the pet that I rejected, I do not see a button to approve or reject this pet
  # And instead I see an indicator next to the pet that they have been rejected
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

  # 14. Approved/Rejected Pets on one Application do not affect other Applications

  #   As a visitor
  #   When there are two applications in the system for the same pet
  #   When I visit the admin application show page for one of the applications
  #   And I approve or reject the pet for that application
  #   When I visit the other application's admin show page
  #   Then I do not see that the pet has been accepted or rejected for that application
  #   And instead I see buttons to approve or reject the pet for this specific application

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