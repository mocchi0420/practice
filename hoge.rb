module BowlingConstants
	GAME_FRAME = 9
	PIN_NUM = 10
end

class BowlingGame
	include BowlingConstants
	def initialize
		@result = []
		@current_result = []
		@frame = 0
	end

	def roll(pins)
		my_roll = BowlingRollManager.new(@frame)
		@current_result << my_roll.roll(pins, @current_result)
		return modify_result(get_roll_count)
	end

	def get_roll_count
		ret = (@frame == GAME_FRAME) ? 3 : 2 #最終フレームまでは2投,最終フレームは3投
		return ret
	end

	def modify_result(roll_count)
		if @frame == GAME_FRAME
			@current_result << 0 if @current_result.inject(:+) < 10 && @current_result.length == 2
		else
			@current_result << 0 if @current_result == [PIN_NUM]
		end
		
		if @current_result.length == roll_count
			@result << @current_result
			@current_result = []
			@frame += 1
		end
		return @result
	end
	
	def get_score_list
		my_score = BowlingScoreManager.new(@frame, @result)
		return my_score.score
	end
	
	def score
		my_score = get_score_list
		ret = (my_score.select{|e| e != nil} == []) ? 0 : my_score.select{|e| e != nil}.inject(:+)
		return ret
	end
end

class BowlingRollManager
	include BowlingConstants

	def initialize(frame)
		@frame = frame
	end
	
	def roll(pins, result)
		begin
			raise if @frame > GAME_FRAME
			mode = (@frame == GAME_FRAME) ? "lastframe" : "normalframe"
			return send("roll_check_#{mode}", pins, result)
		rescue
			mes = (@frame > GAME_FRAME) ? "game ended!" : "invalid index!"
			raise IndexError.new(mes)
		end
	end

	def roll_check_normalframe(pins, result)
		raise IndexError.new("invalid index!") if pins.to_s !~ /\A[0-9]+\z/ || pins > PIN_NUM
		raise IndexError.new("invalid index!") if (result.length >= 1) && result.inject(:+) + pins > PIN_NUM
		return pins
	end

	def roll_check_lastframe(pins, result)
		raise IndexError.new("invalid index!") if pins.to_s !~ /\A[0-9]+\z/ || pins > PIN_NUM
		case result.length
			when 0 then raise IndexError.new("invalid index!") if pins > 10
			when 1 then raise IndexError.new("invalid index!") if (result[0] == 10 && pins > PIN_NUM) || (result[0] != 10 && result[0] + pins > PIN_NUM)
			when 2 then raise IndexError.new("invalid index!") if (result[0..1].inject(:+) == 20 && pins > PIN_NUM) || (result[0] == 10 && result[1] != 10 && result[1] + pins > PIN_NUM)
		end
		return pins
	end
	
end

class BowlingScoreManager
	include BowlingConstants

	def initialize(frame, result)
		@frame = frame
		@result = result
		@score = []
		@strike_count = 0
	end

	def score
		return [] if @frame == 0
		(@frame-1).downto(0) do |current_frame|
			if current_frame == GAME_FRAME #最終フレームは足し算だけ
				@score.unshift(@result[current_frame]).flatten!
				next
			end
			if @result[current_frame] == [PIN_NUM,0]
				@score.unshift(calc_strike_score(current_frame))
				@strike_count += 1 if @strike_count < 2
			else
				mode = (@result[current_frame].inject(:+) == PIN_NUM) ? :spare : :normal
				@score.unshift(send("calc_#{mode}_score", current_frame))
				@strike_count = 0
			end
		end
		return @score
	end
	
	def calc_normal_score(frame)
		return @result[frame].inject(:+)
	end
	
	def calc_spare_score(frame)
		ret = (@frame != frame) ? @result[frame+1][0] + @result[frame].inject(:+) : 0
		return ret
	end

	def calc_strike_score(frame)
		case @strike_count 
			when 0 then return (@result[frame+1][0..1].inject(:+) + @result[frame].inject(:+)) if (@frame - frame > 1)
			when 1 then return (@result[frame+2][0] + @result[frame..(frame+1)].flatten!.inject(:+)) if (@frame - frame > 2)
			when 2 then return PIN_NUM*3 if (@frame - frame > 2)
		end
		return nil
	end
	
end