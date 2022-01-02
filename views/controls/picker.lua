local PickerControl = Controls.Control:extend()
	
function PickerControl:new(o)
	PickerControl.super.new(self, o)
	
	self.elements = o.elements or {{ value = "Picker" }}
	
	self.celSize = Size(math.floor((self.size.width - 1) / #self.elements), self.size.height)
	
	self.hoverIndex = nil
	
	self.value = self.elements[1]
	self.valueIndex = 1
	
	self.foolishOnChange = o.foolishOnChange or function(v) end
end

function PickerControl:draw()
	self:clearRect()
	
	love.graphics.setColor(VieWS.PALETTE[2])
	self:drawRect("line")
	
	love.graphics.setColor(VieWS.PALETTE[1])
	for i = 1, #self.elements do
		local x = self.celSize.width * (i - 1)
		if i == self.valueIndex or i == self.hoverIndex then
			love.graphics.rectangle(
				"fill",
				x, 0,
				self.celSize.width + 1, self.celSize.height
			)
		else
			love.graphics.rectangle(
				"line",
				x + 0.5, 0.5,
				self.celSize.width, self.celSize.height - 1
			)
		end
	end
	
	for i = 1, #self.elements do
		love.graphics.setColor(VieWS.PALETTE[self.elements[i].value])
		love.graphics.rectangle(
			"fill",
			self.celSize.width * (i - 1) + 2, 2,
			self.celSize.width - 3, self.celSize.height - 4
		)
	end
end

function PickerControl:mouse(m)
	view:switchCursor("hand")
	
	local hackX = m.x - self.position.x - self.parent.position.x
	
	-- redraw if mouse moved to new item
	local hoverIndex = math.floor(hackX / self.celSize.width) + 1
	if self.hoverIndex and hoverIndex ~= self.hoverIndex then
		self.redraw = true
		self.hoverIndex = Util.clamp(1, hoverIndex, #self.elements)
	end
end
function PickerControl:mouseDown(m)
	self.valueIndex = self.hoverIndex
	self.value = self.elements[self.valueIndex].value
	self.foolishOnChange(self.value)
	self.redraw = true
end
function PickerControl:mouseEnter(m)
	local hackX = m.x - self.position.x - self.parent.position.x
	local hoverIndex = math.floor(hackX / self.celSize.width) + 1
	self.hoverIndex = Util.clamp(1, hoverIndex, #self.elements)
end
function PickerControl:mouseExit(m)
	self.hoverIndex = false
end

return PickerControl
