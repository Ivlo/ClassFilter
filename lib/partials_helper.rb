module PartialsHelper
	def shared partial_name, locals = {}, &block
    render_with_block "#{Settings.paths.shared}#{partial_name.to_s}", locals, &block
  end

  def modules(partial_name, locals = {}, &block) 
    render_with_block "#{Settings.paths.modules}/#{partial_name.to_s}", locals, &block
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