module ApplicationHelper
  def page_list files
    output = (files || []).map do |page| 
      page_name = page.metadata[:page]["title"] ? page.metadata[:page]["title"] : page.destination_path
%~
      <li>
        <a href="#{page.destination_path}">
          #{page_name}
          #{ %~<p>#{page.metadata[:page]["description"]}</p>~ if page.metadata[:page]["description"] }
          #{ %~<small>#{page.destination_path}</small>~ if page.destination_path } 
        </a>        
      </li>
~
    end
    %~<ul class="app_index">#{output.join("")}</ul>~
  end
  
  def index_files
    html_files = sitemap.resources.find_all{|p| p.ext == ".html" }
    html_files.group_by do |file|
      if file.data && file.data.page_group
        file.data.page_group.to_s
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
      return true if file.destination_path.match pattern
    end
    return false
  end
end