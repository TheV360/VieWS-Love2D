local Control = VieWSEventRect:extend()

function Control:new(o)
	Control.super.new(self, o)
	
	if o.align and #o.align == 2 then
		self:alignTo(o.align[1], o.align[2])
	end
	
	if o.padding then
		local p = o.padding
		
		if type(p) == "number" and p > 0 then
			self.padding = Sides(p, p, p, p)
		elseif p:is(Sides) then
			self.padding = Sides(p.top, p.right, p.bottom, p.left)
		end
	end
	
	-- Can be interacted with?
	self.enabled = o.enabled ~= false
	
	-- Is visible?
	self.visible = o.visible ~= false
	
	-- Is hovered?
	self.hover = false
	
	-- Needs a redraw?
	self.redraw = true
end

function Control:update()
end

function Control:draw()
	love.graphics.rectangle(
		"fill",
		0,
		0,
		self.size.x,
		self.size.y
	)
end

function Control:getPaddingRect(round)
	local x, y, w, h
	
	if self.padding then
		local r = SidesAroundRect(self.padding, self)
		
		x, y = r.position.x, r.position.y
		w, h = r.size.x, r.size.y
	else
		x, y = self.position.x, self.position.y
		w, h = self.size.x, self.size.y
	end
	
	if round then
		x, y = math.floor(x), math.floor(y)
		w, h = math.floor(w), math.floor(h)
	end
	
	return x, y, w, h
end

function Control:drawRect(mode)
	local x, y, w, h = self:getPaddingRect(true)
	
	if mode == "line" then
		love.graphics.rectangle("line", 0.5, 0.5, w - 1, h - 1)
	else
		love.graphics.rectangle("fill", 0, 0, w, h)
	end
end

function Control:clearRect()
	local x, y, w, h = self:getPaddingRect(true)
	
	love.graphics.push("all")
	love.graphics.setColor(0, 0, 0, 0)
	love.graphics.setBlendMode("replace")
	
	love.graphics.rectangle("fill", 0, 0, w, h)
	
	love.graphics.pop()
end

-- function Control:isOver(checkPoint)
-- 	if padding then
		
-- 	else
-- 		Control.super.isOver(self, checkPoint)
-- 	end
-- end

return Control
