local Bar = {}

function Bar.setup()
	view:addWindow(Controls.Window {
		title = "OS Menu",
		
		position = Vec2(0, 0),
		size = Vec2(view.size.x, 12),
		
		border = Sides(0, 0, 1, 0),
		
		setup = Bar.setupComponents,
		
		onTop = true,
	})
end

function Bar.setupComponents(wSelf)
	myButton = Controls.Button {
		position = Vec2(8, -1),
		
		height = 14,
		
		text = "New",
	}
	myButton.mouseClick = function(cSelf, m)
		windowMakerWindow()
	end
	
	wSelf:addControl(myButton)
end

return Bar
