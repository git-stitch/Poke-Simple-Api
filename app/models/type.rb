class Type < ApplicationRecord
    has_many :pokemon_types, :dependent => :delete_all
    has_many :pokemon, through: :pokemon_types
    has_many :alternate_form_types, :dependent => :delete_all
    has_many :alternate_forms, through: :alternate_form_types
end
