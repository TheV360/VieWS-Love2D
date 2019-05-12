-- The window. Oh boy.

local Window = Panel:extend()

Window.TitleBarWidth = 11
Window.SideWidth = 1
Window.ShadowDistance = 2
Window.ButtonRadius = 3

function Window:new(o)
	self.title = o.title or "Window"
	
	Window.super.new(self, o)
	
	if not o.borderless then
		if o.border then
			self.border = Sides(o.border.top, o.border.right, o.border.bottom, o.border.left)
		else
			self.border = Sides(Window.TitleBarWidth, Window.SideWidth, Window.SideWidth)
		end
	end
	
	self.style = {
		borderBackground = {0, 0, 0},
		borderForeground = {0.85, 0.8, 0.8},
		contentBackground = {0.85, 0.8, 0.8},
		shadow = {0, 0, 0, 0.25}
	}
	self.color = self.style.contentBackground -- todo: please make this better,
	
	self.status = "normal"
end

function Window:onWindow(x, y)
	if self.border then
		return Util.pointSquare(x, y,
			self.position.x - self.border.left,
			self.position.y - self.border.top,
			self.size.width + self.border.left + self.border.right,
			self.size.height + self.border.top + self.border.bottom
		)
	else
		return self:onContent(x, y)
	end
end

function Window:onContent(x, y)
	return x >= self.position.x
	and    y >= self.position.y
	and    x <  self.position.x + self.size.width
	and    y <  self.position.y + self.size.height
end

function Window:update()
	Window.super.update(self)
end

function Window:draw()
	love.graphics.setColor(1, 1, 1)
	
	love.graphics.push()
	love.graphics.origin()
	
	love.graphics.translate(self.position.x, self.position.y)
	Window.super.draw(self)
	
	love.graphics.pop()
end

function Window:drawBorder()
	if self.border then
		love.graphics.setColor(self.style.borderBackground)
		
		-- Top
		love.graphics.rectangle(
			"fill",
			self.position.x - self.border.left,
			self.position.y - self.border.top,
			self.size.width + self.border.left + self.border.right,
			self.border.top
		)
		
		-- Left
		love.graphics.rectangle(
			"fill",
			self.position.x - self.border.left,
			self.position.y,
			self.border.left,
			self.size.height
		)
		
		-- Right
		love.graphics.rectangle(
			"fill",
			self.position.x + self.size.width,
			self.position.y,
			self.border.right,
			self.size.height
		)
		
		-- Bottom
		love.graphics.rectangle(
			"fill",
			self.position.x - self.border.left,
			self.position.y + self.size.height,
			self.size.width + self.border.left + self.border.right,
			self.border.bottom
		)
		
		if self.border.top >= Window.TitleBarWidth then
			love.graphics.setColor(self.style.borderForeground)
			
			-- Title
			love.graphics.print(self.title, self.position.x, self.position.y - self.border.top + 1)
			
			-- Button
			love.graphics.circle(
				"fill",
				self.position.x + self.size.width - Window.ButtonRadius,
				self.position.y - Window.ButtonRadius - 3,
				Window.ButtonRadius
			)
		end
	end
end

function Window:drawShadow()
	love.graphics.setColor(self.style.shadow)
	
	if self.border then
		-- Right
		love.graphics.rectangle(
			"fill",
			self.position.x + self.size.width + self.border.right,
			self.position.y - self.border.top + Window.ShadowDistance,
			Window.ShadowDistance,
			self.size.height + self.border.top + self.border.bottom - Window.ShadowDistance
		)
		
		-- Bottom
		love.graphics.rectangle(
			"fill",
			self.position.x - self.border.left + Window.ShadowDistance,
			self.position.y + self.size.height + self.border.bottom,
			self.size.width + self.border.left + self.border.right,-- - Window.ShadowDistance,
			Window.ShadowDistance
		)
	else
		-- Right
		love.graphics.rectangle(
			"fill",
			self.position.x + self.size.width,
			self.position.y + Window.ShadowDistance,
			Window.ShadowDistance,
			self.size.height
		)
		
		-- Bottom
		love.graphics.rectangle(
			"fill",
			self.position.x + Window.ShadowDistance,
			self.position.y + self.size.height,
			self.size.width - Window.ShadowDistance,
			Window.ShadowDistance
		)
	end
end

function Window:close()
	self.status = "close"
end


function Window:mouse(m)
	if self.borderless or m.y - self.position.y >= 0 then
		Window.super.mouse(self, m)
	else
		if m.x - self.position.x >= self.size.width - Window.ButtonRadius * 2 - 1 then
			window:switchCursor("hand")
		else
			if m.drag.window == self then
				window:switchCursor("move")
			else
				window:switchCursor("movable")
			end
		end
	end
end

function Window:mouseClick(m)
	if self.borderless or m.y - self.position.y >= 0 then
		Window.super.mouseClick(self, m)
	else
		if m.x - self.position.x >= self.size.width - Window.ButtonRadius * 2 - 1 then
			self:close()
		else
			m.drag.window = self
			m.drag.x = m.x - self.position.x
			m.drag.y = m.y - self.position.y
		end
	end
end

return Window
