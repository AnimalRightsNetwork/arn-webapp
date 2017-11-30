class RecreateOrgLinks < ActiveRecord::Migration[5.1]
  def change
    create_table :org_links, force: true do |t|
      t.references :org, type: :string, foreign_key: true, index: false, null: false
      t.references :link_type, foreign_key: true, index: false, null: false
      t.string :url, null: false
    end
    add_index :org_links, [:org_id, :link_type_id], unique: true
  end
end
