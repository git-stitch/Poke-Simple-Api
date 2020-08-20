class AlternateForm < ApplicationRecord
  belongs_to :pokemon
  has_many :alternate_form_types, :dependent => :delete_all
  has_many :types, through: :alternate_form_types
  has_many :alternate_regions, :dependent => :delete_all
  has_many :regions, through: :alternate_regions
  has_many :alternate_form_abilities, :dependent => :delete_all
  has_many :abilities, through: :alternate_form_abilities
  has_many :alternate_form_sprites, :dependent => :delete_all
  has_many :alternate_form_evos, :dependent => :delete_all
end
