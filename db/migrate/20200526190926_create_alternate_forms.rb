class CreateAlternateForms < ActiveRecord::Migration[6.0]
  def change
    create_table :alternate_forms do |t|
      t.belongs_to :pokemon, null: false, foreign_key: true
      t.string :name
      t.string :pokemon_entry
      t.number :pokedex_number
      t.number :hp
      t.number :attack
      t.number :defense
      t.number :special_attack
      t.number :special_defense
      t.number :speed
      t.number :height
      t.number :weight
      t.boolean :is_mega

      t.timestamps
    end
  end
end
