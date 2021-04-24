class AddPassportsTable < ActiveRecord::Migration[6.0]
  def change
    create_table :passports do |t|
      t.string :number, limit: 10
      t.date :date_of_issue
      t.string :department_code, limit: 7
      t.date :date_of_birth
      t.string :name, limit: 50
      t.string :surname, limit: 50
      t.string :middle_name, limit: 50
      t.timestamps
    end
  end
end
