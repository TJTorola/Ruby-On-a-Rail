require 'active_support/inflector'

require_relative './searchable'
require_relative './associatable'

class SQLObject
	extend Searchable
	extend Associatable

	def self.finalize!
		columns.each do |column|
			define_method "#{column}=" do |val|
				attributes[column.to_sym] = val
			end

			define_method "#{column}" do
				attributes[column.to_sym]
			end
		end
	end

	def initialize(params = {})
		params.each do |param, val|
			err = "Unknown Attribute '#{param}'"
			raise err unless columns.include? param
			set_param(param, val)
		end
	end

	def self.all
		parse_all(
			DBConnection.execute(<<-SQL)
				SELECT *
				FROM #{table_name}
			SQL
		)
	end

	def self.find(id)
		parse_all(
			DBConnection.execute(<<-SQL, id)
				SELECT *
				FROM #{table_name}
				WHERE id = ?
				LIMIT 1
			SQL
		).first
	end

	def save
		if id.nil?
			insert
		else
			update
		end
	end

	private

	def self.columns
		@columns ||= DBConnection.execute2(<<-SQL)
			SELECT *
			FROM #{table_name}
			LIMIT 1
		SQL
			.first.map { |field| field.to_sym }
	end

	def self.table_name=(table_name)
		@table_name = table_name
	end

	def self.table_name
		@table_name ||= name.tableize
	end

	def self.parse_all(results)
		results.map do |result|
			result.keys.each do |key|
				result[key.to_sym] = result[key]
				result.delete(key)
			end
			self.new(result)
		end
	end

	def table_name
		self.class.table_name
	end

	def columns
		self.class.columns
	end

	def set_param(param, val)
		param = (param.to_s + "=").to_sym
		send param, val
	end

	def attributes
		@attributes ||= {}
	end

	def attribute_values
		attributes.values
	end

	def attribute_key_string
		attributes.keys.join(', ')
	end

	def q_string
		q_string = ['?'] * attribute_values.length
		q_string.join(', ')
	end

	def insert
		DBConnection.execute(<<-SQL, *attribute_values)
			INSERT INTO
				#{table_name} (#{attribute_key_string})
			VALUES
				(#{q_string})
		SQL

		self.id = DBConnection.last_insert_row_id
	end

	def set_values
		sets = []
		attributes.each { |k, v| sets << "#{k} = ?" if k != :id }
		sets.join(', ')
	end

	def update
		DBConnection.execute(<<-SQL, *attribute_values.drop(1))
			UPDATE
				#{table_name}
			SET
				#{set_values}
			WHERE
				id = #{self.id}
		SQL
	end
end
