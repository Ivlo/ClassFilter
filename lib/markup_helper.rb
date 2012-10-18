module MarkupHelper
  def html_attrs attrs
    (attrs || {}).map{|attr, val|
      %~ #{attr}="#{val}"~
    }.join
  end
  
  def placeholder width, height, attrs = {}
    url = %~http://dummyimage.com/#{width}x#{height}/ccc/969696~
    %~<img src="#{url}" width="#{width}" height="#{height}" #{html_attrs attrs}/>~
  end
end