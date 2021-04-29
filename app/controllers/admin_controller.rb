class AdminController < ApplicationController
  def index
  end

  def new_boxes
    Box.generate
  end

  def new_passports
    Passport.generate
  end

  def new_clients
    Client.generate
  end

  def new_payment_details
    PaymentDetail.generate
  end

  def new_contracts
    Contract.generate
  end

  def update_tariff
    Tariff.update
  end

  def add_tariff
    Tariff.add_new
  end
end
