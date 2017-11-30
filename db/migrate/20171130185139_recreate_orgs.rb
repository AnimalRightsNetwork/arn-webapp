class RecreateOrgs < ActiveRecord::Migration[5.1]
  def change
    create_table :orgs, id: :string, force: true do |t|
      t.string :display_id, null: false
      t.references :org_type, foreign_key: true, null: false
      t.string :name, null: false
      t.string :logo_url, null: false
      t.string :cover_url, null: false
      t.string :video_url
      t.string :marker_url, null: false
      t.string :marker_color, null: false

      t.timestamps
    end
    add_index :orgs, :name, unique: true
  end
end
