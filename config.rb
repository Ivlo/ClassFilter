###
# Compass
###

require "lib/settings.rb"
Settings.init self.environment

# Change Compass configuration
compass_config do |config|
  config.output_style = Settings.sass.output_style
  config.sass_options = { 
    :line_comments => false,
    :debug_info => Settings.sass.source_maps
  }
end

modules_path = "source/#{Settings.paths.partials}#{Settings.paths.modules}*.html.erb"
Dir.glob(modules_path) do |file|
  module_name = File.basename(file, ".html.erb").gsub(/^_/,"")
  proxy "/modules/#{module_name}.html", "modules.html", 
          :locals => { :module_name => module_name }
end

activate :syntax, line_numbers: true

###
# Helpers
###

require "lib/partials_helper"
require "lib/markup_helper"
require "lib/application_helper"
helpers PartialsHelper
helpers MarkupHelper
helpers ApplicationHelper

set :fonts_dir, Settings.paths.assets.fonts
set :css_dir, Settings.paths.assets.css
set :js_dir, Settings.paths.assets.js
set :images_dir, Settings.paths.assets.images
set :partials_dir, Settings.paths.partials
set :layout_dir, Settings.paths.layouts

Settings.ignore_files.each do |pattern|
  ignore pattern
end

# Build-specific configuration
configure :build do
  
  # JS minification
  activate :minify_javascript if Settings.minify_js
  
  # Use relative URLs
  activate :relative_assets
end