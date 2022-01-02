local Label = Controls.Control:extend()

function Label:new(o)
	self.text = o.text or "Label"
	self.color = o.color or 1
	
	if not (o.size and o.size.x or o.width ) then o.width = font:getWidth(o.text) end
	if not (o.size and o.size.y or o.height) then
		o.height = #(select(font:getWrap(o.text, o.width), 2) or "1") * font:getHeight()
	end
	
	Label.super.new(self, o)
end

function Label:draw()
	self:clearRect()
	
	love.graphics.setColor(VieWS.PALETTE[self.color])
	love.graphics.printf(self.text, 0, 0, self.size.x, "center")
end

return Label
