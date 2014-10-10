module MarkupHelper
  def html_attrs attrs
    (attrs || {}).map{|attr, val|
      if val
        %~ #{attr}="#{val}"~
      else
        %~ #{attr}~
      end
    }.join
  end
  
  def placeholder_url type, width, height, bg, color, text = nil
    case type.to_s
      when "default"
        %~http://dummyimage.com/#{width}x#{height}/#{bg}/#{color}#{"&text=#{text}" if text}~
      when "kitten"
        %~http://placekitten.com/g/#{width}/#{height}~
      when "vanilla"
        %~http://nicenicejpg.com/#{width}/#{height}~
      end
  end

  def placeholder width, height, attrs = {}
    attrs[:bg] ||= "ccc"
    attrs[:color] ||= "969696"
    attrs[:type] ||= :default
    bg = attrs.delete(:bg)
    color = attrs.delete(:color)
    placeholder_type = attrs.delete(:type)
    text = attrs.delete(:text)
    url = placeholder_url placeholder_type, width, height, bg, color, text
    return url if attrs[:tag] == false
    dimensions = attrs.delete(:dimensions)
    attrs.delete :tag
    %~<img src="#{url}" #{%~width="#{width}"~ unless dimensions == false} #{%~height="#{height}"~ unless dimensions == false} #{html_attrs attrs}/>~
  end
end