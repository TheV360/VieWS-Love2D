local PixelGrid = Controls.Control:extend()
	
function PixelGrid:getLocalCoords(m)
	return m.position - self.position - self.parent.position
end

function PixelGrid:new(o)
	PixelGrid.super.new(self, o)
	
	self.cels = o.cels or Size(8, 8)
	self.celSize = o.celSize or Size(8, 8)
	
	self.celData = {}
	local index = 1
	for y = 1, self.cels.y do
		for x = 1, self.cels.x do
			self.celData[index] = o.celData and o.celData[index] or #VieWS.PALETTE
			index = index + 1
		end
	end
	
	self.hoverX = -1
	self.hoverY = -1
	self.hoverIndex = nil
	
	self.foolishGetData = o.foolishGetData or function() return 1 end
end

function PixelGrid:draw()
	self:clearRect()
	
	love.graphics.setColor(VieWS.PALETTE[1])
	self:drawRect("line")
	for vLine = 1, self.cels.y - 1 do
		local x = vLine * self.celSize.x + 1
		love.graphics.line(x, 1, x, self.cels.y * self.celSize.y + 1)
	end
	for hLine = 1, self.cels.x - 1 do
		local y = hLine * self.celSize.y + 1
		love.graphics.line(1, y, self.cels.x * self.celSize.x + 1, y)
	end
	
	if self.hover then
		love.graphics.setColor(VieWS.PALETTE[self.foolishGetData()])
		love.graphics.rectangle(
			"fill",
			1 + self.hoverX * self.celSize.x, 1 + self.hoverY * self.celSize.y,
			self.celSize.x - 1, self.celSize.y - 1
		)
	end
	
	local index = 1
	for y = 1, self.cels.y do
		for x = 1, self.cels.x do
			love.graphics.setColor(VieWS.PALETTE[self.celData[index] or 1])
			love.graphics.rectangle(
				"fill",
				(x - 1) * self.celSize.x + 2, (y - 1) * self.celSize.y + 2,
				self.celSize.x - 3, self.celSize.y - 3
			)
			index = index + 1
		end
	end
end

function PixelGrid:mouse(m)
	view:switchCursor("hand")
	
	local newX, newY = self:getLocalCoords(m):unpack()
	newX = Util.clamp(0, math.floor(newX / self.celSize.x), self.cels.x - 1)
	newY = Util.clamp(0, math.floor(newY / self.celSize.y), self.cels.y - 1)
	
	-- redraw if mouse moved to new cel
	if newX ~= self.hoverX or newY ~= self.hoverY then
		self.hoverX, self.hoverY = newX, newY
		self.hoverIndex = Util.clamp(0, newY * self.cels.x + newX, #self.celData - 1) + 1
		self.redraw = true
	end
end
function PixelGrid:mouseDown(m)
	self.celData[self.hoverIndex] = self.foolishGetData()
	self.redraw = true
end
function PixelGrid:mouseEnter(m)
	local newX, newY = self:getLocalCoords(m):unpack()
	newX = Util.clamp(0, math.floor(newX / self.celSize.x), self.cels.x - 1)
	newY = Util.clamp(0, math.floor(newX / self.celSize.y), self.cels.y - 1)
	
	self.hoverX, self.hoverY = newX, newY
	self.hoverIndex = Util.clamp(0, newY * self.cels.x + newX, #self.celData - 1) + 1
end
function PixelGrid:mouseExit(m)
	self.hoverX = -1
	self.hoverY = -1
	self.hoverIndex = nil
end

return PixelGrid
