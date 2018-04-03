# encoding: utf-8
require_relative '../textlayer'
require_relative '../Tools/Testdriver'

describe "TextBox" do
	# 初期設定
	let(:textdrawer) {TextBoxManager.new("abcdefghijklmnopqrstuvwxyz")}
	
	describe "draw animator" do
		it "we can draw some str" do
			expect(Testdriver.mainloop do |window|
				textdrawer.on_draw(window)
				textdrawer.on_move
			end).to be_truthy
		end
		
		it "we can change skip mode:true" do
			expect(Testdriver.mainloop do |window|
				textdrawer.on_draw(window)
				textdrawer.set_skip_mode(true)
				textdrawer.instance_exec{@config[:skip_flag]}
			end).to be_truthy
		end
		
		it "we can change skip mode:false" do
			expect(Testdriver.mainloop do |window|
				textdrawer.on_draw(window)
				textdrawer.set_skip_mode(true)
				textdrawer.set_skip_mode(false)
				textdrawer.instance_exec{@config[:skip_flag]}
			end).to be_falsey
		end
		
		it "we can draw some str with skipmode" do
			expect(Testdriver.mainloop do |window|
				textdrawer.on_draw(window)
				textdrawer.set_skip_mode(true)
				textdrawer.on_move
			end).to be_truthy
		end
	end
	
end