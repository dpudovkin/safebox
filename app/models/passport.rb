# frozen_string_literal: true
require 'active_support/time'

class Passport < ApplicationRecord
  validates :number, :date_of_issue, :date_of_birth, :department_code, :middle_name, :surname, :name, presence: true
  validates :number, uniqueness: true
  validates :number, format: { with: /[0-9]{2}[0-9]{2}[0-9]{6}/, message: 'only format with 10 numbers' }
  validates :department_code, format: { with: /[0-9]{3}-[0-9]{3}/, message: 'only this format [***-***]' }
  has_one :client

  def self.generate
    Passport.delete_all
    pattern_number = '[0-9]{10}'
    pattern_code = '[0-9]{3}-[0-9]{3}'
    5000.times do |_|
      date_of_birth = random_date_in_year(1960..2004)
      date_of_issue = date_of_birth + Random.rand(14..16).years + Random.rand(2..30).days
      number = Faker::Base.regexify(pattern_number)
      code =  Faker::Base.regexify(pattern_code)
      name =  Faker::Name.first_name
      surname = Faker::Name.last_name
      middle_name = Faker::Name.middle_name
      passport = Passport.new(date_of_issue: date_of_issue, date_of_birth: date_of_birth, number: number,
                              department_code: code, name: name, surname: surname, middle_name: middle_name)

      passport.save
    end

  end

  def full_name
    "#{name} #{surname} #{middle_name}"
  end

  def self.random_date_in_year(year)
    return rand(Date.civil(year.min, 1, 1)..Date.civil(year.max, 12, 31)) if year.kind_of?(Range)
    rand(Date.civil(year, 1, 1)..Date.civil(year, 12, 31))
  end

end
