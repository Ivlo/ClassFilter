module Sass::Script::Functions
    def timestamp()
        return Sass::Script::String.new(Time.now.to_i)
    end
end