require 'rails_helper'

RSpec.describe "Application Show Page" do 
    before(:each) do
        @sunnyside = Shelter.create!(name: "Sunnyside", foster_program: false, city: "Boulder", rank: 2)
        @fluffy = @sunnyside.pets.create!(name: "Fluffy", adoptable: true, age: 3, breed: "Sphynx")
        @copper = @sunnyside.pets.create!(name: "Copper", adoptable: false, age: 5, breed: "German Shephard")
        @willow = @sunnyside.pets.create!(name: "Willow", adoptable: true, age: 1, breed: "Labrador")
        @applicant_1 = Application.create!(name: "Phylis", street_address: "1234 main circle", city: "Littleton", state: "CO", zipcode: "80241", reason_for_adoption: "I have a huge yard", status: "In Progress")
        PetApplication.create!(pet: @willow, application: @applicant_1, status: "Pending")
        PetApplication.create!(pet: @copper, application: @applicant_1, status: "Pending")
    end

    it "show information for the applicant" do
        visit "/applications/#{@applicant_1.id}"
        expect(page).to have_content("Phylis")
        expect(page).to have_content("1234 main circle")
        expect(page).to have_content("Littleton")
        expect(page).to have_content("CO")
        expect(page).to have_content("80241")
        expect(page).to have_content("I have a huge yard")
        expect(page).to have_content("In Progress")
    end

    it "has names of all pets and links to their show page" do
        visit "/applications/#{@applicant_1.id}"
        expect(page).to have_link("Copper", href: "/pets/#{@copper.id}")
        expect(page).to have_link("Willow", href: "/pets/#{@willow.id}")
        expect(page).to have_content("Pending")
    end

    describe "User Story 4" do
        before(:each) do
          PetApplication.destroy_all
          Pet.destroy_all
          Shelter.destroy_all
          Application.destroy_all
          @shelter = Shelter.create!(name: 'Holy Valley', city: 'Westminster', foster_program: false, rank: 3)
          @pet = @shelter.pets.create!(name: 'Pete', breed: 'Boxer', age: 3, adoptable: true)
          @applicant_1 = @pet.applications.create!(name: 'Johnny', 
          street_address: '1234 main st.', 
          city: 'Westminster', 
          state: 'CO',
          zipcode: '80241', 
          reason_for_adoption: "I love animals",
          status: "In Progress"
          )
        end
    
        it "displays a section on the show page to 'Add a Pet to this Application'" do
          visit "/applications/#{@applicant_1.id}"
    
          expect(page).to have_content('Add a Pet to this Application')
        end
    
        it "has an input to search pets by name" do
          visit "/applications/#{@applicant_1.id}"
    
          expect(page).to have_button("Search")
     
        end
    
        it "When the visitor fills in this field with a pet name, and clicks submit, then they are taken back to the application show page" do
          visit "/applications/#{@applicant_1.id}"
    
          fill_in("Search", with: "Pete")
    
          click_button("Search")
    
          expect(current_path).to eq("/applications/#{@applicant_1.id}")
          
        end
    
        it "Shows the visitor any Pet whose name matches the search under the search bar" do
          shelter = Shelter.create!(name: 'Holy Valley', city: 'Westminster', foster_program: false, rank: 3)
          pet_1 = Pet.create!(adoptable: true, age: 5, breed: 'Pig', name: 'Harvey', shelter_id: shelter.id)
          pet_2 = Pet.create!(adoptable: true, age: 6, breed: 'Mouse', name: 'Haven', shelter_id: shelter.id)
          pet_3 = Pet.create!(adoptable: true, age: 1, breed: 'Bat', name: 'Pickles', shelter_id: shelter.id)
          
          visit "/applications/#{@applicant_1.id}"
    
          fill_in 'Search', with: "Ha"
          click_on("Search")
    
          expect(page).to have_content(pet_1.name)
          expect(page).to have_content(pet_2.name)
          expect(page).to_not have_content(pet_3.name)
          save_and_open_page
        end
    end

    describe 'User Story 5' do
        it "shows the visitor an option to 'Adopt this Pet' next to each pet's name" do
          shelter = Shelter.create!(name: 'Holy Valley', city: 'Westminster', foster_program: false, rank: 3)
          pet_1 = Pet.create!(adoptable: true, age: 5, breed: 'Pig', name: 'Harvey', shelter_id: shelter.id)
          applicant_1 = Application.create!(name: 'Johnny', 
          street_address: '1234 main st.', 
          city: 'Westminster', 
          state: 'CO',
          zipcode: '80241', 
          reason_for_adoption: "I love animals",
          status: "In Progress"
          )
    
          PetApplication.create!(application: applicant_1, pet: pet_1)
          visit "/applications/#{applicant_1.id}"
    
          fill_in 'Search', with: "Ha"
          click_on("Search")
    
          expect(page).to have_button("Adopt this Pet")
        end
    
        it "takes the user back to the application show page" do
          shelter = Shelter.create!(name: 'Holy Valley', city: 'Westminster', foster_program: false, rank: 3)
          pet_1 = Pet.create!(adoptable: true, age: 5, breed: 'Pig', name: 'Harvey', shelter_id: shelter.id)
          applicant_1 = Application.create!(name: 'Johnny', 
          street_address: '1234 main st.', 
          city: 'Westminster', 
          state: 'CO',
          zipcode: '80241', 
          reason_for_adoption: "I love animals",
          status: "In Progress"
          )
    
          PetApplication.create!(application: applicant_1, pet: pet_1)
    
          visit "/applications/#{applicant_1.id}"
    
          fill_in 'Search', with: "Ba"
          click_on("Search")
    
          click_button("Adopt this Pet")
    
          expect(current_path).to eq("/applications/#{applicant_1.id}")
        end
    
        it "adds the pet to the user's application" do
          shelter = Shelter.create!(name: 'Holy Valley', city: 'Westminster', foster_program: false, rank: 3)
          pet_1 = Pet.create!(adoptable: true, age: 5, breed: 'Pig', name: 'Harvey', shelter_id: shelter.id)
          applicant_1 = Application.create!(name: 'Johnny', 
          street_address: '1234 main st.', 
          city: 'Westminster', 
          state: 'CO',
          zipcode: '80241', 
          reason_for_adoption: "I love animals",
          status: "In Progress"
          )
          
          visit "/applications/#{applicant_1.id}"
          
          fill_in 'Search', with: "Ha"
          click_on("Search")
          
          click_button("Adopt this Pet")
          expect(applicant_1.pets).to eq([pet_1])
        end
    end
end