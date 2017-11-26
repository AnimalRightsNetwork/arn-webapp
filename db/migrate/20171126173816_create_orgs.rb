class CreateOrgs < ActiveRecord::Migration[5.1]
  def up
    create_table :orgs do |t|
      t.string :display_id
      t.references :type, foreign_key: true, index: true
      t.string :name, index: true
      t.string :logo_url
      t.string :cover_url
      t.string :video_url
      t.string :marker_url
      t.string :marker_color

      t.timestamps
    end
    change_column :orgs, :id, :string
  end
  def down
    drop_table :orgs
  end
end
