class Createcompanies < ActiveRecord::Migration[5.1]
  def change
    create_table :companies do |t|
      t.string :name
      t.string :domain, null: false
      t.timestamps
    end

    add_column :users, :company_id, :integer, null: false, default: 0
  end
end
