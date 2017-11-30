class RecreateOrgDescriptions < ActiveRecord::Migration[5.1]
  def change
    create_table :org_descriptions, force: true do |t|
      t.references :org, type: :string, foreign_key: true, index: false, null: false
      t.string :language, null: false
      t.string :content, null: false
    end
    add_index :org_descriptions, [:org_id, :language], unique: true
  end
end
