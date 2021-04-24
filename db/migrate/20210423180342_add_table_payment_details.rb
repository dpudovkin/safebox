class AddTablePaymentDetails < ActiveRecord::Migration[6.0]
  def change
    create_table :payment_details do |t|
      t.belongs_to :client
      t.string :account_number, limit: 32
      t.string :BIK, limit: 32
      t.string :bank_name, limit: 100
      t.timestamps
    end
  end
end
