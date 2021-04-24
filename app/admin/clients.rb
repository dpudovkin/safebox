# frozen_string_literal: true

ActiveAdmin.register Client do
  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  permit_params :passport_id, :phone_number, :extra_phone_number, :email

  preserve_default_filters!
  filter :passport, as: :select, collection:
    Passport.all.collect { |passport| ["#{passport.number} #{passport.full_name}", passport.id] }

  form do |f|
    f.semantic_errors(*f.object.errors.keys)

    f.inputs 'Details' do
      f.input :passport_id, as: :select, collection:
        Passport.all.collect { |passport| ["#{passport.number} #{passport.full_name}", passport.id] }
      f.input :phone_number
      f.input :extra_phone_number
      f.input :email
    end
    f.actions
  end
  #
  # or
  #
  # permit_params do
  #   permitted = [:passport_id, :phone_number, :extra_phone_number, :email]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end
end
