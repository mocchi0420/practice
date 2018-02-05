class Game
	GAME_FRAME = 9
	PIN_NUM = 10
	def initialize
		@result = Array.new(GAME_FRAME).map{Array.new(2,0)}
		@result << [0,0,0]
		@strike_sheet = Array.new(10,nil)
		@score = []
		(GAME_FRAME+1).times do
			@score << {point: 0, calculated: false}
		end
		
		@frame = 0
		@throwing_num = 0
	end

	def roll(pins)
		return false if pins.to_s !~ /\A[0-9]+\z/ || pins > PIN_NUM
		case @frame
			when 0..(GAME_FRAME-1) then return self.roll_at_normalframe(pins)
			when GAME_FRAME then return self.roll_at_lastframe(pins)
			else return false
		end
		return true
	end
	
	def roll_at_normalframe(pins)
		return false if (@result[@frame].inject(:+) + pins) > PIN_NUM
		flag = (@result[@frame].inject(:+) + pins == PIN_NUM) ? true : false
		self.calc_result(pins, flag)
		return true
	end
	
	def roll_at_lastframe(pins)
		return false if @result[@frame].select{|e| e > PIN_NUM} != []
		case @throwing_num
			when 0 then flag = (pins == PIN_NUM) ? true : false
			when 1 then flag = (@result[@frame][0] + pins == PIN_NUM || pins == PIN_NUM) ? true : false
			when 2 then flag = ( (@result[@frame][0] == PIN_NUM && @result[@frame][1] + pins == PIN_NUM) || pins == PIN_NUM) ? true : false
			else flag = false
		end
		self.calc_result(pins, flag)
		return true
	end

	def calc_result(pins, ten_pins=false)
		case @frame
			when 0..(GAME_FRAME-1) then return self.calc_result_normalframe(pins, ten_pins)
			when GAME_FRAME then return self.calc_result_lastframe(pins, ten_pins)
			else return false
		end
	end
	
	def calc_result_normalframe(pins, ten_pins=false)
		@result[@frame][@throwing_num] += pins
		if ten_pins == true
			@strike_sheet[@frame] = (@throwing_num == 0) ? "STRIKE" : "SPARE"
			@frame += 1
			@throwing_num = 0
			return true
		end
		if @throwing_num >= 1
			@score[@frame][:point] = @result[@frame].inject(:+)
			@score[@frame][:calculated] = true
			@frame += 1
			@throwing_num = 0
			return true
		end
		@throwing_num += 1
		return true
	end

	def calc_result_lastframe(pins, ten_pins=false)
		return false if @frame > GAME_FRAME
		@result[@frame][@throwing_num] += pins
		case @throwing_num
			when 0,2
				@strike_sheet[@frame] = "STRIKE" if pins == PIN_NUM && ten_pins == true
				@throwing_num += 1
			when 1
				if ten_pins == true
					@strike_sheet[@frame] = (pins == PIN_NUM) ? "STRIKE" : "SPARE"
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
		tmp = 0
		@score.each_with_index do |item, index|
			calc_point(index, item) if item[:calculated] != true
			tmp += @score[index][:point] if item[:calculated] == true
		end
		return tmp
	end
	
	def calc_point(index, item)
		case index
			when 0..7
				if @strike_sheet[index] == "STRIKE" then
					if @strike_sheet[index+1] != "STRIKE"
						@score[index][:point] = @result[index].inject(:+) + @result[index+1].inject(:+)
						@score[index][:calculated] = true
					elsif @strike_sheet[index+1] == "STRIKE" && @strike_sheet[index+2] != "STRIKE"
						@score[index][:point] = @result[index].inject(:+) + @result[index+1].inject(:+) + @result[index+2][0]
						@score[index][:calculated] = true
					elsif @strike_sheet[index+1] == "STRIKE" && @strike_sheet[index+2] == "STRIKE"
						@score[index][:point] = 30
						@score[index][:calculated] = true
					end
				elsif @strike_sheet[index] == "SPARE" then
					@score[index][:point] = @result[index].inject(:+) + @result[index+1][0]
					@score[index][:calculated] = true
				end
			when 8
				if @strike_sheet[index] == "STRIKE" then
					if @strike_sheet[index+1] != "STRIKE"
						@score[index][:point] = @result[index].inject(:+) + @result[index+1].inject(:+)
						@score[index][:calculated] = true
					elsif @strike_sheet[index+1] == "STRIKE"
						@score[index][:point] = @result[index].inject(:+) + @result[index+1].inject(:+)
						@score[index][:calculated] = true
					elsif @strike_sheet[index+1] == "STRIKE" && @strike_sheet[index+2] == "STRIKE"
						@score[index][:point] = 30
						@score[index][:calculated] = true
					end
				elsif @strike_sheet[index] == "SPARE" then
					@score[index][:point] = @result[index].inject(:+) + @result[index+1][0]
					@score[index][:calculated] = true
				end
			when 9
			
		end
	
	
	
	
	
	
	
	
	
		#return 0 if @frame == index+1
		if index < GAME_FRAME
			if @strike_sheet[index] == "STRIKE" || index == GAME_FRAME-1 then
				if @strike_sheet[index+1] != "STRIKE"
					@score[index][:point] = @result[index].inject(:+) + @result[index+1].inject(:+)
					@score[index][:calculated] = true
				elsif @strike_sheet[index+1] == "STRIKE" && @strike_sheet[index+2] != "STRIKE" && index < GAME_FRAME-1
					@score[index][:point] = @result[index].inject(:+) + @result[index+1].inject(:+) + @result[index+2][0]
					@score[index][:calculated] = true
				elsif @strike_sheet[index+1] == "STRIKE" && @strike_sheet[index+2] == "STRIKE" && index < GAME_FRAME-1
					@score[index][:point] = 30
					@score[index][:calculated] = true
				end
			elsif @strike_sheet[index] == "SPARE" then
				@score[index][:point] = @result[index].inject(:+) + @result[index+1][0]
				@score[index][:calculated] = true
			end
		elsif index == GAME_FRAME
			@score[index][:point] = @result.last.inject(:+)
			@score[index][:calculated] = true
		else

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