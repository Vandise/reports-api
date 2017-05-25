class CreateApiKeys < ActiveRecord::Migration[5.1]
  def change
    create_table :api_keys do |t|
      t.integer  "user_id"
      t.string   "access_token"
      t.datetime "expires_at"
      t.timestamps
    end
  end
end
