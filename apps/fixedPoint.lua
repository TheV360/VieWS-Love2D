local FixedPoint = {}

function FixedPoint.setup()
	view:addWindow(Controls.Window {
		title = "Fixed Point",
		
		size = Vec2(98, 40),
		
		setup = FixedPoint.setupApp,
	})
end

FixedPoint.BITS = 8

function FixedPoint.setupApp(wSelf)
	local value = 0
	local fontHeight = view.font:getHeight("_")
	local function bit_at(val, n) return bit.band(bit.rshift(val, n - 1), 1) end
	local function bit_to(val, n) return bit.bxor(val, bit.lshift(1, n - 1)) end
	
	local numberLabel = Controls.Label {
		position = Vec2(4, 4),
		size = Vec2(wSelf.size.x - 8, fontHeight),
		
		text = "0",
	}
	local displayNumber
	wSelf:addControl(numberLabel)
	
	local bitsButtons = {}
	
	for i = 1, FixedPoint.BITS do
		local c = Controls.Button {
			position = wSelf.size - Vec2(i * 12, fontHeight + 6),
			text = "0",
		}
		c.mouseClick = function(m)
			value = bit_to(value, i)
			c.text = bit_at(value, i)
			c.redraw = true
			displayNumber()
		end
		wSelf:addControl(c)
		bitsButtons[i] = c
	end
	
	local realSlider = Controls.Slider {
		position = Vec2(2, wSelf.size.y - fontHeight - 16),
		size = Vec2(wSelf.size.x - 4, 0),
		
		min = 0, max = FixedPoint.BITS,
		step = 1,
		value = 0,
		direction = 'rightToLeft',
		
		applied = function(self) displayNumber() end,
	}
	wSelf:addControl(realSlider)
	
	displayNumber = function()
		numberLabel.text = "".. value / math.pow(2, realSlider.value)
		numberLabel.redraw = true
	end
end

return FixedPoint
