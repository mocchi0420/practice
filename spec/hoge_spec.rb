require_relative '../hoge'

describe "Bowling game" do
	before do
		@mygame = Game.new
	end	
	describe "game start" do
		before do
			#nothing to do
		end	
		
		it "we can check default result" do
			expect(@mygame.instance_exec{@score}).to eq([])
		end
		
		it "we can check default score" do
			expect(@mygame.instance_exec{@score}).to eq([])
		end
		
		it "we can check 0 frame" do
			expect(@mygame.instance_exec{@frame}).to eq(0)
		end
	end
	
	describe "roll" do
		before do
			#nothing to do
		end	
		
		it "we can get right 1st throw at 1st frame" do
			@mygame.roll(1)
			expect(@mygame.instance_exec{@current_result}).to eq([1])
			expect(@mygame.instance_exec{@result}).to eq([])
			expect(@mygame.instance_exec{@frame}).to eq(0)
		end
		
		it "we can get right 2nd throw at 1st frame" do
			@mygame.roll(1)
			@mygame.roll(1)
			expect(@mygame.instance_exec{@current_result}).to eq([])
			expect(@mygame.instance_exec{@result}).to eq([[1,1]])
			expect(@mygame.instance_exec{@frame}).to eq(1)
		end
		
		it "we cannot get over 10 pins at 1 throw" do
			expect(@mygame.roll(11)).to eq(false)
		end
		
		it "we cannot get over 10 pins at 1 round" do
			@mygame.roll(3)
			@mygame.roll(8)
			expect(@mygame.instance_exec{@current_result}).to eq([3])
			expect(@mygame.instance_exec{@result}).to eq([])
			expect(@mygame.instance_exec{@frame}).to eq(0)
		end
		
		it "we can get right 20 throws getting 1pin at 1game" do
			20.times do
				@mygame.roll(1)
			end
			expect(@mygame.instance_exec{@result}).to eq([[1,1],[1,1],[1,1],[1,1],[1,1],[1,1],[1,1],[1,1],[1,1],[1,1,0]])
			expect(@mygame.instance_exec{@frame}).to eq(10)
		end

		it "we can get right 20 throws getting strike at 1game" do
			20.times do
				@mygame.roll(10)
			end
			expect(@mygame.instance_exec{@result}).to eq([[10,0],[10,0],[10,0],[10,0],[10,0],[10,0],[10,0],[10,0],[10,0],[10,10,10]])
			expect(@mygame.instance_exec{@frame}).to eq(10)
		end
		
		it "we can get right 20 throws getting spare at 1game" do
			20.times do
				@mygame.roll(0)
				@mygame.roll(10)
			end
			expect(@mygame.instance_exec{@result}).to eq([[0,10],[0,10],[0,10],[0,10],[0,10],[0,10],[0,10],[0,10],[0,10],[0,10,0]])
			expect(@mygame.instance_exec{@frame}).to eq(10)
		end
		
		it "we can get right result at testgame" do
			@mygame.roll(6)
			@mygame.roll(3)
			@mygame.roll(9)
			@mygame.roll(0)
			@mygame.roll(0)
			@mygame.roll(3)
			@mygame.roll(8)
			@mygame.roll(2)
			@mygame.roll(7)
			@mygame.roll(3)
			@mygame.roll(10)
			@mygame.roll(9)
			@mygame.roll(1)
			@mygame.roll(8)
			@mygame.roll(0)
			@mygame.roll(10)
			@mygame.roll(10)
			@mygame.roll(6)
			@mygame.roll(4)												
			expect(@mygame.instance_exec{@result}).to eq([[6,3],[9,0],[0,3],[8,2],[7,3],[10,0],[9,1],[8,0],[10,0],[10,6,4]])
			expect(@mygame.instance_exec{@frame}).to eq(10)
		end
		
	end
	
	describe "score" do
		before do
			#nothing to do
		end	
		
		it "we can get 0 pts at 1st throw" do
			@mygame.roll(6)
			expect(@mygame.score).to eq(0)
		end
		
		it "we can get right pts at 2nd throw" do
			@mygame.roll(6)
			@mygame.roll(1)
			expect(@mygame.score).to eq(7)
		end
		
		it "we can get right pts at 10th round" do
			18.times do
				@mygame.roll(0)
			end
			@mygame.roll(10)
			@mygame.roll(10)
			@mygame.roll(10)
			ret = @mygame.score
			expect(@mygame.instance_exec{@result}).to eq([[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[10,10,10]])
			expect(@mygame.instance_exec{@score}).to eq([0,0,0,0,0,0,0,0,0,10,10,10])
			expect(ret).to eq(30)
		end
		
		it "we can get 300 pts at 12 strikes" do
			12.times do
				@mygame.roll(10)
			end
			ret = @mygame.score
			expect(@mygame.instance_exec{@result}).to eq([[10,0],[10,0],[10,0],[10,0],[10,0],[10,0],[10,0],[10,0],[10,0],[10,10,10]])
			expect(@mygame.instance_exec{@score}).to eq([30,30,30,30,30,30,30,30,30,10,10,10])
			expect(ret).to eq(300)
		end
		
		it "we cannot confirm pts at all strikes" do
			9.times do
				@mygame.roll(10)
			end
			ret = @mygame.score
			expect(@mygame.instance_exec{@result}).to eq([[10,0],[10,0],[10,0],[10,0],[10,0],[10,0],[10,0],[10,0],[10,0]])
			expect(@mygame.instance_exec{@score}).to eq([30,30,30,30,30,30,30,0,0])
			expect(ret).to eq(210)
		end
		
		it "we can get right result at testgame" do
			@mygame.roll(6)
			@mygame.roll(3)
			@mygame.roll(9)
			@mygame.roll(0)
			@mygame.roll(0)
			@mygame.roll(3)
			@mygame.roll(8)
			@mygame.roll(2)
			@mygame.roll(7)
			@mygame.roll(3)
			@mygame.roll(10)
			@mygame.roll(9)
			@mygame.roll(1)
			@mygame.roll(8)
			@mygame.roll(0)
			@mygame.roll(10)
			@mygame.roll(10)
			@mygame.roll(6)
			@mygame.roll(4)
			ret = @mygame.score
			expect(@mygame.instance_exec{@result}).to eq([[6,3],[9,0],[0,3],[8,2],[7,3],[10,0],[9,1],[8,0],[10,0],[10,6,4]])
			expect(ret).to eq(150)
		end
		
	end
	
end