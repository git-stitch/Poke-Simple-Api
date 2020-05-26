class CreatePokemonAbilities < ActiveRecord::Migration[6.0]
  def change
    create_table :pokemon_abilities do |t|
      t.belongs_to :pokemon
      t.belongs_to :abilities

      t.timestamps
    end
  end
end
