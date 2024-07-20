class Pet < ApplicationRecord
  validates_presence_of :name,
                        :age

  validates_numericality_of :age

  belongs_to :shelter

  has_many :pet_applications
  has_many :applications, through: :pet_applications

  def shelter_name
    shelter.name
  end

  def self.adoptable
    where(adoptable: true)
  end

  def approval_status_for(application)
    PetApplication.find_by(pet_id: self.id, application_id: application.id).status
  end
end
