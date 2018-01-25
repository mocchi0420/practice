# coding: utf-8

p "最初の一歩だよ！！"

require 'dxruby'
require './Tools/DataTableFactory.rb'

p DataTableFactory.load("C:/Users/suzuki/Documents/GitHub/practice/Data/Output/Character")
p DataTableFactory.load("C:/Users/suzuki/Documents/GitHub/practice/Data/Output/Item")

Window.loop do
  # ここにゲームの処理を書く 
end