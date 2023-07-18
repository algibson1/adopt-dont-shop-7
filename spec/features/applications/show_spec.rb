require 'rails_helper'

RSpec.describe "Application Show Page" do 
  before(:each) do
    @sunnyside = Shelter.create!(name: "Sunnyside", foster_program: false, city: "Boulder", rank: 2)
    @fluffy = @sunnyside.pets.create!(name: "Fluffy", adoptable: true, age: 3, breed: "Sphynx")
    @copper = @sunnyside.pets.create!(name: "Copper", adoptable: false, age: 5, breed: "German Shephard")
    @willow = @sunnyside.pets.create!(name: "Willow", adoptable: true, age: 1, breed: "Labrador")
    @applicant_1 = Application.create!(name: "Phylis", street_address: "1234 main circle", city: "Littleton", state: "CO", zipcode: "80241", reason_for_adoption: "N/A", status: "In Progress")
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
    expect(page).to have_content("In Progress")
  end

  it "has names of all pets and links to their show page" do
    visit "/applications/#{@applicant_1.id}"
    expect(page).to have_link("Copper", href: "/pets/#{@copper.id}")
    expect(page).to have_link("Willow", href: "/pets/#{@willow.id}")
    expect(page).to have_content("Pending")
  end

  describe "search" do
    before(:each) do
      PetApplication.destroy_all
      Pet.destroy_all
      Shelter.destroy_all
      Application.destroy_all
      @shelter = Shelter.create!(name: 'Holy Valley', city: 'Westminster', foster_program: false, rank: 3)
      @pet = @shelter.pets.create!(name: 'Pete', breed: 'Boxer', age: 3, adoptable: true)
      @applicant_1 = Application.create!(name: 'Johnny', 
      street_address: '1234 main st.', 
      city: 'Westminster', 
      state: 'CO',
      zipcode: '80241', 
      reason_for_adoption: "N/A",
      status: "In Progress"
      )
      PetApplication.create!(pet_id: @pet.id, application_id: @applicant_1.id, status: "Pending")
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
    end
  end


  describe 'add pet to application' do
    it "shows the visitor an option to 'Adopt this Pet' next to each pet's name" do
      shelter = Shelter.create!(name: 'Holy Valley', city: 'Westminster', foster_program: false, rank: 3)
      pet_1 = Pet.create!(adoptable: true, age: 5, breed: 'Pig', name: 'Harvey', shelter_id: shelter.id)
      applicant_1 = Application.create!(name: 'Johnny', 
      street_address: '1234 main st.', 
      city: 'Westminster', 
      state: 'CO',
      zipcode: '80241', 
      reason_for_adoption: "N/A",
      status: "In Progress"
      )

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
      reason_for_adoption: "N/A",
      status: "In Progress"
      )

      visit "/applications/#{applicant_1.id}"

      fill_in 'Search', with: "Ha"
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
      reason_for_adoption: "N/A",
      status: "In Progress"
      )
      
      visit "/applications/#{applicant_1.id}"
      
      fill_in 'Search', with: "Ha"
      click_on("Search")
      
      click_button("Adopt this Pet")
      expect(applicant_1.pets).to eq([pet_1])
      expect(page).to have_content("Harvey")
    end
  end

#     As a visitor
# When I visit an application's show page
# And I have added one or more pets to the application
# Then I see a section to submit my application
############### And in that section I see an input to enter why I would make a good owner for these pet(s)
# When I fill in that input
# And I click a button to submit this application
# Then I am taken back to the application's show page
# And I see an indicator that the application is "Pending"
# And I see all the pets that I want to adopt
# And I do not see a section to add more pets to this application

  describe "application submission" do
    it "shows a submit section after a pet is added" do
      visit "/applications/#{@applicant_1.id}"

      expect(page).to have_content("Willow")
      expect(page).to have_content("Copper")
      expect(page).to have_content("In Progress")
      expect(page).to have_content("Add a Pet to this Application")
      
      expect(page).to have_field(:reason_for_adoption)
      fill_in(:reason_for_adoption, with: "I have a big yard and lots of space!")
      expect(page).to have_button("Submit")
      click_button("Submit")

      expect(current_path).to eq("/applications/#{@applicant_1.id}")
      expect(page).to have_content("Pending")
      expect(page).to_not have_content("In Progress")
      expect(page).to have_content("I have a big yard and lots of space!")

      expect(page).to_not have_content("Add a Pet to this Application")
      expect(page).to_not have_button("Submit")
    end

    it "throws an error if applicant doesn't fill in why they'd be a good home" do
      visit "/applications/#{@applicant_1.id}"
      click_button("Submit")

      expect(current_path).to eq("/applications/#{@applicant_1.id}")
      expect(page).to have_content("Please input why you would be a good home")
    end
    # 7. No Pets on an Application
    
    # As a visitor
    # When I visit an application's show page
    # And I have not added any pets to the application
    # Then I do not see a section to submit my application

    it "has no option to submit without pets" do
      PetApplication.destroy_all
      visit "/applications/#{@applicant_1.id}"

      expect(page).to_not have_content("Willow")
      expect(page).to_not have_content("Copper")

      expect(page).to_not have_button("Submit")
    end
  end

  describe "case insensitive search" do
    it "Shows the visitor any pet whose name matches their search, being case insensitive" do
      shelter = Shelter.create!(name: 'Holy Valley', city: 'Westminster', foster_program: false, rank: 3)
      pet_1 = Pet.create!(adoptable: true, age: 5, breed: 'Pig', name: 'Harvey', shelter_id: shelter.id)
      pet_2 = Pet.create!(adoptable: true, age: 2, breed: 'Mastiff', name: 'Hank', shelter_id: shelter.id)
      pet_3 = Pet.create!(adoptable: true, age: 1, breed: 'Tabby', name: 'Pip', shelter_id: shelter.id)
      applicant_1 = Application.create!(name: 'Johnny', 
      street_address: '1234 main st.', 
      city: 'Westminster', 
      state: 'CO',
      zipcode: '80241', 
      reason_for_adoption: "I love animals",
      status: "In Progress"
      )
      
      visit "/applications/#{applicant_1.id}"

      fill_in 'Search', with: "hA"
      click_on("Search")

      expect(page).to have_content(pet_1.name)
      expect(page).to have_content(pet_2.name)
      expect(page).to_not have_content(pet_3.name)

    end
  end
end