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
	@width = rect.size.width/12
	@height = rect.size.height/12

	draw_background rect
	draw_islands
	draw_marks
	draw_charges
	draw_mines if @app_controller.game.status[:showMines]
	draw_grid
  end

  def mouseDown event
	point = convertPoint_fromView_(event.locationInWindow, nil)
	
	x = (point.x * 12 / bounds.size.width).floor
	y = (point.y * 12 / bounds.size.height).floor
	
	y = 11 - y # Cocoa coords are bottom-to-top
	
	@app_controller.handle_click x, y
  end
  
  private
  
  def draw_grid
	
	context = OSX::NSGraphicsContext.currentContext
	OSX::NSColor.yellowColor.setStroke

	(0..12).each do |y|
	  (0..12).each do |x|
	    r = OSX::NSRect.new x*@width, y*@height, @width, @height
	    OSX::NSBezierPath::bezierPathWithRect(r).stroke
      end
    end
  end
  
  def draw_background rect
	OSX::NSColor.colorWithCalibratedRed_green_blue_alpha_(0, 0, 0x60/256.0, 1.0).setFill
	OSX::NSBezierPath::bezierPathWithRect(rect).fill
  end

  def draw_islands
	@app_controller.game.islands.each do |island|
		blit island[:name], island[:coord]
	end
  end
  
  def draw_mines
	@app_controller.game.mines.each do |mine|
		blit 'missedMine', mine[:coord]
	end
  end
  
  def draw_marks
	@app_controller.game.marks.each do |mark|
		mark[:color].setFill
		
		OSX::NSRectFill(
			OSX::NSRect.new(
				@width*mark[:coord][:x],
				@height*(11 - mark[:coord][:y]),
				@width,
				@height))
	end
  end
  
  def draw_charges
	@app_controller.game.charges.each do |charge|
		if charge[:hit]
			blit 'mine', charge[:coord]
		end
		drawX charge[:coord]
	end
  end
  
  def drawX coord
	w = @width
	h = @height
  
	OSX::NSColor.colorWithCalibratedRed_green_blue_alpha_(0xe0/256.0, 0, 0, 1).setStroke
	path = OSX::NSBezierPath.new
	
	path.moveToPoint(OSX::NSPoint.new(w * coord[:x] + w / 3,
									  h * (11 - coord[:y]) + h * 2/3))

	path.relativeLineToPoint(OSX::NSPoint.new(w * 1/3, -h * 1/3))

	path.relativeMoveToPoint(OSX::NSPoint.new(0, h * 1/3))

	path.relativeLineToPoint(OSX::NSPoint.new(-w * 1/3, -h * 1/3))

	path.stroke
  end

  def blit imageName, coord
	images[imageName].drawAtPoint_fromRect_operation_fraction_(
		point_for_cell(coord),
		OSX::NSZeroRect,
		OSX::NSCompositeSourceOver, 1.0)
  end

  def point_for_cell coord
	OSX::NSPoint.new(@width*coord[:x], @height*(11 - coord[:y]))
  end
end
