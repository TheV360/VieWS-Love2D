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
		
		if Window.DefaultPosition.x > screen.size.x * 0.75 then
			Window.DefaultDefaultPosition.x = Window.DefaultDefaultPosition.x + 1
			Window.DefaultPosition.x = Window.DefaultDefaultPosition.x
			
			if Window.DefaultDefaultPosition.x > screen.size.x * 0.5 then
				Window.DefaultDefaultPosition.x = 8
			end
		end
		if Window.DefaultPosition.y > screen.size.y * 0.6 then
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
	else
		self.border = Sides(0)
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
	
	-- self.velocity = Vec2(0, 0)
end

function Window:isOver(checkPoint)
	if self.border then
		return Util.pointInBox(
			checkPoint,
			self.position - Vec2(self.border.left, self.border.top),
			self.size + Vec2(self.border.left, self.border.top) + Vec2(self.border.right, self.border.bottom)
		)
	end
end

function Window:update(dt)
	Window.super.update(self)
	
	--[[if view.mouse.drag.window ~= self then
		self.position = self.position + self.velocity
		if self.velocity:squaredMagnitude() ~= 0 then
			if self.position.x < 0 then self.position.x = 0 self.velocity.x = math.abs(self.velocity.x) end
			if self.position.y < 16 then self.position.y = 16 self.velocity.y = math.abs(self.velocity.y) end
			if self.position.x + self.size.x >= view.size.x then self.position.x = view.size.x - self.size.x self.velocity.x = -math.abs(self.velocity.x) end
			if self.position.y + self.size.y >= view.size.y then self.position.y = view.size.y - self.size.y self.velocity.y = -math.abs(self.velocity.y) end
			self.velocity = self.velocity * 0.975
		end
	end]]
end

function Window:draw()
	love.graphics.setColor(1, 1, 1)
	
	love.graphics.push()
	
	self:drawShadow()
	self:drawBorder()
	Window.super.draw(self)
	
	love.graphics.pop()
end

function Window:drawBorder()
	love.graphics.setColor(VieWS.PALETTE[self.style.borderBackground])
	
	-- Top
	if self.border.top > 0 then
		love.graphics.rectangle(
			"fill",
			-self.border.left,
			-self.border.top,
			self.size.x + self.border.left + self.border.right,
			self.border.top
		)
	end
	
	-- Left
	if self.border.left > 0 then
		love.graphics.rectangle(
			"fill",
			-self.border.left, 0,
			self.border.left,
			self.size.y
		)
	end
	
	-- Right
	if self.border.right > 0 then
		love.graphics.rectangle(
			"fill",
			self.size.x, 0,
			self.border.right,
			self.size.y
		)
	end
	
	-- Bottom
	if self.border.bottom > 0 then
		love.graphics.rectangle(
			"fill",
			-self.border.left, self.size.y,
			self.size.x + self.border.left + self.border.right,
			self.border.bottom
		)
	end
	
	-- Decorations
	if self.border.top >= Window.TitleBarWidth then
		love.graphics.setColor(VieWS.PALETTE[self.style.borderForeground])
		
		-- Title
		love.graphics.print(self.title, 0, -self.border.top + 1)
		
		-- Button
		love.graphics.circle(
			"fill",
			self.size.x - Window.ButtonRadius,
			-Window.ButtonRadius - 3,
			Window.ButtonRadius
		)
	end
end

function Window:drawShadow()
	love.graphics.setColor(VieWS.PALETTE[self.style.shadow])
	
	love.graphics.rectangle("line",
		-self.border.left - Window.ShadowDistance + 0.5,
		-self.border.top - Window.ShadowDistance + 0.5,
		self.size.x + self.border.left + self.border.right + 2 * Window.ShadowDistance - 1,
		self.size.y + self.border.top + self.border.bottom + 2 * Window.ShadowDistance - 1
	)
end

function Window:close()
	self.status = "close"
end


function Window:mouse(m)
	if self.borderless or m.position.y >= 0 then
		Window.super.mouse(self, m)
	else
		if m.position.x >= self.size.x - Window.ButtonRadius * 2 - 1 then
			view:switchCursor("hand")
		else
			if m.drag.window == self then
				view:switchCursor("move")
			else
				view:switchCursor("movable")
			end
		end
	end
end

function Window:mouseClick(m)
	if self.borderless or m.position.y >= 0 then
		Window.super.mouseClick(self, m)
	else
		if m.position.x >= self.size.x - Window.ButtonRadius * 2 - 1 then
			self:close()
		else
			m.drag.window = self
			m.drag.x = m.position.x
			m.drag.y = m.position.y
		end
	end
end

return Window
