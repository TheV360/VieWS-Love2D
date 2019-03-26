Panel = Control:extend()

function Panel:new(o)
	Panel.super.new(self, o)
	
	-- Canvas
	self.canvas = love.graphics.newCanvas(self.size.width, self.size.height)
	
	-- Make controls
	self.controls = {}
	
	-- Run initialization function
	if type(o.setup) == "function" then
		o.setup(self)
	end
end

function Panel:addControl(name, c)
	self.controls[name] = c
end

function Panel:update()
	local i, c
	
	for i, c in pairs(self.controls) do
		c:update()
	end
end

function Panel:draw()
	local i, c
	local debugRects = false
	
	self.canvas:renderTo(function()
		for i, c in pairs(self.controls) do
			if c.redraw and c.visible then
				love.graphics.push()
				love.graphics.origin()
				
				if debugRects then
					love.graphics.origin()
					love.graphics.setColor(0, 0, 0, 0.125)
					c:drawRect("line")
				end
				
				love.graphics.translate(c.position.x, c.position.y)
				love.graphics.setScissor(c.position.x, c.position.y, c.size.width, c.size.height)
				
				love.graphics.setColor(0, 0, 0)
				c:draw()
				
				c.redraw = false
				
				love.graphics.setScissor()
				love.graphics.pop()
			end
		end
	end)
	
	love.graphics.setColor(1, 1, 1)
	love.graphics.draw(self.canvas, 0, 0)
end

return Panel
