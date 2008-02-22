require 'redcloth'
module TextilizeFu
  class << self
    def translate(str)
      RedCloth.new(str, [:hard_breaks]).to_html
    end
  end
  
  def self.included(base)
    base.extend ClassMethods 
    class << base
      attr_accessor :textilize_attribute
      attr_accessor :html_field
    end
  end
  
  module ClassMethods
    # Specifies the given field(s) as using textile, meaning it is passed through TextilizeFu.translate and set to the html_field.  
    #
    #   class Foo < ActiveRecord::Base
    #     # stores the html version of body in body_html
    #     textilize :body
    #   
    #     # stores html version of textile_body into converted_body
    #     textilize :textile_body, :converted_body
    #
    #   end
    #
    def textilize(attr_name, html_field_name = nil)
      self.textilize_attribute  = attr_name
      self.html_field           = html_field_name || "#{attr_name.to_s}_html".to_sym
      before_save :create_textilized_field
    end
  end
  
protected
  def create_textilized_field
    send("#{self.class.html_field}=", TextilizeFu.translate(send(self.class.textilize_attribute))) unless send(self.class.textilize_attribute).nil?
  end

end
