require "rails_helper"

RSpec.describe Application do
  describe "relationships" do
    it {should have_many(:pets).through(:pet_applications)}
    it {should have_many :pet_applications}
  end

  describe "validations" do
    it {should validate_presence_of :name}
    it {should validate_presence_of :street_address}
    it {should validate_presence_of :city}
    it {should validate_presence_of :state}
    it {should validate_presence_of :zipcode}
    it {should validate_presence_of :reason_for_adoption}
  end

  describe "pet_status" do
    it "finds the approved/rejected status of a pet on a specific application" do
      happy_tails = Shelter.create!(name: "Happy Tails", foster_program: true, city: "San Francisco", rank: 3)
      sparky = happy_tails.pets.create!(name: "Sparky", adoptable: true, age: 2, breed: "Beagle")
      rufus = happy_tails.pets.create!(name: "Rufus", adoptable: false, age: 7, breed: "Bloodhound")

      phylis = Application.create!(name: "Phylis", street_address: "1234 main circle", city: "Littleton", state: "CO", zipcode: "80241", reason_for_adoption: "I have a huge yard", status: "Pending")
      joe = Application.create!(name: "Joe", street_address: "1234 main circle", city: "Littleton", state: "CO", zipcode: "80241", reason_for_adoption: "I have a huge yard", status: "Pending")

      PetApplication.create!(pet_id: sparky.id, application_id: phylis.id, status: "Approved")
      PetApplication.create!(pet_id: rufus.id, application_id: phylis.id, status: "Pending")
      PetApplication.create!(pet_id: sparky.id, application_id: joe.id, status: "Pending")
      PetApplication.create!(pet_id: rufus.id, application_id: joe.id, status: "Rejected")

      expect(phylis.pet_status(sparky)).to eq("Approved")
      expect(joe.pet_status(sparky)).to eq("Pending")
      expect(phylis.pet_status(rufus)).to eq("Pending")
      expect(joe.pet_status(rufus)).to eq("Rejected")
      expect(phylis.status).to eq("Pending")
      expect(joe.status).to eq("Pending")
    end
  end
end