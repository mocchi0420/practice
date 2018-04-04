# encoding: utf-8


class MonoScript
	require 'dxruby'

	def initialize(textbox, config={wait_counter_preset: 5, status: :draw, skip_flag: false})
		@textbox = textbox
		@config = config
		@wait_counter = @config[:wait_counter_preset]
	end
	
	def on_draw(pos_x, pos_y, window)
		window.draw(pos_x, pos_y, @textbox.image)
	end
	
	def on_move
		begin
			send(@config[:status]) if self.methods.index(@config[:status]) != nil
		end while @config[:skip_flag] == true && @config[:status] != :end
		return true
	end
	
	def draw
		unless @textbox.text_end?
			@textbox.draw_forscript
			self.check_skip	#スキップモードの場合の処理
		else
			@config[:status] = :end
		end
	end
	
	def check_skip
		@config[:status] = (@config[:skip_flag] == true) ? :draw : :wait
	end

	def wait
		if @config[:skip_flag] == true
			@config[:status] = :draw
			return true
		end
		
		if @wait_counter <= 0 then
			@wait_counter = @config[:wait_counter_preset]
			@config[:status] = :draw
		else
			@wait_counter -= 1
		end
	end

	def get_status
		return @config[:status]
	end
	
	def line_feed
		@textbox.line_feed
	end
	
	def set_skip_mode(bool)
		@config[:skip_flag] = bool
	end

end




class TextBox
	def initialize(text, config=nil)
		@config = self.set_config(config)
		@text = text
		@text_counter = 0
		@str_size = {x: 0, y: 0}
		
		@font = Font.new(@config[:font_size], @config[:font_name])
		
	end
	
	def set_config(config)
		ret = {
			font_color: [255, 255, 255],
			font_name: "ＭＳ ゴシック",
			font_size: 24,
			pos: {x: 0,y: 0},
			line_space_size: 0
		}
		config.each{|key| ret[:key] = config[:key] if config[:key] != nil} if config != nil && config.class == Hash
		return ret
	end

	def draw(image)
		str = @text[@text_counter, 1]
		image.draw_font_ex(@config[:pos][:x], @config[:pos][:y], str , @font)
		@text_counter += 1
		@str_size[:x] = (str.bytesize >= 2) ? @font.size : @font.size/2
		@str_size[:y] = @font.size
		@config[:pos][:x] += @str_size[:x]
		return true
	end

	def text_end? 
		ret = (@text.length > @text_counter) ? true : false
		return ret
	end

	def line_feed
		@config[:pos][:x] = 0
		@config[:pos][:y] += @str_size[:y] + @config[:line_space_size]
	end

end




class TextBoxProto
	def initialize(window, image, option={})
		@image = image
		window.draw(0, 0, @image)
		@font = nil
		@text = nil
		@pos = {x: 0, y: 0}
		@option = option
	end

	def set_text(text, font)
		@text = text
		@font = font
	end

	def draw
		return false if @text == nil || @font == nil
		@image.draw_font_ex(@pos[:x], @pos[:y], @text , @font, @option)
		return true
	end
	
	def dispose
		@image.dispose
	end
end


class TextBoxProto2
	require 'dxruby'
	attr_reader :image
	
	def initialize(image, option={})
		@image = image
		@font = nil
		@text = nil
		@pos = {x: 0, y: 0}
		
		@text_counter = 0
		@pos_diff = {x: 0, y: 0}
		
		@option = option
	end

	def set_text(text, font)
		@text = text
		@font = font
		@text_counter = 0
		@pos_diff = {x: 0, y: 0}
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
		return true
	end
	
	#以下、monoscriptで呼ばれる場合の形式
	def draw_forscript
		return false if @text == nil || @font == nil
		str = @text[@text_counter, 1]
		@image.draw_font_ex(@pos[:x], @pos[:y], str , @font)
		@text_counter += 1
		puts @text_counter
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



