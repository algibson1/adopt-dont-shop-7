class PetApplication < ApplicationRecord
    belongs_to :pet
    belongs_to :application

    validates :pet_id, presence: true
    validates :application_id, presence: true
    validates :status, presence: true

end