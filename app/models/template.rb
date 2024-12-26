class Template < ApplicationRecord
  belongs_to :company
  has_one_attached :template_file
  
  validates :name, presence: true
  validates :company_id, presence: true
end
