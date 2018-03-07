class Record
	def initialize(my_hash={}, type_list={})
		my_hash.each do |data|
			#dataは必ず[:key, value]で渡される
			var = "@"+data[0].to_s	
			eval("#{var}=data[1]")
		end
	end
	
	def get_param(symbol)
		self.instance_variable_get("@"+symbol.to_s)
	end
end