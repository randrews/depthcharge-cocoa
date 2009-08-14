#
#  AppController.rb
#  DepthCharge
#
#  Created by Ross Andrews on 8/12/09.
#  Copyright (c) 2009 Home. All rights reserved.
#

require 'osx/cocoa'

class AppController < OSX::NSObject
	ib_outlets :dc_button, :mark_button, :ping_button, :mark_orange, :mark_green, :mark_blue, :dc_label, :ping_label, :status_label
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
end
