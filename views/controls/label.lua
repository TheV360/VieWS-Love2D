Label = Control:extend()

function Label:new(o)
	self.text = o.text or "Label"
	self.color = o.color or {0, 0, 0, 1}
	
	if not (o.size and o.size.width  or o.width ) then o.width  = font:getWidth (o.text) end
	if not (o.size and o.size.height or o.height) then o.height = font:getHeight(o.text) end
	
	Label.super.new(self, o)
end

function Label:draw()
	love.graphics.setColor(self.color)
	love.graphics.print(self.text)
end

return Label
