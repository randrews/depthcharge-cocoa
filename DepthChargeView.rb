#
#  DepthChargeView.rb
#  DepthCharge
#
#  Created by Ross Andrews on 8/20/09.
#  Copyright (c) 2009 Home. All rights reserved.
#

require 'osx/cocoa'

class DepthChargeView <  OSX::NSView
  ib_outlets :app_controller

  attr_accessor :images

  def initWithFrame frame
    super_initWithFrame frame

	self.images = {}
	%w{island1 island2 island3 island4 mine missedMine}.each do |img|
		path = OSX::NSBundle.mainBundle.pathForResource_ofType(img, "jpg")
		self.images[img] = OSX::NSImage.new.initWithContentsOfFile path
	end

    self
  end

  def drawRect rect
	draw_background rect
	draw_islands rect
	draw_marks rect
	draw_grid rect
  end

  def mouseDown event
	point = convertPoint_fromView_(event.locationInWindow, nil)
	
	x = (point.x * 12 / bounds.size.width).floor
	y = (point.y * 12 / bounds.size.height).floor
	
	y = 11 - y # Cocoa coords are bottom-to-top
	
	@app_controller.handle_click x, y
  end
  
  private
  
  def draw_grid rect
	width = rect.size.width/12
	height = rect.size.height/12
	
	context = OSX::NSGraphicsContext.currentContext
	OSX::NSColor.yellowColor.setStroke

	(0..12).each do |y|
	  (0..12).each do |x|
	    r = OSX::NSRect.new x*width, y*height, width, height
	    OSX::NSBezierPath::bezierPathWithRect(r).stroke
      end
    end
  end
  
  def draw_background rect
	OSX::NSColor.colorWithCalibratedRed_green_blue_alpha_(0, 0, 0x60/256.0, 1.0).setFill
	OSX::NSBezierPath::bezierPathWithRect(rect).fill
  end
  
  def draw_islands rect
	width=rect.size.width/12
	height=rect.size.height/12
	
	@app_controller.game.islands.each do |island|
		img=images[island[:name]];
		img.drawAtPoint_fromRect_operation_fraction_(
			OSX::NSPoint.new(width*island[:coord][:x], height*(11 - island[:coord][:y])),
			OSX::NSZeroRect,
			OSX::NSCompositeSourceOver,
			1.0)
	end
  end
  
  def draw_marks rect
	width=rect.size.width/12;
	height=rect.size.height/12;

	@app_controller.game.marks.each do |mark|
		mark[:color].setFill
		
		mrect = OSX::NSRect.new(width*mark[:coord][:x],
								height*(11 - mark[:coord][:y]),
								width,
								height)
		OSX::NSRectFill mrect
	end
  end
end
