Button = Control:extend()

function Button:new(o)
	self.text = o.text or "Button"
	self.color = o.color or {0, 0, 0, 1}
	
	if not (o.size and o.size.width  or o.width ) then o.width  = view.font:getWidth (o.text) + 4 end
	if not (o.size and o.size.height or o.height) then o.height = view.font:getHeight(o.text) + 4 end
	
	Button.super.new(self, o)
end

function Button:draw()
	love.graphics.setColor(self.color)
	love.graphics.rectangle("line", 0.5, 0.5, self.size.width - 1, self.size.height - 1)
	love.graphics.print(
		self.text,
		math.ceil ((self.size.width  - view.font:getWidth (self.text)) / 2),
		math.floor((self.size.height - view.font:getHeight(         )) / 2)
	)
end

return Button
