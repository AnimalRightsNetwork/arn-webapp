class CreateOrgTypes < ActiveRecord::Migration[5.1]
  def change
    create_table :org_types do |t|
      t.string :name
      t.string :icon_url
    end
  end
end
