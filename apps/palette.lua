local Palette = {}

function Palette.setup()
	view:addWindow(Controls.Window{
		title = "Palette Editor",
		
		width = 96,
		height = 64,
		
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
		
		local sliderControl = Controls.Slider{
			x = 36,
			y = i * 16,
			
			width = math.ceil(wSelf.size.x / 2),
			-- height = math.ceil(wSelf.size.y / 2) + 4,
			
			min = 0, max = 1,
			steps = 5,
			value = 0,
			direction = 'leftToRight',
			progress = true,
			
			applied = function(v)
				VieWS.PALETTE[selectedColor][i] = v
				palettePicker.redraw = true
				-- sliderLabel.text = ""..v
				-- sliderLabel.redraw = true
			end,
		}
		
		sliders[i] = { control = sliderControl, label = sliderLabel }
		wSelf:addControl(sliderControl)
		wSelf:addControl(sliderLabel)
	end
	
	palettePicker = Controls.Picker{
		x = 2,
		y = 2,
		
		width = 89,
		height = 8,
		
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
