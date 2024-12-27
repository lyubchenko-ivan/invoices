class InvoicesController < ApplicationController
  def create
    return raise_not_found unless template

    output_file = InvoiceServices::GeneratePdf
                    .new(template: template, data: permitted_params[:data])
                    .call
    return render json: {
      output_file: output_file
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
