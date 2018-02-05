require_relative '../hoge'

describe "Bowling game" do
	before do
		@mygame = Game.new
	end	
	describe "game start" do
		before do
			#nothing to do
		end	
		
		it "we can check 0 score" do
			expect(@mygame.score).to eq(0)
		end
		
		it "we can check 0 frame" do
			expect(@mygame.instance_exec{@frame}).to eq(0)
		end
	end
	
	describe "defeat pins " do
		context "nominal scenarios" do
			before do
				#nothing to do
			end	
			it "we can defeat 0 pins once" do
				expect(@mygame.roll(0)).to eq(true)
			end
			
			it "we can defeat 10 pins once" do
				expect(@mygame.roll(10)).to eq(true)
			end
			
			it "we can defeat total 10 pins" do
				@mygame.roll(7)
				expect(@mygame.roll(3)).to eq(true)
				@mygame.roll(0)
				expect(@mygame.roll(10)).to eq(true)
				expect(@mygame.roll(10)).to eq(true)
			end
		end
		
		context "non-nominal scenarios" do
			before do
				#nothing to do
			end
			
			it "we cannot defeat -1 pins once" do
				expect(@mygame.roll(-1)).to eq(false)
			end
			
			it "we cannot defeat 11 pins once" do
				expect(@mygame.roll(11)).to eq(false)
			end
			
			it "we cannot defeat str pins once" do
				expect(@mygame.roll("hogehoge")).to eq(false)
			end

			it "we cannot defeat 0.3 pins once" do
				expect(@mygame.roll(0.3)).to eq(false)
			end
			
			it "we cannot defeat total 10 over pins" do
				@mygame.roll(7)
				expect(@mygame.roll(4)).to eq(false)
				@mygame.reset
				@mygame.roll(0)
				expect(@mygame.roll(11)).to eq(false)
			end
		end
	end
	
	describe "play normal game" do
		before do
			#nothing to do
		end
		describe "at 0-9 frame" do
			it "we must go next frame when we throw 2 ball" do
				@mygame.roll(1)
				@mygame.roll(1)
				expect(@mygame.instance_exec{@frame}).to eq(1)
			end
			
			it "we must get 0 point when we defeat 0 pins" do
				@mygame.roll(0)
				@mygame.roll(0)
				expect(@mygame.score).to eq(0)
			end
			
			it "we must get STRIKE point when we defeat 10 pins ONCE" do
				@mygame.roll(10)
				expect(@mygame.instance_exec{@result[0]}).to eq([10,0])		
				expect(@mygame.instance_exec{@strike_sheet[0]}).to eq("STRIKE")
			end
			
			it "we must get SPARE point when we defeat 10 pins" do
				@mygame.roll(0)		
				@mygame.roll(10)
				expect(@mygame.instance_exec{@result[0]}).to eq([0,10])
				expect(@mygame.instance_exec{@strike_sheet[0]}).to eq("SPARE")
			end
			
			it "we get 9 score when 6pins + 3pins at 1 frame" do
				@mygame.roll(6)
				@mygame.roll(3)
				expect(@mygame.instance_exec{@result[0]}).to eq([6,3])
				expect(@mygame.score).to eq(9)
			end
		
		end
		
		describe "at 10 frame" do
		
		end
		
		describe "through 1 set game" do
			it "we get ALL_STRIKE" do
				12.times do
					@mygame.roll(10)
				end
				
				@mygame.score
				@mygame.instance_exec{p @score}
				expect(@mygame.instance_exec{@result}).to eq([[10,0],[10,0],[10,0],[10,0],[10,0],[10,0],[10,0],[10,0],[10,0],[10,10,10]])
				expect(@mygame.score).to eq(300)
			end
			
			it "we get right score as example" do
				@mygame.roll(6)
				@mygame.roll(3)
				expect(@mygame.score).to eq(9)
				@mygame.roll(9)
				@mygame.roll(0)
				expect(@mygame.score).to eq(18)
				@mygame.roll(0)
				@mygame.roll(3)
				expect(@mygame.score).to eq(21)
				@mygame.roll(8)
				@mygame.roll(2)
				expect(@mygame.score).to eq(21)
				@mygame.roll(7)
				@mygame.roll(3)
				expect(@mygame.score).to eq(38)
				@mygame.roll(10)
				expect(@mygame.score).to eq(58)
			end
			
		end

	end
	
end