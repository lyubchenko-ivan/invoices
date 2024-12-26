class Company < ApplicationRecord
  has_many :templates
  belongs_to :admin_user
  has_one_attached :logo
end
