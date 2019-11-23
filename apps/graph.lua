local Graph = {}

function Graph.setup()
	view:addWindow(Window{
		title = "Graph, or more accurately, Panel test",
		
		x = 16,
		y = 16,
		
		width = 256,
		height = 128,
		
		setup = Graph.setupComponents
	})
end

function Graph.setupComponents(wSelf)
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
	
	wSelf:addControl("horrible1", horrible1)
end

return Graph
