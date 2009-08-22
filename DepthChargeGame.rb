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
	attr_accessor :blocks

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

		self.blocks=nil

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
	
	def ping_click
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

	def dcharge_click
	end
end
