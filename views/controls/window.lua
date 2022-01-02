-- The window. Oh boy.

local Window = Controls.Panel:extend()

Window.TitleBarWidth = 7+4
Window.SideWidth = 2
Window.ShadowDistance = 1
Window.ButtonRadius = 3
Window.DefaultDefaultPosition = Point(8, 32)
Window.DefaultPosition = Point(Window.DefaultDefaultPosition.x, Window.DefaultDefaultPosition.y)

function Window:new(o)
	self.title = o.title or "Window"
	
	-- THIS IS A HACK
	if not (o.position and (o.position.x or o.position.y) or (o.x or o.y)) then
		o.position = o.position or {}
		
		o.position.x = Window.DefaultPosition.x
		o.position.y = Window.DefaultPosition.y
		
		Window.DefaultPosition.x = Window.DefaultPosition.x + 8
		Window.DefaultPosition.y = Window.DefaultPosition.y + 8
		
		if Window.DefaultPosition.x > window.screen.width * 0.75 then
			Window.DefaultDefaultPosition.x = Window.DefaultDefaultPosition.x + 1
			Window.DefaultPosition.x = Window.DefaultDefaultPosition.x
			
			if Window.DefaultDefaultPosition.x > window.screen.width * 0.5 then
				Window.DefaultDefaultPosition.x = 8
			end
		end
		if Window.DefaultPosition.y > window.screen.height * 0.6 then
			Window.DefaultPosition.y = Window.DefaultDefaultPosition.y
		end
	end
	
	Window.super.new(self, o)
	
	if not o.borderless then
		if o.border then
			self.border = Sides(o.border.top, o.border.right, o.border.bottom, o.border.left)
		else
			self.border = Sides(Window.TitleBarWidth, Window.SideWidth, Window.SideWidth)
		end
	end
	
	self.style = {
		borderBackground = 1,
		borderForeground = 4,
		contentBackground = 4,
		shadow = 4,
	}
	self.color = self.style.contentBackground -- todo: please make this better,
	
	self.onTop = o.onTop or false
	
	self.status = "open"
	
	-- self.velocity = 0
end

function Window:isOver(checkPoint)
	if self.border then
		return Util.pointSquare(checkPoint.x, checkPoint.y,
			self.position.x - self.border.left,
			self.position.y - self.border.top,
			self.size.width + self.border.left + self.border.right,
			self.size.height + self.border.top + self.border.bottom
		)
	else
		return Util.pointSquare(checkPoint.x, checkPoint.y, self.position.x, self.position.y, self.size.width, self.size.height)
	end
end

function Window:update(dt)
	Window.super.update(self)
	
	--self.velocity = self.velocity * 0.9
end

function Window:draw()
	love.graphics.setColor(1, 1, 1)
	
	love.graphics.push()
	
	-- love.graphics.translate(self.position.x, self.position.y)
	Window.super.draw(self)
	
	love.graphics.pop()
end

function Window:drawBorder()
	if self.border then
		love.graphics.setColor(VieWS.PALETTE[self.style.borderBackground])
		
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
			love.graphics.setColor(VieWS.PALETTE[self.style.borderForeground])
			
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
	love.graphics.setColor(VieWS.PALETTE[self.style.shadow])
	
	if self.border then
		love.graphics.rectangle("line",
			self.position.x - self.border.left - Window.ShadowDistance + 0.5,
			self.position.y - self.border.top - Window.ShadowDistance + 0.5,
			self.size.width + self.border.left + self.border.right + 2 * Window.ShadowDistance - 1,
			self.size.height + self.border.top + self.border.bottom + 2 * Window.ShadowDistance - 1
		)
	else
		love.graphics.rectangle("line",
			self.position.x - Window.ShadowDistance + 0.5,
			self.position.y - Window.ShadowDistance + 0.5,
			self.size.width + 2 * Window.ShadowDistance - 1,
			self.size.height + 2 * Window.ShadowDistance - 1
		)
	end
	
	--[[
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
	]]
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
