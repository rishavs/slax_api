require "./slax_api/*"
require "kemal"

module SlaxApi
	get "/" do
	  "Hello World!"
	end

	Kemal.run
end
