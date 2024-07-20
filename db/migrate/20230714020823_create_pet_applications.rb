class CreatePetApplications < ActiveRecord::Migration[7.0]
  def change
    create_table :pet_applications do |t|
      t.references :application, null: false, foreign_key: true
      t.references :pet, null: false, foreign_key: true
      t.string :status, default: "Pending"

      t.timestamps
    end
  end
end
