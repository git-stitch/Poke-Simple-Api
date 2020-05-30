class CreatePokemonAbilities < ActiveRecord::Migration[6.0]
  def change
    create_table :pokemon_abilities do |t|
      t.belongs_to :pokemon
      t.belongs_to :ability
      t.boolean :is_hidden

      t.timestamps
    end
  end
end
