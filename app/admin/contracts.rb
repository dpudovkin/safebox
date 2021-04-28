# frozen_string_literal: true

ActiveAdmin.register Contract do
  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  permit_params :client_id, :previous_contract_id, :termination_of_contract_id, :box_id, :deposit_amount, :rental_days, :start_date
  preserve_default_filters!
  # filter :box, as: :select, collection: Box.all.collect { |box| [box.full_name.to_s, box.id] }
  filter :client, as: :select, collection: Client.all.collect { |client| [client.full_name.to_s, client.id] }
  form do |f|
    f.semantic_errors(*f.object.errors.keys)

    f.inputs 'Details' do
      f.input :client_id, as: :select, collection: Client.all.collect { |client| [client.full_name, client.id] }
      f.input :box_id, as: :select, collection: Box.first(100).collect { |box| [box.full_name.to_s, box.id] }
      f.input :deposit_amount
      f.input :rental_days
      f.input :start_date
      f.input :terminations_of_contract_id, as: :select, collection:
        TerminationsOfContract.first(100).collect { |termination| [termination.full_name.to_s, termination.id] }
        # TerminationsOfContract.first(100).collect { |termination| [termination.id.to_s, termination.id] }
      f.input :previous_contract_id, as: :select, collection:
      Contract.first(100).collect {|contract| [contract.full_name.to_s, contract.id]}
      # Contract.first(100).collect {|contract| [contract.id.to_s, contract.id]}
    end
    f.actions
  end

  #
  # or
  #
  # permit_params do
  #   permitted = [:client_id, :previous_contract_id, :termination_of_contract_id, :box_id, :deposit_amount, :rental_days, :start_date]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end
end
