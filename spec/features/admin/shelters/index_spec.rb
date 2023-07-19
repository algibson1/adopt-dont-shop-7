require "rails_helper"

RSpec.describe "Admin view of shelters index" do
  before do
    @happy_tails = Shelter.create!(name: "Happy Tails", foster_program: true, city: "San Francisco", rank: 3)
    @apple_of_my_eye = Shelter.create!(name: "Apple of My Eye", foster_program: false, city: "Austin", rank: 5)
    @sunnyside = Shelter.create!(name: "Sunnyside", foster_program: false, city: "Boulder", rank: 2)
  end

  it "shows all shelters in reverse alphabetical order by name" do
    visit "/admin/shelters"

    expect("Sunnyside").to appear_before("Happy Tails")
    expect("Happy Tails").to appear_before("Apple of My Eye")
  end

  it "show a section with shelters with Pending Applications" do
    sparky = @happy_tails.pets.create!(name: "Sparky", adoptable: true, age: 2, breed: "Beagle")
    phylis = Application.create!(name: "Phylis", street_address: "1234 main circle", city: "Littleton", state: "CO", zipcode: "80241", reason_for_adoption: "I have a huge yard", status: "Pending")
    fluffy = @sunnyside.pets.create!(name: "Fluffy", adoptable: true, age: 3, breed: "Sphynx")
    PetApplication.create!(application: phylis, pet: sparky, status: "Pending")
    PetApplication.create!(application: phylis, pet: fluffy, status: "Pending")
    visit "/admin/shelters"

    expect(page).to have_content("Shelters with Pending Applications")

    within("#Pending_Applications") do
      expect(page).to have_content("Happy Tails")
      expect(page).to have_content("Sunnyside")
      expect(page).to_not have_content("Apple of My Eye")
    end
  end

end