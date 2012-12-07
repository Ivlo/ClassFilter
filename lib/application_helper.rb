module ApplicationHelper
  def page_list files
    output = (files || []).map do |page| 
      page_name = page.metadata[:page]["title"] ? page.metadata[:page]["title"] : page.destination_path
%~
      <li>
        <a href="#{page.destination_path}">#{page_name}</a>
        #{ %~<p>#{page.metadata[:page]["description"]}</p>~ if page.metadata[:page]["description"] }
        <small>#{page.destination_path}</small>
        
      </li>
~
    end
    %~<ul class="app_index">#{output.join("")}</ul>~
  end
end