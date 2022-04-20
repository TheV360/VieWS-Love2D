-- The desktop! contains icons, except when it doesn't

local Desktop = OptObject:extend()

Desktop.PATTERN_TILES = {
	4,4,4,4,4,4,4,4,
	4,4,4,4,1,4,4,4,
	4,4,4,1,4,1,4,4,
	4,4,1,4,1,4,1,4,
	4,1,4,1,4,1,4,1,
	4,4,1,4,1,4,1,4,
	4,4,4,1,4,1,4,4,
	4,4,4,4,1,4,4,4,
}
Desktop.PATTERN_TILES_MID = {
	3,3,3,3,3,3,3,3,
	3,3,3,3,2,3,3,3,
	3,3,3,2,2,2,3,3,
	3,3,2,2,2,2,2,3,
	3,2,2,2,2,2,2,2,
	3,3,2,2,2,2,2,3,
	3,3,3,2,2,2,3,3,
	3,3,3,3,2,3,3,3,
}
Desktop.PATTERN_SPECKS = {
	2,4,4,4,4,4,4,4,
	4,2,4,4,4,4,4,4,
	4,4,2,4,4,4,4,4,
	4,4,4,4,4,4,4,4,
	4,4,4,4,4,4,2,4,
	4,4,4,4,4,2,4,4,
	4,4,4,4,2,4,4,4,
	4,4,4,4,4,4,4,4,
}
Desktop.PATTERN_ABSENT = {
	3,3,3,3,1,1,1,1,
	3,3,3,3,1,1,1,1,
	3,3,3,3,1,1,1,1,
	3,3,3,3,1,1,1,1,
	1,1,1,1,3,3,3,3,
	1,1,1,1,3,3,3,3,
	1,1,1,1,3,3,3,3,
	1,1,1,1,3,3,3,3,
}
Desktop.PATTERN_BRICKS = {
	2,3,3,3,3,3,3,3,
	1,2,2,2,2,2,2,3,
	1,2,2,2,2,2,2,3,
	1,1,1,1,1,1,1,2,
	3,3,3,3,2,3,3,3,
	2,2,2,3,1,2,2,2,
	2,2,2,3,1,2,2,2,
	1,1,1,2,1,1,1,1,
}
Desktop.PATTERN_BRICKS_XL = {
	width = 16, height = 16,
	2,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,
	1,2,2,2,2,2,2,2,2,2,2,2,2,2,2,3,
	1,2,2,2,2,2,2,2,2,2,2,2,2,2,2,3,
	1,2,2,2,2,2,2,2,2,2,2,2,2,2,2,3,
	1,2,2,2,2,2,2,2,2,2,2,2,2,2,2,3,
	1,2,2,2,2,2,2,2,2,2,2,2,2,2,2,3,
	1,2,2,2,2,2,2,2,2,2,2,2,2,2,2,3,
	1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,2,
	3,3,3,3,3,3,3,3,2,3,3,3,3,3,3,3,
	2,2,2,2,2,2,2,3,1,2,2,2,2,2,2,2,
	2,2,2,2,2,2,2,3,1,2,2,2,2,2,2,2,
	2,2,2,2,2,2,2,3,1,2,2,2,2,2,2,2,
	2,2,2,2,2,2,2,3,1,2,2,2,2,2,2,2,
	2,2,2,2,2,2,2,3,1,2,2,2,2,2,2,2,
	2,2,2,2,2,2,2,3,1,2,2,2,2,2,2,2,
	1,1,1,1,1,1,1,2,1,1,1,1,1,1,1,1,
}
Desktop.PATTERN_RIGHTS = {
	width = 20, height = 20,
	4,4,4,3,4,3,4,3,2,2,2,2,2,3,4,3,4,3,4,4,
	4,4,4,4,3,4,3,4,3,2,2,2,2,2,3,4,3,4,3,4,
	4,4,4,4,4,3,4,3,4,3,2,2,2,2,2,3,4,3,4,3,
	3,4,4,4,4,4,3,4,3,4,3,2,2,2,2,2,3,4,3,4,
	4,3,4,4,4,4,4,3,4,3,4,3,2,2,2,2,2,3,4,3,
	3,4,3,4,4,4,4,4,3,4,3,4,3,2,2,2,2,2,3,4,
	4,3,4,3,4,4,4,4,4,3,4,3,4,3,2,2,2,2,2,3,
	3,4,3,4,3,4,4,4,4,4,3,4,3,4,3,2,2,2,2,2,
	2,3,4,3,4,3,4,4,4,4,4,3,4,3,4,3,2,2,2,2,
	2,2,3,4,3,4,3,4,4,4,4,4,3,4,3,4,3,2,2,2,
	2,2,2,3,4,3,4,3,4,4,4,4,4,3,4,3,4,3,2,2,
	2,2,2,2,3,4,3,4,3,4,4,4,4,4,3,4,3,4,3,2,
	2,2,2,2,2,3,4,3,4,3,4,4,4,4,4,3,4,3,4,3,
	3,2,2,2,2,2,3,4,3,4,3,4,4,4,4,4,3,4,3,4,
	4,3,2,2,2,2,2,3,4,3,4,3,4,4,4,4,4,3,4,3,
	3,4,3,2,2,2,2,2,3,4,3,4,3,4,4,4,4,4,3,4,
	4,3,4,3,2,2,2,2,2,3,4,3,4,3,4,4,4,4,4,3,
	3,4,3,4,3,2,2,2,2,2,3,4,3,4,3,4,4,4,4,4,
	4,3,4,3,4,3,2,2,2,2,2,3,4,3,4,3,4,4,4,4,
	4,4,3,4,3,4,3,2,2,2,2,2,3,4,3,4,3,4,4,4,
	-- flipH = true, flipV = true,
}

function Desktop.MakePatternFromData(data)
	local pWidth  = data.width  or 8
	local pHeight = data.height or 8
	
	local pWrapH = data.flipH and "mirroredrepeat" or "repeat"
	local pWrapV = data.flipV and "mirroredrepeat" or "repeat"
	
	local pIData = love.image.newImageData(pWidth, pHeight)
	local index = 1
	for y = 1, pHeight do for x = 1, pWidth do
		local r, g, b = unpack(VieWS.PALETTE[data[index] or 1])
		pIData:setPixel(x - 1, y - 1, r, g, b, 1)
		index = index + 1
	end end
	
	local patternImg = love.graphics.newImage(pIData)
	patternImg:setWrap(pWrapH, pWrapV)
	
	return patternImg
end

function Desktop:new(o)
	self.parent = o.parent
	
	self:setPattern(o.pattern or Desktop.PATTERN_BRICKS_XL)
end

function Desktop:update()
end

function Desktop:draw()
	love.graphics.draw(self.pattern, self.patternQuad)
end

function Desktop:setPattern(data)
	self.pattern = Desktop.MakePatternFromData(data)
	self.patternData = data
	self.patternQuad = love.graphics.newQuad(0, 0, self.parent.size.x, self.parent.size.y, self.pattern:getDimensions())
end

function Desktop:recreatePattern()
	self.pattern = Desktop.MakePatternFromData(self.patternData)
end

return Desktop
