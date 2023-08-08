class CreateBeneficiaries < ActiveRecord::Migration[7.0]
  def change
    create_table :beneficiaries do |t|
      t.string :name
      t.text :description
      t.integer :inventory_sent
      t.references :charity, null: false, foreign_key: true

      t.timestamps
    end
  end
end
