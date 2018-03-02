class Game
	GAME_FRAME = 9
	PIN_NUM = 10
	def initialize
		@result = []
		@current_result = []
		@score = []
		@frame = 0
		@strike_count = 0
	end

	def roll_check(pins)
		return false if @frame > GAME_FRAME
		return false if pins.to_s !~ /\A[0-9]+\z/ || pins > PIN_NUM
		
		if @frame < GAME_FRAME
			return false if (@current_result.length >= 1) && @current_result.inject(:+) + pins > 10
		else
			return false if (@current_result.length >= 1) && (@current_result[0] + pins > 20)
			return false if (@current_result.length >= 2) && (@current_result[0] + @current_result[1] + pins > 30)
		end
		return true
	end

	def roll(pins)
		return false if roll_check(pins) == false

		@current_result << pins
		
		if @frame < GAME_FRAME
			@current_result << 0 if @current_result == [10]
			roll_num = 2
		else
			@current_result << 0 if @current_result.inject(:+) < 10 && @current_result.length == 2
			roll_num = 3
		end
		
		if @current_result.length == roll_num
			@result << @current_result
			@current_result = []
			@frame += 1
		end
		
		return true
	end
	
	def score
		return 0 if @frame == 0
		(@frame-1).downto(0) do |idx|
			if idx == 9
				@score.unshift(@result[idx]).flatten!
				next
			end
			
			ret = 0			
			if @result[idx] == [10,0]
				case @strike_count
					when 0 then ret = (@frame - idx > 1) ? (@result[idx+1][0..1].inject(:+) + @result[idx].inject(:+)) : nil
					when 1 then ret = (@frame - idx > 2) ? (@result[idx+2][0] + @result[idx..(idx+1)].flatten!.inject(:+)) : nil
					when 2 then ret = (@frame - idx > 2) ? 30 : nil
				end
				@strike_count += 1 if @strike_count < 2
			elsif @result[idx].inject(:+) == 10
				 ret = (@frame != idx) ? (@result[idx+1][0]+@result[idx].inject(:+)) : nil
			else
				 ret = @result[idx].inject(:+)
			end
			@strike_count = 0 if @result[idx] != [10,0]
			@score.unshift(ret)
		end
		return @score.select{|e| e != nil}.inject(:+)
	end

end