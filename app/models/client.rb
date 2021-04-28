# frozen_string_literal: true

class Client < ApplicationRecord
  belongs_to :passport
  validates :passport_id, uniqueness: true
  validates :passport_id, :phone_number, :email, presence: true
  validates :phone_number, format: { with: /\+[0-9]{11}/, message: 'only format with + and 11 numbers' }
  validates :email, format: { with: /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i, message: 'only email format' }
  has_one :payment_detail
  has_many :contracts


  def self.generate
    Client.delete_all
    list = Passport.all
    phone_pattern = '+[0-9]{11}'
    list.length.times do |index|
      passport_id =  list[index].id
      phone_number = Faker::Base.regexify(phone_pattern)
      if Random.rand(0..9)>5
        extra_number = Faker::Base.regexify(phone_pattern)
      end
      email = Faker::Internet.email
      client =  Client.new(passport_id: passport_id, phone_number: phone_number,
                           extra_phone_number: extra_number, email: email)
      client.save
    end
  end

  def full_name
    # passport.full_name
    "Email:#{email} Passport id:#{passport_id}"
  end

  def name
    passport.full_name
  end


end
