local Palette = {}

function Palette.setup()
	view:addWindow(Controls.Window {
		title = "Palette Editor",
		
		size = Vec2(96, 64),
		
		setup = Palette.setupApp,
	})
end

function Palette.setupApp(wSelf)
	local sliders = {}
	local selectedColor = 1
	local palettePicker
	
	for i = 1, 3 do
		local sliderLabel = Controls.Label {
			x = 2,
			y = i * 16,
			
			text = ({"Red", "Green", "Blue"})[i],
		}
		
		local sliderControl = Controls.Slider {
			x = 36,
			y = i * 16,
			
			width = math.ceil(wSelf.size.x / 2),
			-- height = math.ceil(wSelf.size.y / 2) + 4,
			
			min = 0, max = 1,
			steps = 5,
			value = VieWS.PALETTE[selectedColor][i],
			direction = 'leftToRight',
			progress = true,
			
			applied = function(v)
				VieWS.PALETTE[selectedColor][i] = v
				view:switchPalette(VieWS.PALETTE)
			end,
		}
		
		sliders[i] = { control = sliderControl, label = sliderLabel }
		wSelf:addControl(sliderControl)
		wSelf:addControl(sliderLabel)
	end
	
	palettePicker = Controls.Picker {
		position = Vec2(2, 2),
		size = Vec2(89, 8),
		
		elements = {
			{ value = 1 },
			{ value = 2 },
			{ value = 3 },
			{ value = 4 }
		},
		
		foolishOnChange = function(v)
			selectedColor = v
			for i = 1, 3 do
				sliders[i].control.value = VieWS.PALETTE[v][i]
				sliders[i].control.displayValue = VieWS.PALETTE[v][i]
				sliders[i].control.redraw = true
				sliders[i].control.applied(sliders[i].control.value)
			end
		end,
	}
	wSelf:addControl(palettePicker)
end

return Palette
