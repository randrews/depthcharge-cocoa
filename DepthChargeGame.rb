#
#  DepthChargeGame.rb
#  DepthCharge
#
#  Created by Ross Andrews on 8/20/09.
#  Copyright (c) 2009 Home. All rights reserved.
#

require 'Util.rb'

class DepthChargeGame
	include Util

	attr_reader :controller
	attr_accessor :marks, :pings, :mines, :charges, :islands
	attr_accessor :status

	def initialize controller
		@controller = controller
		self.marks=[]
		self.pings=[]
		self.mines=[]
		self.charges=[]
		self.islands=[]

		self.status={
			:mines => 5,
			:misses => 0,
			:pings => 10,
			:markMode => nil,
			:clickMode => nil
		}

		controller.show_message ''
	
		gameCoords = randomCoords(17)

		self.islands = gameCoords[0..11].map do |ic|
			makeIsland ic
		end
		
		self.mines = gameCoords[12..16].map do |mc|
			{:coord => mc}
		end
	end

	def onMapClick coord
		return if status[:ignoreClicks]
		
		case status[:clickMode]
		when :ping
			ping_click coord
		when :mark
			mark_click coord
		when :dcharge
			dcharge_click coord
		end
	end
	
	def ping_click coord
		if status[:pings] <= 0
			controller.show_message "You are out of pings."
		else
			s = findSpaceIn coord, pings
			if s
				s[:returns] = getReturns(coord)
			else
				pings << {
					:coord => coord,
					:returns => getReturns(coord)
				}
			end
			
			status[:pings] -= 1
		end
	end

	def mark_click coord
		col = status[:markMode]
		if !col.nil? and !findSpaceIn(coord,islands)
			mark = findSpaceIn(coord,marks)

			if mark.nil?
				marks << {:color => col, :coord => coord}
			else
				if mark[:color]==col
					mark[:color]=OSX::NSColor.colorWithCalibratedRed_green_blue_alpha_(0, 0, 0x60/256.0, 1)
				else
					mark[:color]=col
				end
			end
		end
	end

	def dcharge_click coord
		if !findSpaceIn(coord,charges) && !findSpaceIn(coord,islands)
			hit = findSpaceIn(coord,mines)
			charges << {
				:coord => coord,
				:hit => hit
			}
			
			if hit
				status[:mines] -= 1
				removeMineAt coord
			else
				status[:misses] += 1
			end
			checkGameOver
		end
	end
	
	private
	
	def checkGameOver
		if status[:mines] == 0
			controller.show_message "All mines destroyed. You win!"
			status[:showMines] = true
			status[:ignoreClicks] = true
		elsif status[:misses] > 2
			controller.show_message "Too many misses. You lose."
			status[:showMines] = true
			status[:ignoreClicks] = true
		end
	end
	
	def removeMineAt coord
		self.mines = mines.reject{|m| m[:coord] == coord}
	end
end
