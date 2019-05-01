-- The window. Oh boy.

local Window = Panel:extend()
Window.TitleBarWidth = 10
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
			self.borderPanel = true
			-- self.borderPanel = Panel{
			-- 	x = -self.border.top,
			-- 	y = -self.border.left,
				
			-- 	width =  self.size.width + self.border.left + self.border.right,
			-- 	height = self.size.height + self.border.top + self.border.bottom
			-- }
		end
	end
	
	self.style = {
		borderBackground = {0, 0, 0},
		borderForeground = {0.85, 0.8, 0.8},
		contentBackground = {0.85, 0.8, 0.8}
	}
	
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
	love.graphics.setColor(self.style.contentBackground)
	love.graphics.rectangle("fill", self.position.x, self.position.y, self.size.width, self.size.height)
	
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
		
		if self.borderPanel then
			love.graphics.setColor(self.style.borderForeground)
			
			-- Title
			love.graphics.print(self.title, self.position.x, self.position.y - self.border.top + 1)
			
			-- Button
			love.graphics.circle(
				"fill",
				self.position.x + self.size.width - Window.ButtonRadius - 1,
				self.position.y - Window.ButtonRadius - 2,
				Window.ButtonRadius
			)
			
			-- TODO: look nice
		end
	end
end

function Window:drawShadow()
	love.graphics.setColor(0, 0, 0, 0.25)
	
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

return Window
