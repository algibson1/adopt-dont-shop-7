class Application < ApplicationRecord
    validates :name, presence: true
    validates :street_address, presence: true
    validates :city, presence: true
    validates :state, presence: true
    validates :zipcode, presence: true
    validates :reason_for_adoption, presence: true
    
    has_many :pet_applications
    has_many :pets, through: :pet_applications

    def pet_status(pet)
        pet_application = PetApplication.where(application_id: self.id).where(pet_id: pet.id).first
        pet_application.status
    end
end