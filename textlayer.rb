# encoding: utf-8

class TextBoxManager
	require 'dxruby'

	def initialize(text, config=nil)
		@text = TextBox.new(text, config)
		@config = self.set_config(config)
		@wait_counter = @config[:wait_counter_preset]
	end
	
	def set_config(config)
		ret = {
			status: :draw,
			skip_flag: false,
			wait_counter_preset: 5,
			image: (Image.new(640, 480, [0, 0, 0, 0]))
		}
		config.each{|key| ret[:key] = config[:key] if config[:key] != nil} if config != nil && config.class == Hash
		return ret
	end
	
	def on_draw(window)
		window.draw(0, 0, @config[:image])
	end
	
	def on_move
		begin
			send(@config[:status]) if self.methods.index(@config[:status]) != nil
		end while @config[:skip_flag] == true && @config[:status] != :end
		return true
	end
	
	def draw
		if @text.text_end?
			@text.draw(@config[:image])
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
		@text.line_feed
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



