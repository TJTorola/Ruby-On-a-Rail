require_relative './rail'

require_relative '../config/rail'
require_relative '../config/database'

require_relative './controller_base/controller_base'
require_relative './router/router'
require_relative './rail_model/rail_model'

require_relative './middleware/exceptions.rb'
require_relative './middleware/static.rb'

app_dir = File.dirname(__FILE__)
app_dir += "/../app/"

Dir["#{app_dir}*/*.rb"].each do |file|
	require file
end

require_relative '../config/routes'