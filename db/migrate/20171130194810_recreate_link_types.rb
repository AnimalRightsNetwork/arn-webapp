class RecreateLinkTypes < ActiveRecord::Migration[5.1]
  def change
    create_table :link_types, force: true do |t|
      t.string :name, null: false
      t.string :icon_url, null: false
    end
    add_index :link_types, :name, unique: true
  end
end
