require 'pathname'
module PartialsHelper
	def shared partial_name, locals = {}, &block
    render_with_block "#{Settings.paths.shared}#{partial_name.to_s}", locals, &block
  end

  def modules(partial_name, locals = {}, &block) 
    render_with_block "#{Settings.paths.modules}/#{partial_name.to_s}", locals, &block
  end

  self.instance_eval do

    Dir["source/#{Settings.paths.partials}#{Settings.paths.modules}*.html.erb"].each do |file|
      filepath = File.basename(file, ".html.erb").gsub(/^_/,"")
      filename = Pathname(filepath).basename.to_s
      define_method filename do |locals = {}, &block|
        modules filename, locals , &block
      end
    end

  end

  def render_with_block partial_path, locals = {}, &block
    if block_given?
      old_buffer, @_out_buf = @_out_buf, ''
      _yield = yield
      output = partial partial_path, :locals => { :_yield => _yield }.merge(locals)
      @_out_buf = old_buffer + output
    else
      partial partial_path, :locals=>locals
    end
  end

  def generic_module_inclusion module_name
    %~<%= modules "#{module_name}" %>~
  end
end