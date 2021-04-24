# frozen_string_literal: true

class BoxType < ApplicationRecord
  validates :name, :length, :width, :height, presence: true
  validates :name, uniqueness: true
  has_many :tariffs

  def full_name
    name
  end

  def volume
    height*width*length
  end
end
