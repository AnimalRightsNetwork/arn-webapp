class CreateJoinTableOrgsOrgTags < ActiveRecord::Migration[5.1]
  def change
    create_table :org_tags_orgs, id: false do |t|
      t.references :org_tag, index: false, foreign_key: true, null: false
      t.references :org, type: :string, index: false, foreign_key: true, null: false
      t.index [:org_id, :org_tag_id], unique: true
      t.index [:org_tag_id, :org_id], unique: true
    end
  end
end
