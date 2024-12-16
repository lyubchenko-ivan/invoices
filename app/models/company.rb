class Company < ApplicationRecord
  belongs_to :admin_user
  has_one_attached :logo
end
