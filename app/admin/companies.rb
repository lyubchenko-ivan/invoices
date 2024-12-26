ActiveAdmin.register Company do
  include ActiveStorage::SetCurrent
  remove_filter :logo_attachment, :logo_blob
  permit_params :name,
                :logo,
                :admin_user_id
  
  show do
    attributes_table_for(resource) do
      row :name
      row :logo do |company|
        image_tag company&.logo
      end
      
      panel 'Templates' do
        if company.templates.empty?
          text_node 'Templates not found'
          a 'Create one', href: new_admin_company_template_path(company.id)
        else
          table_for(company.templates, sortable: true) do
            column :id
            column :name
            column :created_at
            column :updated_at
          end
          a 'Add', href: new_admin_company_template_path(company.id)
        end
      end
    end
  end
  
  form do |f|
    f.semantic_errors
    f.inputs do
      f.input :name
      f.input :logo, as: :file
      f.input :admin_user_id, as: :hidden, input_html: { value: current_admin_user.id }
      
      f.actions
    end
  end
end
