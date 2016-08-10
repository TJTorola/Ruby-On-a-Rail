class AssocOptions
	attr_accessor(
		:foreign_key,
		:class_name,
		:primary_key,
		:assoc_options
	)

	def model_class
		Object.const_get(@class_name)
	end

	def table_name
		model_class.table_name
	end
end

class BelongsToOptions < AssocOptions
	def initialize(name, options = {})
		@name = name.to_s
		@foreign_key = options[:foreign_key]
		@class_name = options[:class_name]
		@primary_key = options[:primary_key]

		@primary_key ||= :id
		@foreign_key ||= "#{name.to_s.underscore}_id".to_sym
		@class_name ||= name.to_s.camelcase
	end
end

class HasManyOptions < AssocOptions
	def initialize(name, self_class_name, options = {})
		@name = name.to_s
		@self_class_name = self_class_name
		@foreign_key = options[:foreign_key]
		@class_name = options[:class_name]
		@primary_key = options[:primary_key]

		@primary_key ||= :id
		@foreign_key ||= "#{self_class_name.underscore}_id".to_sym
		@class_name ||= name.to_s.camelcase.singularize
	end
end