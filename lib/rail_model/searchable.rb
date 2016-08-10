module Searchable
	def where(params)
		parse_all(
			DBConnection.execute(<<-SQL, *params.values)
				SELECT *
				FROM #{table_name}
				WHERE #{wheres(params)}
			SQL
		)
	end

	def wheres(params)
		wheres = []
		params.each { |k, v| wheres << "#{k} = ?" if k != :id }
		wheres.join(' AND ')
	end
end

class SQLObject
	extend Searchable
end
