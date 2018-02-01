require_relative '../hoge'

describe "Bowling game" do
	mygame = Game.new
	it "we can check 0 score" do
		mygame.reset
		expect(mygame.score).to eq(0)
	end
	it "we can check 0 frame" do
		mygame.reset
		expect(mygame.instance_exec{@frame}).to eq(0)
	end
	
	it "we can defeat 0 pins once" do
		mygame.reset
		expect(mygame.roll(0)).to eq(true)
	end
	
	it "we can defeat 10 pins once" do
		mygame.reset
		expect(mygame.roll(10)).to eq(true)
	end
	
	it "we cannot defeat -1 pins once" do
		mygame.reset
		expect(mygame.roll(-1)).to eq(false)
	end
	
	it "we cannot defeat 11 pins once" do
		mygame.reset
		expect(mygame.roll(11)).to eq(false)
	end
	
	it "we cannot defeat str pins once" do
		mygame.reset
		expect(mygame.roll("hogehoge")).to eq(false)
	end

	it "we cannot defeat 0.3 pins once" do
		mygame.reset
		expect(mygame.roll(0.3)).to eq(false)
	end

	it "we can defeat total 10 pins" do
		mygame.reset
		mygame.roll(7)
		expect(mygame.roll(3)).to eq(true)
		mygame.roll(0)
		expect(mygame.roll(10)).to eq(true)
		expect(mygame.roll(10)).to eq(true)
	end

	it "we cannot defeat total 10 over pins" do
		mygame.reset
		mygame.roll(7)
		expect(mygame.roll(4)).to eq(false)
		mygame.reset
		mygame.roll(0)
		expect(mygame.roll(11)).to eq(false)
	end

	it "we must go next frame when we throw 2 ball" do
		mygame.reset
		mygame.roll(1)
		mygame.roll(1)
		expect(mygame.instance_exec{@frame}).to eq(1)
	end
	
	it "we must get 0 point when we defeat 0 pins" do
		mygame.reset
		mygame.roll(0)
		mygame.roll(0)
		expect(mygame.score).to eq(0)
	end
	
	it "we must get STRIKE point when we defeat 10 pins ONCE" do
		mygame.reset
		mygame.roll(10)
		expect(mygame.instance_exec{@result[0]}).to eq([10,0])		
		expect(mygame.instance_exec{@score[0]}).to eq("STRIKE")
	end
	
	it "we must get SPARE point when we defeat 10 pins" do
		mygame.reset
		mygame.roll(0)		
		mygame.roll(10)
		expect(mygame.instance_exec{@result[0]}).to eq([0,10])
		expect(mygame.instance_exec{@score[0]}).to eq("SPARE")
	end
	
	it "we get ALL_STRIKE" do
		mygame.reset
		12.times do
			mygame.roll(10)
		end
		expect(mygame.instance_exec{@result}).to eq([[10,0],[10,0],[10,0],[10,0],[10,0],[10,0],[10,0],[10,0],[10,0],[10,10,10]])
		expect(mygame.instance_exec{@score}).to eq(["STRIKE","STRIKE","STRIKE","STRIKE","STRIKE","STRIKE","STRIKE","STRIKE","STRIKE","STRIKE","STRIKE","STRIKE"])
		expect(mygame.score).to eq(300)
	end
	
	it "we get 9 score when 6pins + 3pins at 1 frame" do
		mygame.reset
		mygame.roll(6)
		mygame.roll(3)
		expect(mygame.instance_exec{@result[0]}).to eq([6,3])
		expect(mygame.instance_exec{@score[0]}).to eq(9)
	end
	
	it "we get 9 score when 6pins + 3pins at 1 frame" do
		mygame.reset
		mygame.roll(6)
		mygame.roll(3)
		expect(mygame.instance_exec{@result[0]}).to eq([6,3])
		expect(mygame.instance_exec{@score[0]}).to eq(9)
		expect(mygame.score).to eq(9)
	end
	
	it "we get right score as example" do
		mygame.reset
		mygame.roll(6)
		mygame.roll(3)
		mygame.roll(9)
		mygame.roll(0)
		expect(mygame.score).to eq(18)
	end
	
	
end