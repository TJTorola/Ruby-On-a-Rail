require_relative './sql_object'

class RailModel < SQLObject
	self.table_name = self.class.to_s.underscore.pluralize

	def initialize(params = {})
		self.class.finalize!
		super(params)
	end
end