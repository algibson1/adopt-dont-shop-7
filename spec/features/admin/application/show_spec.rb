require 'rails_helper'

RSpec.describe 'Admin Application Show Page' do
    it "Rejecting Pet for Adoption" do
        happy_tails = Shelter.create!(name: "Happy Tails", foster_program: true, city: "San Francisco", rank: 3)
        sparky = happy_tails.pets.create!(name: "Sparky", adoptable: true, age: 2, breed: "Beagle")
        phylis = Application.create!(name: "Phylis", street_address: "1234 main circle", city: "Littleton", state: "CO", zipcode: "80241", reason_for_adoption: "I have a huge yard", status: "Pending")
        PetApplication.create!(application: phylis, pet: sparky, status: "Pending")
    
        visit "/admin/applications/#{phylis.id}"
    
        expect(page).to have_button("Reject")
    
        within "#pet-#{sparky.id}" do
          click_button "Reject"
        end
    
        within "#pet-#{sparky.id}" do
          expect(page).not_to have_button("Reject")
        end
    
        within "#pet-#{sparky.id}" do
          expect(page).to have_content("Pet Rejected")
        end
    end
end