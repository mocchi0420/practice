class Game
	GAME_FRAME = 9
	PIN_NUM = 10
	def initialize
		@result = []
		@current_result = []
		@score = []
		@frame = 0
	end

	def roll(pins)
		return false if @frame > GAME_FRAME
		return false if pins.to_s !~ /\A[0-9]+\z/ || pins > PIN_NUM
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
	
	def get_score
		return 0 if @frame == 0
		(@frame-1).downto(0) do |idx|
			@score.unshift(@result[idx]).flatten! if idx == 9
			@score.unshift(@result[idx].inject(:+)) if idx != 9
		end
		return @score.inject(:+)
	end

end