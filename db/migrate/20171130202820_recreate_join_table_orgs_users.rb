class RecreateJoinTableOrgsUsers < ActiveRecord::Migration[5.1]
  def change
    create_join_table :orgs, :users, table_name: :org_administrations, column_options: { type: :string, foreign_key: true }, force: true do |t|
      t.index [:org_id, :user_id], unique: true
      t.index [:user_id, :org_id], unique: true
    end
  end
end
