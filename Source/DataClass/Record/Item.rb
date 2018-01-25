require_relative "./Record.rb"
class Item < Record
	def initialize(my_hash={})
		my_hash.each do |data|
			super(my_hash)
		end
	end
end