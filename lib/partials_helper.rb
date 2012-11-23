module PartialsHelper
	def shared partial_name, locals = {}
    partial "layouts/partials/shared/#{partial_name.to_s}", :locals=>locals
  end

  def modules partial_name, locals = {}
    partial "layouts/partials/modules/#{partial_name.to_s}", :locals=>locals
  end
end