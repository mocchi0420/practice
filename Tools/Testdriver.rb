# encoding: utf-8
require 'dxruby'

class Testdriver
	def self.mainloop( &block )
		ret = nil
		Window.loop do
			ret = block.call(Window)
			Window.close if Input.mouse_release?(M_LBUTTON)
		end
		return ret
	end
end
