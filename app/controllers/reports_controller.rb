class ReportsController < ApplicationController

  def free_boxes
    begin
      @start_date = params[:start_date].to_s.to_date
      @end_date = params[:end_date].to_s.to_date
    # days = (start_date..end_date).to_a
      @type_id = params[:type]
    rescue StandardError
      return
    end
    if @type_id.nil? || @start_date.nil? || @end_date.nil?
      return
    end
    sql ="SELECT contracts.box_id,box_types.id, boxes.box_type_id,
        boxes.id, contracts.start_date, contracts.rental_days FROM contracts
        LEFT JOIN boxes on boxes.id=contracts.box_id
        LEFT JOIN box_types on boxes.box_type_id = box_types.id
        WHERE box_types.id = #{@type_id} AND
        ((TO_DATE( '#{@start_date}', 'YYYY-MM-DD' ), TO_DATE( '#{@end_date}', 'YYYY-MM-DD' ))
        OVERLAPS (contracts.start_date, contracts.start_date+contracts.rental_days));"
    reserved_boxes= ActiveRecord::Base.connection.execute(sql).map {|value| value['box_id']}
    all_boxes = Box.where(box_type_id: @type_id).map {|value| value.id}
    result = all_boxes - reserved_boxes
    @result = result

    sql = "SELECT id FROM tariffs
    WHERE tariffs.box_type_id = #{@type_id} AND
    tariffs.start_date = (SELECT max(start_date) as date FROM tariffs
    WHERE (start_date <= TO_DATE( '#{@start_date}', 'YYYY-MM-DD' ))
    and box_type_id=#{@type_id}
    GROUP BY box_type_id)
    LIMIT 1;"
    tariff = Tariff.find(ActiveRecord::Base.connection.execute(sql).first['id'])
    @price_per_day = tariff.price_per_day
    @rental_days = (@start_date..@end_date).to_a.length
  end

  def clients
    begin
      @end_date = params[:end_date].to_s.to_date
    rescue StandardError
      return
    end
    sql = "SELECT contracts.client_id as client,
    count(contracts.id) as number,
    sum(terminations_of_contracts.client_debt) as client_debt,
    sum(terminations_of_contracts.company_debt) as company_debt,
    sum(contracts.deposit_amount) as deposit
    FROM contracts
    LEFT JOIN terminations_of_contracts ON contracts.terminations_of_contract_id = terminations_of_contracts.id
    WHERE contracts.start_date <= TO_DATE( '#{@end_date}', 'YYYY-MM-DD' )
    GROUP BY client"

    @result = ActiveRecord::Base.connection.execute(sql).map do |value|
      {client_id: value['client'], number: value['number'],
       income: (value['deposit'].to_s.to_f+value['client_debt'].to_s.to_f - value['company_debt'].to_s.to_f) }
    end.sort_by {|value| value[:income].to_s.to_f}.reverse

  end

  def box_types
    begin
      @end_date = params[:end_date].to_s.to_date
    rescue StandardError
      return
    end
    sql = "SELECT boxes.box_type_id as type,
    count(contracts.id) as number,
    sum(terminations_of_contracts.client_debt) as client_debt,
    sum(terminations_of_contracts.company_debt) as company_debt,
    sum(contracts.deposit_amount) as deposit
    FROM contracts
    LEFT JOIN terminations_of_contracts ON contracts.terminations_of_contract_id = terminations_of_contracts.id
    LEFT JOIN boxes on boxes.id = contracts.box_id
    WHERE contracts.start_date <= TO_DATE( '#{@end_date}', 'YYYY-MM-DD' )
    GROUP BY type"
    @result = ActiveRecord::Base.connection.execute(sql).map do |value|
      {type_id: value['type'], number: value['number'],
       income: (value['deposit'].to_s.to_f+value['client_debt'].to_s.to_f - value['company_debt'].to_s.to_f) }
    end.sort_by {|value| value[:income].to_s.to_f}.reverse

  end

  def customer_billing
    sql = "SELECT clients.id as id, clients.phone_number as phone, passports.number as passport, passports.id as passport_id,
           passports.name || ' ' || passports.surname || ' ' || passports.middle_name as full_name,
           payment_details.bank_name as bank,
           payment_details.account_number as account_number FROM clients
           LEFT JOIN passports ON passports.id = clients.passport_id
           LEFT JOIN payment_details ON payment_details.client_id = clients.id
           ORDER BY full_name ASC;"
    @result = ActiveRecord::Base.connection.execute(sql)
  end

  def monthly_revenue
    begin
      @start_date = params[:start_date].to_s.to_date
      @end_date = params[:end_date].to_s.to_date
    rescue StandardError
      return
    end
    if @start_date.to_s.length.zero? || @end_date.to_s.length.zero?
      return
    end
    sql = "SELECT contracts.id as id, tariffs.start_date as tariff_start_date,
    contracts.start_date as start_date, contracts.rental_days as days,
    tariffs.price_per_day as price FROM contracts
    LEFT JOIN boxes ON boxes.id = contracts.box_id
    LEFT JOIN box_types ON box_types.id = boxes.box_type_id
    LEFT JOIN tariffs ON tariffs.box_type_id=box_types.id
    WHERE (tariffs.start_date <= contracts.start_date) AND
     ((TO_DATE( '#{@start_date}', 'YYYY-MM-DD' ), TO_DATE( '#{@end_date}', 'YYYY-MM-DD' ))
        OVERLAPS (contracts.start_date, contracts.start_date+contracts.rental_days)) AND
    (tariffs.start_date = (SELECT max(start_date) as date FROM tariffs
    WHERE ((tariffs.start_date <= contracts.start_date) AND
     tariffs.box_type_id=box_types.id)));"
    result = ActiveRecord::Base.connection.execute(sql)
    
    date_range = @start_date..@end_date
    date_months = date_range.map {|d| Date.new(d.year, d.month, 1) }.uniq
    @result = date_months.inject({}) {|memo,d| memo[(d.strftime '%m.%y').to_s] = { number: 0, income: 0}; memo}
    result.each do |value|
      start_date =  value["start_date"].to_s.to_date
      date_array = (start_date..(start_date+value["days"].to_i.days)).to_a
      price = value["price"].to_f
      value = @result[(start_date.strftime '%m.%y').to_s]
      value[:number]+=1 unless value.nil?
      date_array.each do |date|
        value = @result[(date.strftime '%m.%y').to_s]
        next if value.nil?
        value[:income]+=price
      end
    end

  end




end
