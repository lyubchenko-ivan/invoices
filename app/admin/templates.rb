ActiveAdmin.register Template do
  include ActiveStorage::SetCurrent
  belongs_to :company
  remove_filter :template_file_attachment, :template_file_blob
  permit_params :name,
                :template_file,
                :company_id,
                :placeholders

  show do
    attributes_table_for(resource) do
      row :name
      row :company
      row :template do |template|
        a 'Download', href: url_for(template&.template_file) 
      end
    end
  end

  form do |f|
    f.semantic_errors
    f.inputs do
      f.input :name
      f.input :template_file, as: :file

      f.actions
    end
  end
  
  controller do
    before_action :assign_placeholders, only: %w(create update)
    
    def create
      binding.irb
      super
    end
    
    private
    
    def assign_placeholders
      params[:template][:placeholders] = TemplateServices::PlaceholdersDetector
                                           .new(params[:template][:template_file])
                                           .call
                                           .to_json
    end
  end
end
