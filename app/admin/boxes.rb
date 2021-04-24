# frozen_string_literal: true

ActiveAdmin.register Box do
  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  permit_params :number, :box_type_id, :section_id

  preserve_default_filters!
  filter :section, as: :select, collection: Section.all.collect { |section| ["Label: #{section.label} Floor: #{section.floor}", section.id]}


  form do |f|
    f.semantic_errors(*f.object.errors.keys)

    f.inputs 'Details' do
      f.input :number
      f.input :box_type_id, as: :select, collection: BoxType.all.collect { |box_type| [box_type.name, box_type.id] }
      f.input :section_id, as: :select, collection: Section.all.collect { |section| ["#{section.label} #{section.floor}", section.id] }
    end
    f.actions
  end
  #
  # or
  #
  # permit_params do
  #   permitted = [:number, :box_type_id, :section_id]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end
end
