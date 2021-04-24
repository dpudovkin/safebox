ActiveAdmin.register Passport do

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  permit_params :number, :date_of_issue, :department_code, :date_of_birth, :name, :surname, :middle_name
  #
  # or
  #
  # permit_params do
  #   permitted = [:number, :date_of_issue, :department_code, :date_of_birth, :name, :surname, :middle_name]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end
  
end
