class Ability < ApplicationRecord
    has_many :pokemon_ability, :dependent => :delete_all
    has_many :pokemon, through: :pokemon_ability
    has_many :alternate_form_ability, :dependent => :delete_all
    has_many :alternate_forms, through: :alternate_form_ability
end
