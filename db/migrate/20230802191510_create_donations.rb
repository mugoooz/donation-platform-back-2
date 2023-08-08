class CreateDonations < ActiveRecord::Migration[7.0]
  def change
    create_table :donations do |t|
      t.integer :charity_id
      t.integer :donor_id
      t.decimal :amount
      t.string :name
      t.string :location
      t.string :phone_number
      t.boolean :anonymous
      t.string :recurrence
      t.string :stripe_session_id

      t.timestamps
    end
  end
end