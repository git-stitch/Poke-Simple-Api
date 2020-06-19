class CreateAlternateFormSprites < ActiveRecord::Migration[6.0]
  def change
    create_table :alternate_form_sprites do |t|
      t.belongs_to :alternate_form, null: false, foreign_key: true
      t.string :back_default
      t.string :back_female
      t.string :back_shiny
      t.string :back_shiny_female
      t.string :front_default
      t.string :front_female
      t.string :front_shiny
      t.string :front_shiny_female

      t.timestamps
    end
  end
end
