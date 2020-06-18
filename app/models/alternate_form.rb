class AlternateForm < ApplicationRecord
  belongs_to :pokemon
  has_many :pokemon_types, :dependent => :delete_all
  has_many :types, through: :pokemon_types
  has_many :alternate_regions, :dependent => :delete_all
  has_many :regions, through: :alternate_regions
  has_many :pokemon_abilities, :dependent => :delete_all
  has_many :abilities, through: :pokemon_abilities
  has_many :sprites, :dependent => :delete_all
end
