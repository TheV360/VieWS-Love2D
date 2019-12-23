local Graph = {}

function Graph.setup()
	view:addWindow(Controls.Window{
		title = "Graph, or more accurately, Panel test",
		
		x = 16,
		y = 16,
		
		width = 256,
		height = 128,
		
		setup = Graph.setupComponents
	})
end

function Graph.setupComponents(wSelf)
	somethingWindow = Controls.Window{
		title = "smaller window",
		
		x = 64,
		y = 16,
		
		width = 128,
		height = 64,
		
		setup = function(wSelf)
			somethingButton = Controls.Button{
				x = 8,
				y = 8,
				text = "Something"
			}
			somethingButton.mouseClick = function(cSelf, m)
				love.window.showMessageBox("hi")
			end
			
			wSelf:addControl("somethingWindow", somethingWindow)
		end
	}
	
	horrible1 = Controls.Panel{
		x = 4,
		y = 4,
		
		width = 96,
		height = 96,
		
		color = {0.25, 0.5, 1}
	}
	
	horrible2 = Controls.Panel{
		x = 4,
		y = 4,
		
		width = 64,
		height = 64,
		
		color = {1, 0.25, 0.5}
	}
	
	logoImage = Controls.Image{
		x = 4,
		y = 4,
		image = love.graphics.newImage("resources/logo.png")
	}
	horrible2:addControl("logoImage", logoImage)
	
	horrible1:addControl("horrible2", horrible2)
	
	wSelf:addControl("somethingWindow", somethingWindow)
	wSelf:addControl("horrible1", horrible1)
end

return Graph
