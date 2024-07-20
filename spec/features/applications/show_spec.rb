require 'rails_helper'

RSpec.describe "Application Show Page" do 
  it "shows information for the applicant" do
    @applicant_1 = Application.create!(name: "Phylis", street_address: "1234 main circle", city: "Littleton", state: "CO", zipcode: "80241", reason_for_adoption: "N/A", status: "In Progress")

    visit "/applications/#{@applicant_1.id}"
    expect(page).to have_content("Phylis")
    expect(page).to have_content("1234 main circle")
    expect(page).to have_content("Littleton")
    expect(page).to have_content("CO")
    expect(page).to have_content("80241")
    expect(page).to have_content("In Progress")
  end

  it "has names of all pets and links to their show page" do
    @sunnyside = Shelter.create!(name: "Sunnyside", foster_program: false, city: "Boulder", rank: 2)
    @copper = @sunnyside.pets.create!(name: "Copper", adoptable: false, age: 5, breed: "German Shephard")
    @willow = @sunnyside.pets.create!(name: "Willow", adoptable: true, age: 1, breed: "Labrador")
    @applicant_1 = Application.create!(name: "Phylis", street_address: "1234 main circle", city: "Littleton", state: "CO", zipcode: "80241", reason_for_adoption: "N/A", status: "In Progress")
    @applicant_1.pets << [@copper, @willow]

    visit "/applications/#{@applicant_1.id}"
    expect(page).to have_link("Copper", href: "/pets/#{@copper.id}")
    expect(page).to have_link("Willow", href: "/pets/#{@willow.id}")
    expect(page).to have_content("Pending")
  end

  describe "search for pets feature" do
    before(:each) do
      @applicant_1 = Application.create!(name: 'Johnny', 
      street_address: '1234 main st.', 
      city: 'Westminster', 
      state: 'CO',
      zipcode: '80241', 
      reason_for_adoption: "N/A",
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

    it "Redirects back to show page when user fills in search field and clicks submit" do
      visit "/applications/#{@applicant_1.id}"

      fill_in("Search", with: "Something")

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

    it "Shows the visitor any pet whose name matches their search, being case insensitive" do
      shelter = Shelter.create!(name: 'Holy Valley', city: 'Westminster', foster_program: false, rank: 3)
      pet_1 = Pet.create!(adoptable: true, age: 5, breed: 'Pig', name: 'Harvey', shelter_id: shelter.id)
      pet_2 = Pet.create!(adoptable: true, age: 2, breed: 'Mastiff', name: 'Hank', shelter_id: shelter.id)
      pet_3 = Pet.create!(adoptable: true, age: 1, breed: 'Tabby', name: 'Pip', shelter_id: shelter.id)
      
      visit "/applications/#{@applicant_1.id}"

      fill_in 'Search', with: "hA"
      click_on("Search")

      expect(page).to have_content(pet_1.name)
      expect(page).to have_content(pet_2.name)
      expect(page).to_not have_content(pet_3.name)
    end
  end

  describe 'add pet to application' do
    before :each do
      shelter = Shelter.create!(name: 'Holy Valley', city: 'Westminster', foster_program: false, rank: 3)
      @pet_1 = Pet.create!(adoptable: true, age: 5, breed: 'Pig', name: 'Harvey', shelter_id: shelter.id)
      @applicant_1 = Application.create!(name: 'Johnny', 
      street_address: '1234 main st.', 
      city: 'Westminster', 
      state: 'CO',
      zipcode: '80241', 
      reason_for_adoption: "N/A",
      status: "In Progress"
      )
    end

    it "shows the visitor an option to 'Adopt this Pet' next to each pet's name" do
      visit "/applications/#{@applicant_1.id}"

      fill_in 'Search', with: "Ha"
      click_on("Search")

      expect(page).to have_button("Adopt this Pet")
    end

    it "takes the user back to the application show page" do
      visit "/applications/#{@applicant_1.id}"

      fill_in 'Search', with: "Ha"
      click_on("Search")

      click_button("Adopt this Pet")

      expect(current_path).to eq("/applications/#{@applicant_1.id}")
    end

    it "adds the pet to the user's application" do      
      visit "/applications/#{@applicant_1.id}"
      
      fill_in 'Search', with: "Ha"
      click_on("Search")
      
      click_button("Adopt this Pet")
      expect(@applicant_1.pets).to eq([@pet_1])
      expect(page).to have_content("Harvey")
    end
  end

  describe "application submission" do
    before :each do
      @sunnyside = Shelter.create!(name: "Sunnyside", foster_program: false, city: "Boulder", rank: 2)
      @copper = @sunnyside.pets.create!(name: "Copper", adoptable: false, age: 5, breed: "German Shephard")
      @willow = @sunnyside.pets.create!(name: "Willow", adoptable: true, age: 1, breed: "Labrador")
      @applicant_1 = Application.create!(name: "Phylis", street_address: "1234 main circle", city: "Littleton", state: "CO", zipcode: "80241", reason_for_adoption: "N/A", status: "In Progress")
      @applicant_1.pets << [@copper, @willow]
    end

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
      expect(page).to have_content("Error: Reason for adoption can't be blank")
    end

    it "has no option to submit without pets" do
      PetApplication.destroy_all
      visit "/applications/#{@applicant_1.id}"

      expect(page).to_not have_content("Willow")
      expect(page).to_not have_content("Copper")

      expect(page).to_not have_button("Submit")
    end
  end
end