class CreateAlternateFormTypes < ActiveRecord::Migration[6.0]
  def change
    create_table :alternate_form_types do |t|
      t.belongs_to :alternate_form, null: false, foreign_key: true
      t.belongs_to :type, null: false, foreign_key: true

      t.timestamps
    end
  end
end
