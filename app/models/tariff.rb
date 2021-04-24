class Tariff < ApplicationRecord
  belongs_to :box_type
  validates :price_per_day, :start_date, :box_type_id, presence: true
  
  def self.update
    Tariff.all.each do |tariff|
      tariff.start_date = Date.today - 15.years
      tariff.save
    end
  end
  
end
