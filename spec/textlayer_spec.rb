# encoding: utf-8
require_relative '../textlayer'
require_relative '../Tools/Testdriver'
require 'dxruby'

describe "TextBox" do
	# 初期設定
	#let(:textdrawer) {MonoScript.new("abcdefghijklmnopqrstuvwxyz")}


	describe "draw animator" do
		it "textbox" do
			expect(Testdriver.mainloop do |window|
				font = Font.new(24, "ＭＳ ゴシック")
				text = "あいうえおかきくけこ"
			image = Image.new(640, 480, [0, 0, 0, 0])
				tb = TextBox.new(image)
				tb.set_text(text)
				tb.set_font(font)
				tb.set_window(100,100,window)
				tb.draw
			end).to be_truthy
		end

		it "monoscript" do
			font = Font.new(24, "ＭＳ ゴシック")
			text = "あいうえおかきくけこ"
			image = Image.new(640, 480, [0, 0, 0, 0])
			sb = MonoScript.new(image)
			sb.set_text(text)
			sb.set_font(font)
			ms ||= ScriptController.new
			ms.set_script(sb)
			expect(Testdriver.mainloop do |window|
				ms.on_draw(100,100,window)
				ms.on_move
			end).to be_truthy
		end
	
	end
	
end