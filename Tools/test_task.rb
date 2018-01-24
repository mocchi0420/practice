require "./DataTableFactory.rb"

MYGAME_PATH = File.expand_path("..")
MASTER_PATH = MYGAME_PATH+"/Data/Master"
OUTPUT_PATH = MYGAME_PATH+"/Data/output"

Dir.glob(MASTER_PATH+"/**/*.*").each do |file_name|
	DataTableFactory.dump(file_name, OUTPUT_PATH)
end

Dir.glob(OUTPUT_PATH+"/*").each do |file_name|
	p DataTableFactory.load(file_name)
end


while true
end