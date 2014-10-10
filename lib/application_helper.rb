module ApplicationHelper
  def set_index_files files
    $index_files = files
  end

  def get_index_files
    $index_files
  end

  def page_list files
    output = (files || []).map do |page| 
%~
      <li>
        <a href="#{page[:destination_path]}">
          #{page[:name]}
          #{ %~<p>#{page[:description]}</p>~ if page[:description] }
          #{ %~<small>#{page[:destination_path]}</small>~ if page[:destination_path] } 
        </a>        
      </li>
~
    end
    %~<ul class="app_index">#{output.join("")}</ul>~
  end
  
  def index_files
    html_files = sitemap.resources.find_all{|p| p.ext == ".html" }
    html_files = html_files.map do |file|
      {
        :group => file.data.page_group,
        :destination_path => file.destination_path,
        :name => file.metadata[:page]["title"] ? file.metadata[:page]["title"] : file.destination_path,
        :description => file.metadata[:page]["description"]
      }
    end

    html_files.group_by do |file|
      if file[:group]
        file[:group]
        # file.data.page_group.to_s
      elsif is_development_file? file
        "development"
      else
        "pages"
      end
    end
  end
  
  def is_development_file? file
    Settings.dev_files.each_with_index do |pattern, index|
      if !pattern.is_a?(Regexp) && pattern.to_s.match(/\/$/)
        pattern = Settings.dev_files[index] = Regexp.new("^#{pattern}")
      end
      return true if file[:destination_path].match pattern
    end
    return false
  end

  def content_for_include &block
    block.source_location.first
    return unless modules_page? && proc_at_modules_page?(block)
    content_for :_include do
      old_buffer, @_out_buf = @_out_buf, ''
      @_source_code = Sourcify::Proc::Parser::SourceCode.new(*block.source_location(false)).to_s
      @_source_code = @_source_code.strip.lines.to_a[1..-2].join.gsub(/<%.*?content_for.*?%>.*<%.*?end.*?%>/m,"").strip
      _yield = yield
      @_out_buf = old_buffer
      _yield
    end unless content_for?(:_include)
  end

  def modules_page?
    current_page.path.match /^modules\//
  end

  def proc_at_modules_page? proc
    proc_source = proc.source_location.first
    module_page = current_page.path.split("/").last
    proc_module_page = proc_source.split("/").last.gsub(/^_/, "").gsub(/\.erb$/, "")
    proc_module_page == module_page
  end
end