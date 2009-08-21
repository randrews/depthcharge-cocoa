#
#  ColorButton.rb
#  DepthCharge
#
#  Created by Ross Andrews on 8/20/09.
#  Copyright (c) 2009 Home. All rights reserved.
#

require 'osx/cocoa'

class ColorButton <  OSX::NSView
  attr_accessor :color, :highlighted
  ib_outlet :app_controller
  
  def initWithFrame(frame)
    super_initWithFrame(frame)
    # Initialization code here.
    return self
  end

  def drawRect rect
	if color
	  path = OSX::NSBezierPath::bezierPathWithRect(rect)
	  color.setFill
	  path.fill
	  if highlighted
		OSX::NSColor.yellowColor.setStroke
		path.setLineWidth 3.0
	  else
	    OSX::NSColor.grayColor.setStroke
	  end
	  path.stroke
	end
  end

  def mouseDown event
	@app_controller.push_mark_button self
  end
end
