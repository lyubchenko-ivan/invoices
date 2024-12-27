class InvoicesController < ApplicationController
  api :GET, '/users/:id'
  param :template_id, :number, desc: 'id of the using template'
  param :data, Hash, desc: 'Data for using template'
  
  error 404, 'Template not found'
  error 500, 'Internal Issuses'

  returns :code => 200 do
    property :output_file, String, :desc => "Url to getting generated file"
  end
  
  def create
    return raise_not_found unless template

    output_file = InvoiceServices::GeneratePdf
                    .new(template: template, data: permitted_params[:data])
                    .call
    return render json: {
      output_file: url_for(output_file)
    }
  end

  private

  def template
    @template ||= Template.find_by(id: permitted_params[:template_id])
  end

  def raise_not_found
    render code: 404
  end
  
  def permitted_params
    @permitted_params ||= params.permit!
  end
end
