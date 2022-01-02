local AlwaysOnTop = {}

function AlwaysOnTop.setup()
	view:addWindow(Controls.Window{
		-- x = 8,
		-- y = 8,
		
		width = 64,
		height = 64,
		
		setup = AlwaysOnTop.setupComponents,
		
		onTop = true,
	})
end

function AlwaysOnTop.setupComponents(wSelf)
	myButton = Controls.Button{
		x = 2,
		y = 2,
		text = "Hi",
		
		height = 14,
	}
	myButton.mouseClick = function(cSelf, m)
		windowMakerWindow()
	end
	
	wSelf:addControl(myButton)
end

return AlwaysOnTop
