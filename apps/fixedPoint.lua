local FixedPoint = {}

function FixedPoint.setup(vSelf, o)
	o = o or {}
	
	o.bits = o.bits or 8
	
	vSelf:addWindow(Controls.Window {
		title = "Fixed Point",
		
		size = Vec2(o.bits * 12 + 2, 54),
		
		setup = function(wSelf)
			local value = 0
			local mask = bit.lshift(1, o.bits) - 1
			local fontHeight = vSelf.font:getHeight("_")
			
			-- gets the bit at position n
			local function bit_at(val, n) return bit.band(bit.rshift(val, n - 1), 1) end
			
			-- flips the bit at position n
			local function bit_to(val, n) return bit.bxor(val, bit.lshift(1, n - 1)) end
			
			-- adds the specified value, wrapping if overflowing
			local function bit_add(val, other)
				return bit.band(val + other, mask)
			end
			-- subtracts the specified value, wrapping if overflowing
			local function bit_sub(val, other)
				return bit.band(val - other, mask)
			end
			
			-- displays the number
			local numberLabel = Controls.Label {
				position = Vec2(4, 4),
				size = Vec2(wSelf.size.x - 8, fontHeight),
				
				text = "0",
			}
			local displayNumber, displayBits -- will be defined later for wacky closure shenanigans
			wSelf:addControl(numberLabel)
			
			-- array of "bit buttons", which are buttons that either display 1 or 0
			-- depending on their respective bit index into the value.
			-- you can click them to flip the bit they represent!
			local bitsButtons = {}
			
			for i = 1, o.bits do
				local c = Controls.Button {
					position = Vec2(wSelf.size.x - i * 12, 26),
					text = "0",
				}
				c.mouseClick = function(self, m)
					value = bit_to(value, i)
					displayBits()
					displayNumber()
				end
				wSelf:addControl(c)
				bitsButtons[i] = c
			end
			
			-- slices the number into two parts: an integral part and a real part.
			-- depending on the position of the slider, anything to the left of the
			-- head is integral and everything to the right of the head is real.
			local realSlider = Controls.Slider {
				position = Vec2(2, 16),
				size = Vec2(wSelf.size.x - 4, 0),
				
				min = 0, max = o.bits,
				step = 1,
				value = 0,
				direction = 'rightToLeft',
				
				applied = function(self) displayNumber() end,
			}
			wSelf:addControl(realSlider)
			
			-- data for the buttons
			local incrementButtons = {
				-- [1]: x position (negative means anchored to the right)
				-- [2]: label
				-- [3]: how it changes the value when clicked
				{  1, "I++", function(v) return bit_add(v, bit.lshift(1, realSlider.value)) end },
				{  2, "I--", function(v) return bit_sub(v, bit.lshift(1, realSlider.value)) end },
				{ -2, "A++", function(v) return bit_add(v, 1) end },
				{ -1, "A--", function(v) return bit_sub(v, 1) end },
			}
			
			for i, d in ipairs(incrementButtons) do
				local x
				if d[1] < 0 then x = wSelf.size.x + d[1] * 24
				else             x = (d[1] - 1) * 24 + 2 end
				local c = Controls.Button {
					position = Vec2(x, wSelf.size.y - fontHeight - 6),
					text = d[2],
				}
				c.mouseClick = function(self, m)
					value = d[3](value) displayBits() displayNumber()
				end
				wSelf:addControl(c)
			end
			
			-- utility function to update the label
			displayNumber = function()
				numberLabel.text = "".. value / math.pow(2, realSlider.value)
				numberLabel.redraw = true
			end
			
			-- utility function to update all buttons
			displayBits = function()
				for i, c in ipairs(bitsButtons) do
					c.text = bit_at(value, i)
					c.redraw = true
				end
			end
		end,
	})
end

-- TODO: put that ↑ all into another function here to prevent indent hell

return FixedPoint
