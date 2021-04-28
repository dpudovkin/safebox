class Tariff < ApplicationRecord
  belongs_to :box_type
  validates :price_per_day, :start_date, :box_type_id, presence: true
  
  def self.update
    Tariff.all.each do |tariff|
      tariff.start_date = Date.today - 15.years
      tariff.save
    end
  end

  def full_name
    "Box type: #{box_type.full_name} Price per day: #{price_per_day} RUB"
  end
  
end
