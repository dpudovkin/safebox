class Tariff < ApplicationRecord
  belongs_to :box_type
  validates :price_per_day, :start_date, :box_type_id, presence: true

  # temporary
  def self.update
    Tariff.all.each do |tariff|
      tariff.start_date = Date.today - 15.years
      tariff.save
    end
  end

  # temporary
  def self.add_new
    Tariff.delete_all
    new = { 1 => [155,150,145,160,170,150,165,180,170],
    2 => [165,170,180,190,195,180,185,195,190], 3 => [195,200,205,195,190,195,210,220,215],
    4 => [240,230,235,245,250,240,245,250,255], 5 => [260,265,270,280,285,275,290,295,280],
    6 => [295,290,305,310,315,325,330,315,320], 7 => [330,350,370,340,345,342,340,370,375],
    8 => [395,410,420,430,420,410,415,405,440], 9 => [450,455,490,510,520,525,530,540,545],
    10 => [700,790,820,900,785,910,950,1010,1090]}

    new.each do |type_id,value|
      date = Date.new(2014,1,10)
      value.each do |price|
        date = date + Random.rand(150..300).days
        Tariff.new(price_per_day: price, start_date: date,box_type_id: type_id).save
      end
    end
  end

  def full_name
    "Box type: #{box_type.full_name} Price per day: #{price_per_day} RUB"
  end

  def self.actual(date)
    types = BoxType.all.map{|value| value.id}
    result = types.sort_by{|id| id.to_i}.map do |type_id|
      sql = "SELECT id FROM tariffs
      WHERE tariffs.box_type_id = #{type_id} AND
      tariffs.start_date = (SELECT max(start_date) as date FROM tariffs
      WHERE (start_date <= TO_DATE( '#{date}', 'YYYY-MM-DD' ))
      and box_type_id=#{type_id}
      GROUP BY box_type_id)
      LIMIT 1;"
      ActiveRecord::Base.connection.execute(sql).first['id'].to_i
    end
    return result
  end
  
end
