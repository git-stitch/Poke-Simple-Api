class CreatePokemonRegions < ActiveRecord::Migration[6.0]
  def change
    create_table :pokemon_regions do |t|
      t.belongs_to :region, null: false, foreign_key: true
      t.belongs_to :pokemon, null: false, foreign_key: true

      t.timestamps
    end
  end
end
