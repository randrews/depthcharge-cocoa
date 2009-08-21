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

end
