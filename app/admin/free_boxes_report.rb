ActiveAdmin.register_page "Report on free boxes" do
  menu false

  content do

    render "partial_name"
    form action: admin_report_on_free_boxes_show_path, method: :get do |f|
      f.input :box_type_id, as: :select, collection: BoxType.all.collect { |type| [type.full_name.to_s, type.id] }, name: 'type'
      f.input "start_date", as: :datepicker, name: 'start_date'
      f.input "end_date", as: :datepicker, name: 'end_date'
      f.input :submit, type: :submit
    end

  end



  page_action :show, method: :get do
    redirect_to admin_report_on_free_boxes_path(type: params['type'].to_s,
                                                start_date: params['start_date'].to_s, end_date: params['end_date'])
  end






end
