local Bar = {}

function Bar.setup(vSelf)
	local wSelf = Controls.Window {
		title = "OS Menu",
		
		position = Vec2(0, 0),
		size = Vec2(vSelf.size.x, 12),
		
		border = Sides(0, 0, 1, 0),
		
		onTop = true,
	}
	
	local myButton = Controls.Button {
		position = Vec2(8, -1),
		
		height = 14,
		
		text = "New",
	}
	myButton.mouseClick = function(cSelf, m)
		require("apps/launcher").setup(vSelf)
	end
	wSelf:addControl(myButton)
	
	vSelf:addWindow(wSelf)
end

return Bar
