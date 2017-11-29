class CreateOrgLinks < ActiveRecord::Migration[5.1]
  def change
    create_table :org_links, id: false do |t|
      t.references :org, type: :string, index: false, foreign_key: true, null: false
      t.references :link_type, index: false, foreign_key: true, null: false
      t.string :url, null: false
    end
    add_index :org_links, [:org_id, :link_type_id], unique: true
  end
end
