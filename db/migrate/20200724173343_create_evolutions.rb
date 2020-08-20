class CreateEvolutions < ActiveRecord::Migration[6.0]
  def change
    create_table :evolutions do |t|
      t.belongs_to :pokemon, null: false, foreign_key: true
      t.string :evo_to
      t.string :evo_when
      t.string :evo_from

      t.timestamps
    end
  end
end
