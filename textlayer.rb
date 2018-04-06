# encoding: utf-8
require 'dxruby'

class ScriptController
	DEFAULT_CAPTION_WAIT = 2
	def initialize(config={})
		@script = nil
		@config = config
		@caption_wait = (@config[:caption_wait]==nil) ? DEFAULT_CAPTION_WAIT : @config[:caption_wait]
		@status = :draw
		@skip_flag = false
	end
	
	def on_draw(pos_x, pos_y, window)
		@script.set_window(pos_x, pos_y, window)
	end
	
	def set_script(script)
		@script = script
	end
	
	def on_move
		begin
			send(@status) if self.methods.index(@status) != nil
		end while @skip_flag == true && @status != :end
		return true
	end
	
	def draw
		raise if @script == nil
		unless @script.text_end?
			@script.draw
			self.check_skip	#スキップモードの場合の処理
		else
			@status = :end
		end
	end
	
	def check_skip
		@status = (@skip_flag == true) ? :draw : :wait
	end

	def wait
		if @skip_flag == true
			@status = :draw
			return true
		end
		
		if @caption_wait <= 0 then
			@caption_wait = (@config[:caption_wait]==nil) ? DEFAULT_CAPTION_WAIT : @config[:caption_wait]
			@status = :draw
		else
			@caption_wait -= 1
		end
	end

	def get_status
		return @status
	end
	
	def line_feed
		@script.line_feed
	end
	
	def set_skip_mode(bool)
		@skip_flag = bool
	end

end




class TextBox
	require 'dxruby'
	attr_reader :image
	
	def initialize(image, option={})
		@image = image
		@font = nil
		@text = nil
		@pos = {x: 0, y: 0}
		@option = option
	end

	def set_text(text)
		@text = text
	end

	def set_font(font)
		@font = font
	end
	
	def set_position(pos)
		@pos = pos
	end
	
	def set_window(pos_x, pos_y, window)
		window.draw(pos_x, pos_y,@image)
	end

	def dispose
		@image.dispose
	end
	
	def clear
		@image.clear
	end

	def draw
		return false if @text == nil || @font == nil
		@image.draw_font_ex(@pos[:x], @pos[:y], @text , @font, @option)
	end
end


class MonoScript < TextBox
	def initialize(image, option={})
		super
		@text_counter = 0
		@pos_diff = {x: 0, y: 0}
	end
	
	def reset_script
		@text_counter = 0
		@pos_diff = {x: 0, y: 0}
	end
	
	def draw
		return false if @text == nil || @font == nil
		str = @text[@text_counter, 1]
		@image.draw_font_ex(@pos[:x], @pos[:y], str , @font, @option)
		@text_counter += 1
		@pos_diff[:x] = (str.bytesize >= 2) ? @font.size : @font.size/2
		@pos_diff[:y] = @font.size
		@pos[:x] += @pos_diff[:x]
	end

	def text_end?
		ret = (@text.length > @text_counter) ? false : true
		return ret
	end

	def line_feed
		@pos[:x] = 0
		line_space = (@config[:line_space_size] == nil) ? 0 : @config[:line_space_size]
		@pos[:y] +=  @pos_diff[:y] + line_space
	end
end




