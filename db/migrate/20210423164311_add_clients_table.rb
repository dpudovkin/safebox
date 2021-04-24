class AddClientsTable < ActiveRecord::Migration[6.0]
  def change
    create_table :clients do |t|
      t.belongs_to :passport
      t.string :phone_number, limit: 12
      t.string :extra_phone_number, limit: 12
      t.string :email, limit: 50
      t.timestamps
    end
  end
end
