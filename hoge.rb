class Game
	def initialize
		@result = Array.new(9).map{Array.new(2,0)}
		@result << [0,0,0]
		
		@score = []
		@frame = 0
		@throwing_num = 0
	end

	def roll(pins)
		return false if pins.to_s !~ /\A[0-9]+\z/ || pins > 10
		if @frame < 9
			return false if (@result[@frame].inject(:+) + pins) > 10
			flag = (@result[@frame].inject(:+) + pins == 10) ? true : false
			self.calc_result(pins, flag)
		elsif @frame == 9
			return false if @result[@frame].select{|e| e > 10} != []
			case @throwing_num
				when 0 then flag = (pins == 10) ? true : false
				when 1 then flag = (@result[@frame][0] + pins == 10 || pins == 10) ? true : false
				when 2 then flag = ( (@result[@frame][0] == 10 && @result[@frame][1] + pins == 10) || pins == 10) ? true : false
				else flag = false
			end
			self.calc_result(pins, flag)
		end
		return true
	end

	def calc_result(pins, ten_pins=false)
		return calc_result_lastround(pins, ten_pins) if @frame >= 9
		@result[@frame][@throwing_num] += pins
		if ten_pins == true
			tmp = (@throwing_num == 0) ? "STRIKE" : "SPARE"
			@score << tmp
			@frame += 1
			@throwing_num = 0
			return true
		end
		if @throwing_num >= 1
			@score << @result[@frame].inject(:+)
			@frame += 1
			@throwing_num = 0
			return true
		end
		@throwing_num += 1
		return true
	end
	
	def calc_result_lastround(pins, ten_pins=false)
		return false if @frame > 9
		@result[@frame][@throwing_num] += pins
		case @throwing_num
			when 0,2
				@score << "STRIKE" if pins == 10 && ten_pins == true
				@throwing_num += 1
			when 1
				if ten_pins == true
					if pins == 10
						@score << "STRIKE" 
					else
						@score << "SPARE"
					end
					@throwing_num += 1
				else
					@throwing_num += 2
				end
			else
				return true
		end
		return true
	end
	
	def score
		return 0 if @score == []
		@score.each_with_index do |item, index|
			if index > (@score.length - 2) - 1
				@score[index] = 0
			else
				@score[index] = calc_point(index, item) if item == "STRIKE" || item == "SPARE"
			end
		end
		return @score.inject(:+)
	end
	
	def calc_point(index, item)
		if item == "STRIKE" then
			if @score[index+1] != "STRIKE"
				return @result[index].inject(:+) + @result[index+1].inject(:+)
			elsif @score[index+1] == "STRIKE" && @score[index+2] != "STRIKE"
				return @result[index].inject(:+) + @result[index+1].inject(:+) + @result[index+2][0]
			elsif @score[index+1] == "STRIKE" && @score[index+2] == "STRIKE"
				return 30
			end
		elsif item == "SPARE" then
			return @result[index].inject(:+) + @result[index+1][0]
		end
	
	end
	
	def reset
		@result = Array.new(9).map{Array.new(2,0)}
		@result << [0,0,0]
		@score = []
		@frame = 0
		@throwing_num = 0
	end
end