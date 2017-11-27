class AddRegistrationColumnsToUser < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :email, :string
    add_index :users, :email, unique: true
    add_column :users, :activation_digest, :string
    add_column :users, :admin, :boolean, null: false, default: false
  end
end
