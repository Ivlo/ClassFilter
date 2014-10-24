require "erb"
include ERB::Util

module SocialHelper
  def encoded_url_params params
    params.map do |key, val|
      val ? "#{key}=#{url_encode(val)}" : nil
    end.compact.join("&")
  end

  def share_url type, options
    case type
      when :twitter
        "https://twitter.com/intent/tweet?#{encoded_url_params({
            url: options[:url],
            text: options[:text],
            via: options[:via]
          })}"
      when :fb
        "https://www.facebook.com/sharer/sharer.php?#{encoded_url_params({
          u: options[:url]
        })}"
      when :gplus
        "https://plus.google.com/share?#{encoded_url_params({
          url: options[:url]
        })}"
    end
  end
end