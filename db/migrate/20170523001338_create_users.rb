class CreateUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :users do |t|
      t.string :email, :null => false
      t.string :crypted_password
      t.string :salt
      t.string :first_name, null: false
      t.string :last_name, null: false
      t.boolean :google_account
      t.timestamps
    end
  end
end
