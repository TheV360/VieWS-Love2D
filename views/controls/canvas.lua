local Canvas = Controls.Control:extend()

function Canvas:new(o)
	Canvas.super.new(self, o)
	
	-- Canvas
	self.canvas = love.graphics.newCanvas(self.size:unpack())
	
	-- Draw Callback
	self.drawCallback = o.draw or function(self)end
	
	-- Keep Drawing?
	self.keepDrawing = o.keepDrawing or false
end

function Canvas:update()
	if self.keepDrawing then self.redraw = true end
end

function Canvas:draw()
	self.canvas:renderTo(function() self:drawCallback() end)
	
	love.graphics.setColor(1, 1, 1)
	love.graphics.draw(self.canvas, 0, 0)
end

return Canvas
