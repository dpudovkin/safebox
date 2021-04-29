# frozen_string_literal: true

class ChartsController < ApplicationController
  def clients_age
    sql = "SELECT EXTRACT(YEAR FROM age(passports.date_of_birth)) as year,
          COUNT(id) as number FROM passports
          GROUP BY year
          ORDER BY year ASC"
    @result = ActiveRecord::Base.connection.execute(sql).each_with_object({}) do |value, mem|
      mem[value['year']] = value['number'].to_i
    end
  end

  def banks
    sql = "SELECT payment_details.bank_name as bank,
          count(contracts.id) as number FROM contracts
          LEFT JOIN clients ON clients.id = contracts.client_id
          LEFT JOIN payment_details ON payment_details.client_id = clients.id
          GROUP BY bank
          ORDER BY number DESC"
    @result = ActiveRecord::Base.connection.execute(sql).each_with_object({}) do |value, mem|
      mem[value['bank']] = value['number'].to_f
    end
  end

  def tariffs
    types = BoxType.all.map(&:id)
    @result = types.sort_by(&:to_i).map do |type_id|
      sql = "SELECT id,price_per_day,start_date FROM tariffs
      WHERE tariffs.box_type_id = #{type_id}
      ORDER BY start_date"
      name = BoxType.find(type_id).full_name
      data = ActiveRecord::Base.connection.execute(sql).each_with_object({}) do |value, memo|
        memo[value['start_date']] = value['price_per_day']
      end
      { name: name, data: data }
    end
  end
end
