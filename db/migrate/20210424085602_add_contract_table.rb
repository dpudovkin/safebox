class AddContractTable < ActiveRecord::Migration[6.0]
  def change
    create_table :contracts do |t|
      t.belongs_to :client
      t.references :previous_contract, foreign_key: { to_table: :contracts }
      t.belongs_to :terminations_of_contract, null: true
      t.belongs_to :box
      t.float :deposit_amount
      t.integer :rental_days
      t.date :start_date
      t.timestamps
    end
  end
end
