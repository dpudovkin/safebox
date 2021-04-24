# frozen_string_literal: true

class TerminationsOfContract < ApplicationRecord
  has_one :contract
  validates :client_debt, :company_debt, presence: true

  def full_name
    "Id #{id}:"
  end

  def self.build(cost, deposit, date)
    balance =  cost - deposit
    company_debt =0
    client_debt =0
    if balance.positive?
      company_debt = balance
    else
      client_debt = balance
    end
    TerminationsOfContract.new(company_debt: company_debt, client_debt: client_debt, termination_date: date)
  end
end
