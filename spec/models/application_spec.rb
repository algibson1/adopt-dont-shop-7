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
    it {should validate_presence_of :status}
  end

  describe "has_pets?" do
    it "can report if an application has pets" do
      happy_tails = Shelter.create!(name: "Happy Tails", foster_program: true, city: "San Francisco", rank: 3)
      sparky = happy_tails.pets.create!(name: "Sparky", adoptable: true, age: 2, breed: "Beagle")
      rufus = happy_tails.pets.create!(name: "Rufus", adoptable: false, age: 7, breed: "Bloodhound")

      phylis = Application.create!(name: "Phylis", street_address: "1234 main circle", city: "Littleton", state: "CO", zipcode: "80241", reason_for_adoption: "I have a huge yard", status: "Pending")
      joe = Application.create!(name: "Joe", street_address: "1234 main circle", city: "Littleton", state: "CO", zipcode: "80241", reason_for_adoption: "I have a huge yard", status: "Pending")

      expect(phylis.has_pets?).to eq(false)
      expect(joe.has_pets?).to eq(false)

      PetApplication.create!(pet_id: sparky.id, application_id: phylis.id, status: "Pending")
      PetApplication.create!(pet_id: rufus.id, application_id: phylis.id, status: "Pending")

      expect(phylis.has_pets?).to eq(true)
      expect(joe.has_pets?).to eq(false)

      PetApplication.create!(pet_id: sparky.id, application_id: joe.id, status: "Pending")
      expect(joe.has_pets?).to eq(true)
    end
  end
end