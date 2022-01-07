local AlwaysOnTop = {}

function AlwaysOnTop.setup()
	view:addWindow(Controls.Window {
		size = Vec2(64, 64),
		
		setup = AlwaysOnTop.setupComponents,
		
		onTop = true,
	})
end

function AlwaysOnTop.setupComponents(wSelf)
	myButton = Controls.Button {
		position = Vec2(2, 2),
		size = Vec2(16, 14),
		text = "Hi",
	}
	myButton.mouseClick = function(cSelf, m)
		windowMakerWindow()
	end
	
	wSelf:addControl(myButton)
end

return AlwaysOnTop
