class Application < ApplicationRecord
  validates_presence_of :name,
                        :street_address,
                        :city,
                        :state,
                        :zipcode,
                        :reason_for_adoption,
                        :status
  
  has_many :pet_applications
  has_many :pets, through: :pet_applications

  def has_pets?
    !pets.empty?
  end
end