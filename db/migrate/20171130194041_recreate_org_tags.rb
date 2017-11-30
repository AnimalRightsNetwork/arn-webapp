class RecreateOrgTags < ActiveRecord::Migration[5.1]
  def change
    create_table :org_tags, force: true do |t|
      t.string :name, null: false
      t.string :icon_url, null: false
      t.string :color, null: false
    end
    add_index :org_tags, :name, unique: true
  end
end
