class CreateCompanies < ActiveRecord::Migration[7.1]
  def change
    create_table :companies do |t|
      t.string :name, null: false
      t.belongs_to :admin_user
      
      t.timestamps
    end
  end
end
