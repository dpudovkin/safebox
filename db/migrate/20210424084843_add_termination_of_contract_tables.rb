class AddTerminationOfContractTables < ActiveRecord::Migration[6.0]
  def change
    create_table :terminations_of_contracts do |t|
      t.float :client_debt
      t.float :company_debt
      t.date :termination_date
      t.timestamps
    end
  end
end
