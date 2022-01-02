local Bar = {}

function Bar.setup()
	view:addWindow(Controls.Window{
		title = "OS Menu",
		
		x = 0,
		y = 0,
		
		width = window.screen.width,
		height = 12,
		
		border = Sides(0, 0, 1, 0),
		
		setup = Bar.setupComponents,
		
		onTop = true,
	})
end

function Bar.setupComponents(wSelf)
	myButton = Controls.Button{
		x = 8,
		y = -1,
		text = "New",
		
		height = 14,
	}
	myButton.mouseClick = function(cSelf, m)
		windowMakerWindow()
	end
	
	wSelf:addControl(myButton)
end

return Bar
