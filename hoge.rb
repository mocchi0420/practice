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
			if current_frame == GAME_FRAME #最終フレームは足し算だけ
				@score.unshift(@result[current_frame]).flatten!
				next
			end
			if @result[current_frame] == [PIN_NUM,0]
				mode = :strike
			else
				mode = :normal
				mode = :spare if @result[current_frame].inject(:+) == PIN_NUM
			end
			@score.unshift(send("calc_#{mode}_score", current_frame))
			if @result[current_frame] == [PIN_NUM,0]
				@strike_count += 1 if @strike_count < 2
			else
				@strike_count = 0
			end
		end
		return @score.select{|e| e != nil}.inject(:+)
	end
	
	def calc_normal_score(frame)
		return @result[frame].inject(:+)
	end
	
	def calc_spare_score(frame)
		if @frame != frame
			return @result[frame+1][0] + @result[frame].inject(:+)
		else
			return nil
		end
	end

	def calc_strike_score(frame)
		ret = nil
		ret = case @strike_count 
			when 0 then (@result[frame+1][0..1].inject(:+) + @result[frame].inject(:+)) if (@frame - frame > 1)
			when 1 then (@result[frame+2][0] + @result[frame..(frame+1)].flatten!.inject(:+)) if (@frame - frame > 2)
			when 2 then PIN_NUM*3 if (@frame - frame > 2)
		end
		return ret
	end
end