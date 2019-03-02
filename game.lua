require "views/views"

function setup()
	love.mouse.setVisible(false)
	
	view = VieWS{
		width  = window.screen.width,
		height = window.screen.height,
		
		loveFunctions = window.loveFunctions
	}
	
	myWindow = Window{
		title = "About VieWS",
		
		x = 16,
		y = 32,
		
		width = 128,
		height = 64
	}
	
	myWindow.panel:addControl(Image{
		x = 4,
		y = 6,
		image = love.graphics.newImage("resources/logo.png")
	})
	myWindow.panel:addControl(Label{
		x = 94,
		y = 14,
		
		text = "v0.1?",
		color = {0.5, 0.5, 0.5, 1}
	})
	myWindow.panel:addControl(Label{
		x = 4,
		y = 24,
		text = "V360 Window System"
	})
	myWindow.panel:addControl(Label{
		x = 4,
		y = 34,
		text = "By V360 (@0x560360)"
	})
	myWindow.panel:addControl(Button{
		x = 4,
		y = 44,
		
		width = 58,
		height = 16,
		
		text = "Github"
	})
	myWindow.panel:addControl(Button{
		x = 66,
		y = 44,
		
		width = 58,
		height = 16,
		
		text = "Close"
	})
	
	view:addWindow(myWindow)
	view:addWindow(Window{
		title = "Window 2",
		
		x = 48,
		y = 48,
		
		width = 128,
		height = 64,
		
		borderless = true
		-- border = {top = 4, right = 1, bottom = 1, left = 1}
	})
end

function update()
	view:update()
end

function draw()
	view:draw()
end

function makeSnapshot()
	local crumbs = {}
end
