class Movie < ActiveRecord::Base
	def self.allRatings
		['G','PG','PG-13','R']
	end
end
