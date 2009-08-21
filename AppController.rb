#
#  AppController.rb
#  DepthCharge
#
#  Created by Ross Andrews on 8/12/09.
#  Copyright (c) 2009 Home. All rights reserved.
#

require 'osx/cocoa'

class AppController < OSX::NSObject
	ib_outlets :dc_button, :mark_button, :ping_button
	ib_outlets :mark_orange, :mark_green, :mark_blue
	ib_outlets :dc_label, :ping_label, :status_label
	ib_outlets :depth_charge_view

	ib_action :new_game
	ib_action :ping_push
	ib_action :dc_push
	ib_action :mark_push

	def new_game
		puts "New game"
	end

	{:ping_push=>:@ping_button, :dc_push=>:@dc_button, :mark_push=>:@mark_button}.each do |name, value|
		self.send :define_method, name do
			button = instance_variable_get(value)
			if button.state==1
				[@ping_button, @dc_button, @mark_button].each{|b| b.setState(0)}
				button.setState(1)
			end
		end
	end
	
	def awakeFromNib
		@mark_blue.color = OSX::NSColor.colorWithCalibratedRed_green_blue_alpha_(0, 0, 0x60/256.0, 1)
		@mark_green.color = OSX::NSColor.colorWithCalibratedRed_green_blue_alpha_(0, 0xa0/256.0, 0x60/256.0, 1)
		@mark_orange.color = OSX::NSColor.colorWithCalibratedRed_green_blue_alpha_(0xb0/256.0, 0x80/256.0, 0x40/256.0, 1)
	end
end
