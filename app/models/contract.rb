# frozen_string_literal: true

require 'active_support/time'
class Contract < ApplicationRecord
  belongs_to :client
  belongs_to :terminations_of_contract, optional: true
  belongs_to :box
  has_one :next_contract, class_name: 'Contract',
                          foreign_key: 'previous_contract_id'

  belongs_to :previous_contract, class_name: 'Contract', optional: true
  validates :box_id, :start_date, :rental_days, :deposit_amount, presence: true
  validates :terminations_of_contract_id, presence: false

  def full_name
    # "Date: #{start_date} Box:#{box.full_name} Client: #{client.full_name}"
    "Date: #{start_date} Rental_days:#{rental_days} Id: #{id}"
  end

  def self.generate
    # Contract.delete_all
    # TerminationsOfContract.delete_all
    numbers = 20000
    client_ids = Client.all.map(&:id)
    box_ids =  Box.all.map(&:id)
    numbers.times do |index|
      client_id = client_ids.sample
      box_id = box_ids.sample
      chain_seed = Random.rand(1..1000)
      date_range = free_dates(box_id).map{|value| value}
      next if date_range.length < 9
      puts "Number: #{index}"

      deposit =  date_range.length * 250
      contract = Contract.new(client_id: client_id, box_id: box_id, start_date: date_range.first,
                   rental_days: date_range.length / 3, deposit_amount: deposit)
      contract.save

      if chain_seed < 500
        termination = TerminationsOfContract.build(contract.full_cost, contract.deposit_amount,contract.last_day)
        termination.save
        contract.terminations_of_contract = termination
        contract.save
        next
      end

      contract = Contract.new(client_id: client_id, box_id: box_id, start_date: contract.last_day + 1.days,
                              rental_days: date_range.length / 3 - 1, deposit_amount: 0, previous_contract: contract)
      contract.save

      if chain_seed < 700
        termination = TerminationsOfContract.build(contract.full_cost, deposit,contract.last_day)
        termination.save
        contract.terminations_of_contract = termination
        contract.save
        next
      end

      contract = Contract.new(client_id: client_id, box_id: box_id, start_date: contract.last_day + 1.days,
                              rental_days: date_range.length / 3 - 1, deposit_amount: 0, previous_contract: contract)
      contract.save

      termination = TerminationsOfContract.build(contract.full_cost, deposit,contract.last_day)
      termination.save
      contract.terminations_of_contract_id= termination.id
      contract.save

    end
  end

  def self.free_dates(box_id)
    contracts = Contract.where(box_id: box_id)
    return Date.new(2020, 1, 15)..Date.new(2020, 1, 30) if contracts.length.zero?
    goal =  Random.rand(9..60)
    range = []
    contracts.each do |contract|
      range.append(contract.start_date..(contract.start_date + contract.rental_days.days))
    end
    dates = (Date.new(Random.rand(2015..2019), Random.rand(1..12), 1)..Date.new(2025, 1, 1)).to_a
    res = dates.select do |date|
      range.all? do |range|
        !range.cover?(date)
      end
    end.inject([]) do |result, date|
      return result if result.length >= goal

      if result.length.zero?
        result.append(date)
      else
        if (result.last + 1.days) == date
          result.append(date)
        else
          result.clear
        end  
      end  
    end
    return res
  end

  def self.random_date_in_year(year)
    return rand(Date.civil(year.min, 1, 1)..Date.civil(year.max, 12, 31)) if year.is_a?(Range)
    rand(Date.civil(year, 1, 1)..Date.civil(year, 12, 31))
  end

=begin
  def start_date
    start_date
  end

  def rental_days
    rental_days
  end
=end

  def last_day
    start_date + rental_days.days
  end

  def full_cost
    type_id = box.box_type.id
    tariffs = Tariff.where(box_type_id: type_id).select do |tariff|
      tariff.start_date<start_date
    end
    rent = tariffs.max_by(&:start_date).price_per_day
    prev_cost = 0
    prev_cost = previous_contract.full_cost unless previous_contract.nil?
    prev_cost + rent * rental_days
  end

  def type_id
    box.box_type.id
  end

  def list_days
    (start_date..(start_date+rental_days.days)).to_a
  end



end
