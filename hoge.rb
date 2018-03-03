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
			return false if (@current_result.length >= 1) && @current_result.inject(:+) + pins > PIN_NUM
		else
			return false if (@current_result.length >= 1) && (@current_result[0] + pins > PIN_NUM*2)
			return false if (@current_result.length >= 2) && (@current_result[0] + @current_result[1] + pins > PIN_NUM*3)
		end
		return true
	end

	def roll(pins)
		return false if roll_check(pins) == false

		@current_result << pins
		
		if @frame < GAME_FRAME
			@current_result << 0 if @current_result == [PIN_NUM]
			roll_num = 2	#最終フレームまでは2投
		else
			@current_result << 0 if @current_result.inject(:+) < 10 && @current_result.length == 2
			roll_num = 3	#最終フレームは3投
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
		(@frame-1).downto(0) do |current_frame|
			if current_frame == GAME_FRAME
				@score.unshift(@result[current_frame]).flatten!
				next
			end
			
			ret = 0			
			if @result[current_frame] == [PIN_NUM,0]
				case @strike_count
					when 0 then ret = (@frame - current_frame > 1) ? (@result[current_frame+1][0..1].inject(:+) + @result[current_frame].inject(:+)) : nil
					when 1 then ret = (@frame - current_frame > 2) ? (@result[current_frame+2][0] + @result[current_frame..(current_frame+1)].flatten!.inject(:+)) : nil
					when 2 then ret = (@frame - current_frame > 2) ? PIN_NUM*3 : nil
				end
				@strike_count += 1 if @strike_count < 2
			elsif @result[current_frame].inject(:+) == PIN_NUM
				 ret = (@frame != current_frame) ? (@result[current_frame+1][0]+@result[current_frame].inject(:+)) : nil
			else
				 ret = @result[current_frame].inject(:+)
			end
			@strike_count = 0 if @result[current_frame] != [PIN_NUM,0]
			@score.unshift(ret)
		end
		return @score.select{|e| e != nil}.inject(:+)
	end

end