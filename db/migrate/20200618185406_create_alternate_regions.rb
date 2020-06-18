class CreateAlternateRegions < ActiveRecord::Migration[6.0]
  def change
    create_table :alternate_regions do |t|
      t.belongs_to :alternate_form, null: false, foreign_key: true
      t.belongs_to :region, null: false, foreign_key: true

      t.timestamps
    end
  end
end
