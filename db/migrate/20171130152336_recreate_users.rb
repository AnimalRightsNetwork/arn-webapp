class RecreateUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :users, id: :string, force: true do |t|
      t.string :display_id, null: false
      t.string :email, null: false
      t.string :password_digest, null: false
      t.string :activation_digest
      t.boolean :admin, default: false, null: false

      t.timestamps
    end
    add_index :users, :email, unique: true
  end
end
