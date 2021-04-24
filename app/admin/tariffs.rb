ActiveAdmin.register Tariff do

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #

  permit_params :price_per_day, :start_date,:box_type_id
  #
  # or
  #
=begin
  permit_params do
    permitted = [:price_per_day, :start_date, :box_type_id]
    permitted << :other if params[:action] == 'create' && current_user.admin?
    permitted
  end
=end

=begin
  form do |f|
    f.inputs "Tariffs" do
      f.input :price_per_day
      f.input :start_date
      f.input :box_type_id, :as => :select, :collection => BoxType.all.collect {|type| [type.label, type.floor] }
    end
    f.actions
  end
=end

end
