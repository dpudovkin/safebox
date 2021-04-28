class Box < ApplicationRecord
  belongs_to :box_type
  belongs_to :section
  validates :number, uniqueness: true
  validates :box_type_id, :section_id, presence: true
  has_many :contracts


  def self.generate
    Box.delete_all
    sections = Section.all
    types = BoxType.all
    borders = [1,20]
    small_types =  types.select{|type| type.volume<borders[0]}
    medium_types = types.select{|type| type.volume>=borders[0] && type.volume<=borders[1]}
    large_types =  types.select{|type| type.volume>borders[1]}
    current =1

    section_a  = sections.find(1)
    numbers = Random.rand(90..120)
    numbers.times do |_|
      new_box = Box.new(number: current,section_id: section_a.id, box_type_id: large_types.sample.id)
      new_box.save
      current+=1
    end

    no_small_types  = medium_types.union(large_types)

    (2..5).each do |section_id|
      numbers = Random.rand(100..300)
      numbers.times do |_|
        new_box  = Box.new(number: current, section_id: section_id, box_type_id: no_small_types.sample.id)
        new_box.save
        current+=1
      end
    end

    no_large_types = medium_types.union(small_types)

    (6..9).each do |section_id|
      numbers = Random.rand(400..900)
      numbers.times do |_|
        new_box  = Box.new(number: current, section_id: section_id, box_type_id: no_large_types.sample.id)
        new_box.save
        current+=1
      end
    end

    section_j = sections.find(10)
    numbers = Random.rand(1000..2500)
    numbers.times do |_|
      new_box = Box.new(number: current,section_id: section_j.id, box_type_id: small_types.sample.id)
      new_box.save
      current+=1
    end
  end

  def full_name
    "Number:#{number} Section:#{section.full_name} Type:#{box_type.full_name}"
  end


end
