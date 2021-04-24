# frozen_string_literal: true

class Section < ApplicationRecord
  validates :label, :floor, presence: true
  validates :label, uniqueness: true
  has_many :boxes

  def full_name
    "#{label} #{floor}"
  end

end
