local Panel = Controls.Control:extend()

function Panel:new(o)
	Panel.super.new(self, o)
	
	-- Canvas
	self.canvas = love.graphics.newCanvas(self.size.x, self.size.y)
	
	-- Color
	self.color = o.color or 4
	
	-- Make controls
	self.controls = {}
	
	-- Run initialization function
	if type(o.setup) == "function" then
		o.setup(self)
	end
end

function Panel:addControl(control)
	self.controls[control.name or (#self.controls + 1)] = control
	control.parent = self
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
					love.graphics.setColor(1, 0, 0, 0.125)
					c:drawRect("line")
				end
				
				love.graphics.translate(c.position.x, c.position.y)
				love.graphics.setScissor(c.position.x, c.position.y, c.size.x, c.size.y)
				
				love.graphics.setColor(VieWS.PALETTE[1])
				c:draw()
				
				c.redraw = false
				
				love.graphics.setScissor()
				love.graphics.pop()
			end
		end
	end)
	
	love.graphics.setColor(VieWS.PALETTE[self.color])
	love.graphics.rectangle("fill", 0, 0, self.size.x, self.size.y)
	
	love.graphics.setColor(1, 1, 1)
	love.graphics.draw(self.canvas, 0, 0)
end

function Panel:doRedraw()
	for i, c in pairs(self.controls) do
		c:doRedraw()
	end
end

function Panel:mouse(m)
	local i, c
	
	local b4 = m.position
	for i, c in pairs(self.controls) do
		local x, y, w, h = c:getPaddingRect(true)
		m.position = b4 - c.position
		
		if c:isOver(m.position) then
			if not c.hover then
				c:mouseEnter(m)
				
				c.redraw = true
			end
			
			c.hover = true
			
			c:mouse(m)
		else
			if c.hover then
				c:mouseExit(m)
				
				c.redraw = true
			end
			
			c.hover = false
		end
	end
	m.position = b4
end

function Panel:mouseClick(m)
	local b4 = m.position
	for i, c in pairs(self.controls) do
		m.position = b4 - c.position
		if c:isOver(m.position) then
			c:mouseClick(m)
		end
	end
	m.position = b4
end

function Panel:mouseDown(m)
	local b4 = m.position
	for i, c in pairs(self.controls) do
		m.position = b4 - c.position
		if c:isOver(m.position) then
			c:mouseDown(m)
		end
	end
	m.position = b4
end
function Panel:mouseUp(m)
	local b4 = m.position
	for i, c in pairs(self.controls) do
		m.position = b4 - c.position
		if c:isOver(m.position) then
			c:mouseUp(m)
		end
	end
	m.position = b4
end

function Panel:mouseEnter(m)
end

function Panel:mouseExit(m)
	local i, c
	
	for i, c in pairs(self.controls) do
		if c.hover then
			c.redraw = true
			c.hover = false
		end
	end
end

return Panel
