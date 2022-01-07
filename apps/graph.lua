local Graph = {}

function Graph.setup()
	view:addWindow(Controls.Window {
		title = "Panel test",
		
		size = Vec2(256, 128),
		
		setup = Graph.setupComponents
	})
end

function Graph.setupComponents(wSelf)
	local somethingWindow = Controls.Window {
		title = "smaller window",
		
		position = Vec2(120, 16),
		size = Vec2(128, 64),
		
		setup = function(wSelf)
			local somethingButton = Controls.Button {
				position = Vec2(8, 8),
				text = "Something"
			}
			somethingButton.mouseClick = function(cSelf, m)
				love.window.showMessageBox("hi","hello")
			end
			
			wSelf:addControl(somethingButton)
		end
	}
	
	local horrible1 = Controls.Panel {
		position = Vec2(4, 4),
		size = Vec2(96, 96),
		
		color = 2
	}
	
	local horrible2 = Controls.Panel {
		position = Vec2(4, 4),
		size = Vec2(64, 64),
		
		color = 3
	}
	
	local logoImage = Controls.Image {
		position = Vec2(4, 4),
		image = love.graphics.newImage("resources/colorTest.png")
	}
	logoImage.mouseClick = function(cSelf, m)
		love.window.showMessageBox("hi","hello")
	end
	horrible2:addControl(logoImage)
	
	horrible1:addControl(horrible2)
	
	wSelf:addControl(somethingWindow)
	wSelf:addControl(horrible1)
end

return Graph
