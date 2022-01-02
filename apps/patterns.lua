local Patterns = {}

function Patterns.setup()
	view:addWindow(Controls.Window{
		title = "Desktop Patterns",
		
		width = 147,
		height = 105,
		
		setup = Patterns.setupApp,
	})
end

function Patterns.setupApp(wSelf)
	local appliedPatternData = {}
	for i = 1, 64 do
		appliedPatternData[i] = view.desktop.patternData[i] or #VieWS.PALETTE
	end
	local appliedPatternFlipH = view.desktop.patternData.flipH or false
	local appliedPatternFlipV = view.desktop.patternData.flipV or false
	
	local selectedColor = 1
	local palettePicker = Controls.Picker{
		x = 8,
		y = 8,
		
		width = 65,
		height = 16,
		
		elements = {
			{ value = 1 },
			{ value = 2 },
			{ value = 3 },
			{ value = 4 }
		},
		
		foolishOnChange = function(v) selectedColor = v end,
	}
	wSelf:addControl(palettePicker)
	
	local patternPixelGrid = Controls.PixelGrid{
		x = 8,
		y = 32,
		
		width = 65,
		height = 65,
		
		cels = Size(8, 8),
		celSize = Size(8, 8),
		
		celData = appliedPatternData,
		
		foolishGetData = function() return selectedColor end,
	}
	wSelf:addControl(patternPixelGrid)
	
	local flipHCheckBox = Controls.CheckBox{
		x = 81,
		y = 8,
		
		width = 58,
		height = 16,
		
		text = "Flip H.",
		
		value = appliedPatternFlipH,
	}
	wSelf:addControl(flipHCheckBox)
	
	local flipVCheckBox = Controls.CheckBox{
		x = 81,
		y = 32,
		
		width = 58,
		height = 16,
		
		text = "Flip V.",
		
		value = appliedPatternFlipV,
	}
	wSelf:addControl(flipVCheckBox)
	
	local clearButton = Controls.Button{
		x = 81,
		y = 56,
		
		width = 29,
		height = 16,
		
		text = "Fill",
	}
	clearButton.mouseDown = function(m)
		for i = 1, #patternPixelGrid.celData do
			patternPixelGrid.celData[i] = selectedColor
		end
		patternPixelGrid.redraw = true
	end
	wSelf:addControl(clearButton)
	
	local resetButton = Controls.Button{
		x = 110,
		y = 56,
		
		width = 29,
		height = 16,
		
		text = "Orig",
	}
	resetButton.mouseDown = function(m)
		for i = 1, #patternPixelGrid.celData do
			patternPixelGrid.celData[i] = appliedPatternData[i]
		end
		patternPixelGrid.redraw = true
		
		flipHCheckBox:set(appliedPatternFlipH)
		flipVCheckBox:set(appliedPatternFlipV)
	end
	wSelf:addControl(resetButton)
	
	local applyButton = Controls.Button{
		x = 81,
		y = 81,
		
		width = 58,
		height = 16,
		
		text = "Apply",
	}
	applyButton.mouseDown = function(cSelf, m)
		for i = 1, #patternPixelGrid.celData do
			appliedPatternData[i] = patternPixelGrid.celData[i]
		end
		
		appliedPatternData.flipH = flipHCheckBox.value
		appliedPatternData.flipV = flipVCheckBox.value
		
		view.desktop:setPattern(appliedPatternData)
	end
	wSelf:addControl(applyButton)
end
	
return Patterns
