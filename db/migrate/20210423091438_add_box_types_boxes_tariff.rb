class AddBoxTypesBoxesTariff < ActiveRecord::Migration[6.0]
  def change
    create_table :box_types do |t|
      t.string :name
      t.float :length
      t.float :width
      t.float :height
      t.timestamps
    end

    create_table :tariffs do |t|
      t.integer :price_per_day
      t.date :start_date
      t.belongs_to :box_type
      t.timestamps
    end

    create_table :boxes do |t|
      t.integer :number
      t.belongs_to :box_type
      t.belongs_to :section
      t.timestamps
    end
  end
end
