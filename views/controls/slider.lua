local Slider = Controls.Control:extend()

function Slider:new(o)
	Slider.super.new(self, o)
	
	self.range = {
		min =   o.min   or (o.range and o.range.min)   or 0,
		max =   o.max   or (o.range and o.range.max)   or 1,
		step =  o.step  or (o.range and o.range.step)  or 0.1,
		steps = o.steps or (o.range and o.range.steps) or false,
	}
	
	self.range.min, self.range.max = unpack{
		math.min(self.range.min, self.range.max),
		math.max(self.range.min, self.range.max),
	}
	
	if self.range.steps then self.range.step = (self.range.max - self.range.min) / self.range.steps end
	
	self.direction = o.direction or 'leftToRight'
	self.vertical = self.direction == 'topToBottom' or self.direction == 'bottomToTop'
	self.inverted = self.direction == 'rightToLeft' or self.direction == 'bottomToTop'
	
	if self.vertical then
		self.size.x = 7
	else
		self.size.y = 7
	end
	
	self.progress = o.progress or false
	
	self.value = o.value or 0
	self.displayValue = self.value
	
	self.applied = o.applied
end

function Slider:draw()
	self:clearRect()
	
	love.graphics.setColor(VieWS.PALETTE[1])
	local sigAxis = (self.vertical and self.size.y or self.size.x) - 1
	local dispVal = self.displayValue
	local val = self.value
	
	if self.inverted then
		dispVal = Util.invLerp(self.range.max, self.range.min, dispVal)
		val = Util.invLerp(self.range.max, self.range.min, val)
	else
		dispVal = Util.invLerp(self.range.min, self.range.max, dispVal)
		val = Util.invLerp(self.range.min, self.range.max, val)
	end
	
	dispVal = Util.clampLerp(0, sigAxis, dispVal)
	val = Util.clampLerp(0, sigAxis, val)
	
	-- yes, minLen == intSteps
	local intSteps = (self.range.max - self.range.min) / self.range.step
	if intSteps > math.min(64, bit.rshift(self.size.x, 2)) then intSteps = 1 end
	
	local t = self.hover and "◆" or "◇"
	if self.vertical then
		if self.progress then
			love.graphics.setColor(VieWS.PALETTE[2])
			if self.inverted then
				love.graphics.rectangle("fill", 2, dispVal + 2, 3, self.size.y - dispVal - 3)
			else
				love.graphics.rectangle("fill", 2, 0, 3, dispVal - 1)
			end
			love.graphics.setColor(VieWS.PALETTE[1])
		end
		
		for i = 0, intSteps do -- not 1->i because inclusive
			love.graphics.points(self.size.x / 2, Util.round(i / intSteps * sigAxis) + 0.5)
		end
		
		love.graphics.print(t, 1, dispVal - 3)
	else
		if self.progress then
			love.graphics.setColor(VieWS.PALETTE[2])
			if self.inverted then
				love.graphics.rectangle("fill", dispVal + 2, 2, self.size.x - dispVal - 3, 3)
			else
				love.graphics.rectangle("fill", 0, 2, dispVal - 1, 3)
			end
			love.graphics.setColor(VieWS.PALETTE[1])
		end
		
		for i = 0, intSteps do -- not 1->i because inclusive
			love.graphics.points(Util.round(i / intSteps * sigAxis) + 0.5, self.size.y / 2)
		end
		love.graphics.print(t, dispVal - 2, 0)
	end
end

function Slider:mouse(m)
	view:switchCursor('hand')
end

function Slider:mouseDown(m)
	local mSig = self.vertical and m.position.y or m.position.x
	local sigAxis = (self.vertical and self.size.y or self.size.x) - 1
	
	local mProgress = Util.invLerp(0, sigAxis, mSig)
	if self.inverted then mProgress = 1 - mProgress end
	
	self.displayValue = Util.clampLerp(self.range.min, self.range.max, mProgress)
	self.value = Util.round(self.displayValue / self.range.step) * self.range.step
	self.redraw = true
	self.applied(self.value)
end

function Slider:mouseUp(m)
	self.displayValue = self.value
	self.redraw = true
end
Slider.mouseExit = Slider.mouseUp

return Slider
