class PokemonSerializer < ActiveModel::Serializer
  attributes :id, :name, :pokemon_entry, :pokedex_number, :hp, :attack, :defense, :special_attack, :special_defense, :speed, :weight, :regions, :types, :sprites, :alternate_forms

end
