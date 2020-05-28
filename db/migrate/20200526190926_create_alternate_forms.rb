class CreateAlternateForms < ActiveRecord::Migration[6.0]
  def change
    create_table :alternate_forms do |t|
      t.belongs_to :pokemon, null: false, foreign_key: true
      t.string :name
      t.string :pokemon_entry
      t.integer :pokedex_number
      t.integer :hp
      t.integer :attack
      t.integer :defense
      t.integer :special_attack
      t.integer :special_defense
      t.integer :speed
      t.integer :height
      t.integer :weight
      t.boolean :is_mega

      t.timestamps
    end
  end
end
