local PixelGrid = Controls.Control:extend()

function PixelGrid:new(o)
	PixelGrid.super.new(self, o)
	
	self.cells = o.cells or Size(8, 8)
	self.cellSize = o.cellSize or Size(8, 8)
	
	self.cellData = {}
	local index = 1
	for y = 1, self.cells.y do
		for x = 1, self.cells.x do
			self.cellData[index] = o.cellData and o.cellData[index] or #VieWS.PALETTE
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
	for vLine = 1, self.cells.x - 1 do
		local x = vLine * self.cellSize.x + 1
		love.graphics.line(x, 1, x, self.cells.y * self.cellSize.y + 1)
	end
	for hLine = 1, self.cells.y - 1 do
		local y = hLine * self.cellSize.y + 1
		love.graphics.line(1, y, self.cells.x * self.cellSize.x + 1, y)
	end
	
	local index = 1
	for y = 1, self.cells.y do
		for x = 1, self.cells.x do
			love.graphics.setColor(VieWS.PALETTE[self.cellData[index] or 1])
			love.graphics.rectangle(
				"fill",
				(x - 1) * self.cellSize.x + 1, (y - 1) * self.cellSize.y + 1,
				self.cellSize.x - 1, self.cellSize.y - 1
			)
			index = index + 1
		end
	end
	
	if self.hover then
		love.graphics.setColor(VieWS.PALETTE[self.foolishGetData()])
		love.graphics.rectangle(
			"line",
			1.5 + self.hoverX * self.cellSize.x,
			1.5 + self.hoverY * self.cellSize.y,
			self.cellSize.x - 2, self.cellSize.y - 2
		)
	end
end

function PixelGrid:mouse(m)
	view:switchCursor("hand")
	
	local newX, newY = m.position:unpack()
	-- TODO: ewww.
	newX = Util.clamp(0, math.floor(newX / self.cellSize.x), self.cells.x - 1)
	newY = Util.clamp(0, math.floor(newY / self.cellSize.y), self.cells.y - 1)
	
	-- redraw if mouse moved to new cel
	if newX ~= self.hoverX or newY ~= self.hoverY then
		self.hoverX, self.hoverY = newX, newY
		self.hoverIndex = Util.clamp(0, newY * self.cells.x + newX, #self.cellData - 1) + 1
		self.redraw = true
	end
end
function PixelGrid:mouseDown(m)
	self.cellData[self.hoverIndex] = self.foolishGetData()
	self.redraw = true
end
function PixelGrid:mouseEnter(m)
	local newX, newY = m.position:unpack()
	newX = Util.clamp(0, math.floor(newX / self.cellSize.x), self.cells.x - 1)
	newY = Util.clamp(0, math.floor(newX / self.cellSize.y), self.cells.y - 1)
	
	self.hoverX, self.hoverY = newX, newY
	self.hoverIndex = Util.clamp(0, newY * self.cells.x + newX, #self.cellData - 1) + 1
end
function PixelGrid:mouseExit(m)
	self.hoverX = -1
	self.hoverY = -1
	self.hoverIndex = nil
end

return PixelGrid
