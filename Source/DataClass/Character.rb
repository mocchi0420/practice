require_relative "./Record.rb"
class Character < Record
	def initialize(my_hash={}, type_list={})
		my_hash.each do |data|
			super(my_hash, type_list)
		end
	end
end