class CreatePokemons < ActiveRecord::Migration[6.0]
  def change
    create_table :pokemons do |t|
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
      
      t.timestamps
    end
  end
end