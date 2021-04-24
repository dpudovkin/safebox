# frozen_string_literal: true

class PaymentDetail < ApplicationRecord
  validates :account_number, :BIK, :bank_name, :client_id, presence: true
  validates :account_number, uniqueness: true
  belongs_to :client

  def self.generate
    PaymentDetail.delete_all
    list = Client.all.map{|client| client.id}
    banks = (1..32).map do |value|
      {bic: Faker::Bank.swift_bic,name: Faker::Bank.name}
    end
    list.length.times do |index|
      client_id = list[index]
      account_number= Faker::Bank.account_number
      until PaymentDetail.find_by(account_number: account_number).nil?
        account_number = Faker::Bank.account_number
      end
      bank = banks.sample
      bic =  bank[:bic]
      name = bank[:name]
      payment = PaymentDetail.new(account_number: account_number, BIK: bic, bank_name: name, client_id: client_id)
      payment.save
    end
  end
end
