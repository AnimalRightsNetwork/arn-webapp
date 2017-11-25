class CreateUsers < ActiveRecord::Migration[5.1]
  def up
    create_table :users do |t|
      t.string :password_digest

      t.timestamps
    end
    change_column :users, :id, :string
  end

  def down
    drop_table :users
  end
end
