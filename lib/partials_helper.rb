module PartialsHelper
	def shared partial_name, locals = {}, &block
    render_with_block "layouts/partials/shared/#{partial_name.to_s}", locals, &block
  end

  def modules(partial_name, locals = {}, &block) 
    render_with_block "layouts/partials/modules/#{partial_name.to_s}", locals, &block
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
end