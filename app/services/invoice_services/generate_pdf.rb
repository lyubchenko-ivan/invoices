module InvoiceServices
  class GeneratePdf
    def initialize(template:, data:)
      @template = template
      @data = data
      
    end
    
    def call
      insert_placeholders
      convert_to_pdf
      clean_tmp_data
      
      @invoice.file
    end
    
    private
    attr_reader :template, :data, :user
    
    def insert_placeholders
      i = 0
      doc.each_paragraph do |p|
        p.each_text_run do |tr|
          placeholders[i.to_s].each do |placeholder|
            tr.substitute(placeholder, data[placeholder[1...-1].to_sym].to_s)
          end
        end
        i += 1
      end
      
      doc.save(tmp_file)
    end
    
    def placeholders
      JSON.parse(template.placeholders)
    end
    
    def convert_to_pdf
      Libreconv.convert(tmp_file, output_file)
      @invoice = Invoice.create
      @invoice.file.attach(io: output_file, filename: output_file.path)
    end
    
    def clean_tmp_data
      FileUtils.rm(output_file)  
    end

    def tmp_file
      "/tmp/#{base_output_filename}.docx"
    end

    def output_file
      @output_file ||= Tempfile.new("#{base_output_filename}.pdf")
    end
    
    def base_output_filename
      @base_output_filename ||= "#{template.id}#{DateTime.now.strftime('%Y%M%d%H%m%s%L')}"  
    end
    
    def doc
      @doc ||= Docx::Document.open(template.template_file_path)
    end
  end
end
