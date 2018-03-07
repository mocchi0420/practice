module DataTableFactory
	require 'csv'
	Dir[File.expand_path('../../Source/DataClass/', __FILE__) << '/*.rb'].each do |file|
		require_relative file
	end
	def self.create(input_csv)
		ret = {}
		csv = CSV.table(input_csv)
		tag = File.basename(input_csv,".*").capitalize
		type_list = {}
		
		begin
			my_class = eval "#{tag}"
			csv.each_with_index do |data, i|
				if i == 0
					type_list = data.to_h.inject( {} ){ |a,(k,v)| a[k]=v;a }
				else
					tmp = data.to_h
					ret.store(tmp[:id], my_class.new(tmp, type_list))
				end
			end
		rescue => e
			puts e
		end
		return ret
	end
	
	def self.dump(file_name, output_path)
		tmp = self.create(file_name)
		file = File.open(output_path+"/#{File.basename(file_name,".*").capitalize}", "w+")
		Marshal.dump(tmp, file)
		file.rewind
	end
	
	def self.load(file_name)
		return Marshal.load(File.open(file_name))
	end
end