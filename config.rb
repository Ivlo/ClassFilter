###
# Compass
###

# Susy grids in Compass
# First: gem install susy --pre
# require 'susy'

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

###
# Page options, layouts, aliases and proxies
###

# Per-page layout changes:
#
# With no layout
# page "/path/to/file.html", :layout => false
#
# With alternative layout
# page "/path/to/file.html", :layout => :otherlayout
#
# A path which all have the same layout
# with_layout :admin do
#   page "/admin/*"
# end

# Proxy (fake) files
# page "/this-page-has-no-template.html", :proxy => "/template-file.html" do
#   @which_fake_page = "Rendering a fake page with a variable"
# end

###
# Helpers
###

# Automatic image dimensions on image_tag helper
# activate :automatic_image_sizes

# Methods defined in the helpers block are available in templates
# helpers do
#   def some_helper
#     "Helping"
#   end
# end

require "lib/partials_helper"
require "lib/markup_helper"
require "lib/application_helper"
helpers PartialsHelper
helpers MarkupHelper
helpers ApplicationHelper

set :fonts_dir, 'assets/fonts'
set :css_dir, 'assets/stylesheets'
set :js_dir, 'assets/javascripts'
set :images_dir, 'assets/images'

ignore "assets/images/raw/*"
ignore "assets/javascripts/development/*"
ignore "*/delete"

# Build-specific configuration
configure :build do
  # For example, change the Compass output style for deployment
  # activate :minify_css

  # Minify Javascript on build
  activate :minify_javascript if Settings.minify_js
  

  # Enable cache buster
  # activate :cache_buster

  # Use relative URLs
  activate :relative_assets

  # Compress PNGs after build
  # First: gem install middleman-smusher
  # require "middleman-smusher"
  # activate :smusher

  # Or use a different image path
  # set :http_path, "/Content/images/"
end