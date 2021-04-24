Rails.application.routes.draw do
  get 'admin/index'
  ActiveAdmin.routes(self)
  root to: 'admin#index'
  get 'admin/new_boxes'
  get 'admin/new_passports'
  get 'admin/new_clients'
  get 'admin/new_payment_details'
  get 'admin/new_contracts'
  get 'admin/update_tariff'


  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
