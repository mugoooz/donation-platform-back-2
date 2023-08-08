class CreateCharities < ActiveRecord::Migration[7.0]
  def change
    create_table :charities do |t|
      t.string :name
      t.string :location
      t.string :phone_number
      t.string :email
      t.string :purpose
      t.string :password_digest

      t.timestamps
    end
  end
end
