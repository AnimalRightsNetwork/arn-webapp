class RecreateOrgTypes < ActiveRecord::Migration[5.1]
  def change
    create_table :org_types, force: true do |t|
      t.string :name, null: false
      t.string :icon_url, null: false
    end
    add_index :org_types, :name, unique: true
  end
end
