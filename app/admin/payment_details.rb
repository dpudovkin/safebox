# frozen_string_literal: true

ActiveAdmin.register PaymentDetail do
  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  permit_params :client_id, :account_number, :BIK, :bank_name

  preserve_default_filters!
  filter :client, as: :select, collection: Client.all.collect { |client| [client.full_name.to_s, client.id] }

  form do |f|
    f.semantic_errors(*f.object.errors.keys)
    f.inputs 'Details' do
      f.input :account_number
      f.input :BIK
      f.input :bank_name
      f.input :client_id, as: :select, collection: Client.all.collect { |client| [client.full_name.to_s, client.id] }
    end
    f.actions
  end

  #
  # or
  #
  # permit_params do
  #   permitted = [:client_id, :account_number, :BIK, :bank_name]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end
end
