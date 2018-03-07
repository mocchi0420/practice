module Validator
	CHECK_ELEMENT = %w[ none fire water tree light dark ]
	def self.validate_master_data(data)
		return false
	end
end

module Converter
	require 'json'
	include Validator

	def self.covert_master_data(data, type)
		ret = case type
			when "Interger" then data.to_i
			when "String" then data.to_s
			when "Interger[]" then data.delete("[").delete("]").split(",").map{|d| d.to_i}
			when "String[]" then data.delete("[").delete("]").split(",").map{|d| d.to_s}
			when "json" then JSON.parse(data)
			else data
		end
		
		#raise unless Validator.validate_master_data(ret)
		return ret
	end
end

class Record
	include Converter
	def initialize(my_hash={}, type_list={})
		my_hash.each do |data|	#dataは必ず[:key, value]で渡される
			begin
				ret = Converter.covert_master_data(data[1], type_list[data[0]])
				eval("#{"@"+data[0].to_s}=ret")
			rescue => e
				puts "コンバートできません #{data}"
				puts e
        		raise
      	end
		end
	end
	
	def get_param(symbol)
		self.instance_variable_get("@"+symbol.to_s)
	end
end