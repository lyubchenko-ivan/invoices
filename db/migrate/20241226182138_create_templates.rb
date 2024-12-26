class CreateTemplates < ActiveRecord::Migration[7.1]
  def change
    create_table :templates do |t|
      t.string :name, null: false
      t.json :placeholders
      t.belongs_to :company, null: false
      
      t.timestamps
    end
  end
end
