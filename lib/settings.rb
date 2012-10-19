require "settingslogic"

class Settings < Settingslogic
  def self.init environment
    path = "#{File.dirname(__FILE__)}/../config/"
    path = if File.exists?(path+"#{environment}.yml")
      path+"#{environment}.yml"
    else
      STDOUT.puts "== File config/#{environment}.yml not found, using config/default.yml instead"
      path+"default.yml"
    end
    source path
    namespace "config"
  end
  
end