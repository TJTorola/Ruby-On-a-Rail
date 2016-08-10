require_relative './associatable_options'

module Associatable
	def belongs_to(name, options = {})
		options = BelongsToOptions.new(name, options)
		assoc_options[name] = options

		define_method name do
			model = options.model_class
			key = options.primary_key.to_s
			val = attributes[options.foreign_key]

			model.where({ key => val }).first
		end
	end

	def has_many(name, options = {})
		options = HasManyOptions.new(name, self.name, options)

		define_method name do
			model = options.model_class
			key = options.foreign_key.to_s
			val = attributes[options.primary_key]

			model.where({ key => val })
		end
	end

	def has_one_through(name, through_name, source_name)
		define_method name do
			through_options = self.class.assoc_options[through_name]

			model = through_options.model_class
			key = through_options.primary_key.to_s
			val = attributes[through_options.foreign_key]

			model = model.where({ key => val }).first
			model.send(source_name)
		end
	end

	def assoc_options
		@assoc_options ||= {}
	end
end
