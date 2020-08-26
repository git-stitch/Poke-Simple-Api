class Region < ApplicationRecord
    has_many :pokemon_regions, :dependent => :delete_all
    has_many :pokemon, through: :pokemon_regions
    has_many :alternate_regions, :dependent => :delete_all
    has_many :alternate_forms, through: :alternate_regions
end
