module TemplateServices
  class PlaceholdersDetector
    def initialize(template_file)
      @template_file = template_file
    end
    
    def call
      file
        .split("\n")
        .each
        .with_index
        .reduce({}) do |result, (line, index)| 
          result[index] = line.scan(/\{\w+\}/)
          result
        end
    end
    
    private
    attr_reader :template_file
    
    def file
      @file ||= Docx::Document.open(template_file.tempfile).to_s
    end
  end
end
