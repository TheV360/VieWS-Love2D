local CheckBox = Controls.Control:extend()

function CheckBox:new(o)
	self.text = o.text or "CheckBox"
	self.color = o.color or 1
	self.value = o.value or false
	
	if not (o.size and o.size.width  or o.width ) then o.width  = view.font:getWidth (o.text) + 4 + 8 end
	if not (o.size and o.size.height or o.height) then o.height = view.font:getHeight(o.text) + 4 end
	
	CheckBox.super.new(self, o)
end

function CheckBox:draw()
	self:clearRect()
	
	love.graphics.setColor(VieWS.PALETTE[self.color])
	if self.hover then
		self:drawRect("fill")
		love.graphics.setColor(VieWS.PALETTE[4])
	else
		self:drawRect("line")
	end
	
	love.graphics.print(
		(self.value and '■' or '□') .. ' ' .. self.text,
		2, math.ceil((self.size.height - view.font:getHeight()) / 2)
	)
end

function CheckBox:set(value)
	if value ~= self.value then
		self.value = value
		self.redraw = true
	end
end

function CheckBox:mouse(m)
	view:switchCursor("hand")
end

function CheckBox:mouseClick(m)
	self.value = not (self.value or false)
	self.redraw = true
end

return CheckBox
