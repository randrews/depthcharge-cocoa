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

	attr_accessor :game

	def new_game
		self.game = DepthChargeGame.new self
		update_messages
		@depth_charge_view.setNeedsDisplay true
		[@ping_button, @dc_button, @mark_button].each{|b| b.setState(0) }
		[@mark_orange, @mark_green, @mark_blue].each{|m| m.highlighted = false ; m.setNeedsDisplay true}
	end

	{:ping_push=>:@ping_button, :dc_push=>:@dc_button, :mark_push=>:@mark_button}.each do |name, value|
		self.send :define_method, name do
			button = instance_variable_get(value)
			if button.state==1
				[@ping_button, @dc_button, @mark_button].each{|b| b.setState(0)}
				button.setState(1)

				case name
				when :ping_push ; game.status[:clickMode] = :ping
				when :dc_push ; game.status[:clickMode] = :dcharge
				when :mark_push ; game.status[:clickMode] = :mark
				end
			else
				game.status[:clickMode] = nil
			end
		end
	end

	def push_mark_button button
		[@mark_blue, @mark_green, @mark_orange].each{|b| b.highlighted = false}
		button.highlighted = true
		[@mark_blue, @mark_green, @mark_orange].each{|b| b.setNeedsDisplay true}
		
		@mark_button.setState 1
		@ping_button.setState 0
		@dc_button.setState 0
		
		game.status[:markMode] = button.color
		game.status[:clickMode] = :mark
	end
	
	def awakeFromNib
		@mark_blue.color = OSX::NSColor.colorWithCalibratedRed_green_blue_alpha_(0, 0, 0x60/256.0, 1)
		@mark_green.color = OSX::NSColor.colorWithCalibratedRed_green_blue_alpha_(0, 0xa0/256.0, 0x60/256.0, 1)
		@mark_orange.color = OSX::NSColor.colorWithCalibratedRed_green_blue_alpha_(0xb0/256.0, 0x80/256.0, 0x40/256.0, 1)
		
		self.game = DepthChargeGame.new(self)
		update_messages
	end
	
	def show_message str = ''
		@status_label.setStringValue str
	end
	
	def handle_click x, y # These are board coordinates, 0..11
		game.onMapClick(:x => x, :y => y)
		# puts game.inspect # This is really handy for debugging
		@depth_charge_view.setNeedsDisplay true
		update_messages
	end
	
	def update_messages
		mc = game.status[:mines]
		d = "#{mc} mine#{mc==1 ? '' : 's'}";

		if game.status[:misses] != 0
			m = game.status[:misses]
			d += ", #{m} miss#{m==1 ? '' : 'es'}"
		else
			d +=" left"
		end
		
		pc = game.status[:pings]
		s = "#{pc} ping#{pc==1 ? '' : 's'} left"
		
		@dc_label.setStringValue d
		@ping_label.setStringValue s
	end
end