class RecreateJoinTableOrgsOrgTags < ActiveRecord::Migration[5.1]
  def change
    create_table :org_tags_orgs, id: false, force: true do |t|
      t.references :org, type: :string, foreign_key: true, index: false, null: false
      t.references :org_tag, foreign_key: true, index: false, null: false
      t.index [:org_id, :org_tag_id], unique: true
      t.index [:org_tag_id, :org_id], unique: true
    end
  end
end
