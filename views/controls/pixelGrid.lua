local PixelGrid = Controls.Control:extend()
	
function PixelGrid:getLocalCoords(m)
	return m.x - self.position.x - self.parent.position.x, m.y - self.position.y - self.parent.position.y
end

function PixelGrid:new(o)
	PixelGrid.super.new(self, o)
	
	self.cels = o.cels or Size(8, 8)
	self.celSize = o.celSize or Size(8, 8)
	
	self.celData = {}
	local index = 1
	for y = 1, self.cels.height do for x = 1, self.cels.width do
		self.celData[index] = o.celData and o.celData[index] or #VieWS.PALETTE
		index = index + 1
	end end
	
	self.hoverX = -1
	self.hoverY = -1
	self.hoverIndex = nil
	
	self.foolishGetData = o.foolishGetData or function() return 1 end
end

function PixelGrid:draw()
	self:clearRect()
	
	love.graphics.setColor(VieWS.PALETTE[1])
	self:drawRect("line")
	for vLine = 1, self.cels.height - 1 do
		local x = vLine * self.celSize.width + 1
		love.graphics.line(x, 1, x, self.cels.height * self.celSize.height + 1)
	end
	for hLine = 1, self.cels.width - 1 do
		local y = hLine * self.celSize.height + 1
		love.graphics.line(1, y, self.cels.width * self.celSize.width + 1, y)
	end
	
	if self.hover then
		love.graphics.setColor(VieWS.PALETTE[self.foolishGetData()])
		love.graphics.rectangle(
			"fill",
			1 + self.hoverX * self.celSize.width, 1 + self.hoverY * self.celSize.height,
			self.celSize.width - 1, self.celSize.height - 1
		)
	end
	
	local index = 1
	for y = 1, self.cels.height do for x = 1, self.cels.width do
		love.graphics.setColor(VieWS.PALETTE[self.celData[index] or 1])
		love.graphics.rectangle(
			"fill",
			(x - 1) * self.celSize.width + 2, (y - 1) * self.celSize.height + 2,
			self.celSize.width - 3, self.celSize.height - 3
		)
		index = index + 1
	end end
end

function PixelGrid:mouse(m)
	window:switchCursor("hand")
	
	local newX, newY = self:getLocalCoords(m)
	newX = Util.clamp(0, math.floor(newX / self.celSize.width ), self.cels.width  - 1)
	newY = Util.clamp(0, math.floor(newY / self.celSize.height), self.cels.height - 1)
	
	-- redraw if mouse moved to new cel
	if newX ~= self.hoverX or newY ~= self.hoverY then
		self.hoverX, self.hoverY = newX, newY
		self.hoverIndex = Util.clamp(0, newY * self.cels.width + newX, #self.celData - 1) + 1
		self.redraw = true
	end
end
function PixelGrid:mouseDown(m)
	self.celData[self.hoverIndex] = self.foolishGetData()
	self.redraw = true
end
function PixelGrid:mouseEnter(m)
	local newX, newY = self:getLocalCoords(m)
	newX = Util.clamp(0, math.floor(newX / self.celSize.width ), self.cels.width  - 1)
	newY = Util.clamp(0, math.floor(newX / self.celSize.height), self.cels.height - 1)
	
	self.hoverX, self.hoverY = newX, newY
	self.hoverIndex = Util.clamp(0, newY * self.cels.width + newX, #self.celData - 1) + 1
end
function PixelGrid:mouseExit(m)
	self.hoverX = -1
	self.hoverY = -1
	self.hoverIndex = nil
end

return PixelGrid
