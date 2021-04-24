class CreateSections < ActiveRecord::Migration[6.0]
  def change
    create_table :sections do |t|
      t.string :label
      t.integer :floor
      t.timestamps
    end
  end
end
