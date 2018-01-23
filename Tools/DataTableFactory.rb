module DataTableFactory
	require 'csv'
	def self.create(input_csv)
		ret = []
		csv = CSV.table(input_csv)
		csv.each do |data|
			ret << data.to_h
		end
		return ret
	end
	
	def self.dump(file_name, output_path)
		tmp = self.create(file_name)
		file = File.open(output_path+"/#{File.basename(file_name,".*")}", "w+")
		Marshal.dump(tmp, file)
		file.rewind
	end
	
	def self.load(file_name)
		return Marshal.load(File.open(file_name))
	end
end