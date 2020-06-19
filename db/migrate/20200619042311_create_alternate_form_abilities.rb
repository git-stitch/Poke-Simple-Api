class CreateAlternateFormAbilities < ActiveRecord::Migration[6.0]
  def change
    create_table :alternate_form_abilities do |t|
      t.belongs_to :alternate_form, null: false, foreign_key: true
      t.belongs_to :ability, null: false, foreign_key: true
      t.boolean :is_hidden

      t.timestamps
    end
  end
end
