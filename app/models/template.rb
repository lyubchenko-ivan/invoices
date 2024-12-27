class Template < ApplicationRecord
  belongs_to :company
  has_one_attached :template_file
  
  validates :name, presence: true
  validates :company_id, presence: true
  
  def template_file_path
    ActiveStorage::Blob.service.path_for(template_file.key)
  end
end
