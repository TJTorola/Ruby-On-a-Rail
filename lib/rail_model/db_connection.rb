require 'sqlite3'

class DBConnection
	def self.open
		@db = SQLite3::Database.new(DATABASE[:file])
		@db.results_as_hash = true
		@db.type_translation = true

		@db
	end

	def self.reset
		commands = [
			"rm '#{DATABASE[:file]}'",
			"cat '#{DATABASE[:sql]}' | sqlite3 '#{DATABASE[:file]}'"
		]

		commands.each { |command| `#{command}` }
		DBConnection.open
	end

	def self.instance
		reset if @db.nil?
		@db
	end

	def self.execute(*args)
		print_query(*args)
		instance.execute(*args)
	end

	def self.execute2(*args)
		print_query(*args)
		instance.execute2(*args)
	end

	def self.last_insert_row_id
		instance.last_insert_row_id
	end

	private

	def self.print_query(query, *interpolation_args)
		return unless PRINT_QUERIES

		puts '--------------------'
		puts query
		unless interpolation_args.empty?
			puts "interpolate: #{interpolation_args.inspect}"
		end
		puts '--------------------'
	end
end