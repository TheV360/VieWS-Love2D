local About = {}

function About.setup()
	view:addWindow(Controls.Window{
		title = "About VieWS",
		
		-- x = 16 + math.random(0, window.screen.width),
		-- y = 32 + math.random(0, window.screen.height),
		
		width = 128,
		height = 64,
		
		setup = About.setupComponents,
		
		border = Sides(Controls.Window.SideWidth * 3, Controls.Window.SideWidth, Controls.Window.SideWidth),
	})
end

function About.setupComponents(wSelf)
	local logoImage = Controls.Image{
		x = 4,
		y = 6,
		image = love.graphics.newImage("resources/logo.png"),
	}
	wSelf:addControl(logoImage)
	
	local versionLabel = Controls.Label{
		x = 94,
		y = 14,
		
		text = "v0.1?",
		color = 1,
	}
	wSelf:addControl(versionLabel)
	
	local nameLabel = Controls.Label{
		x = 4,
		y = 24,
		text = "V360 Window System",
	}
	wSelf:addControl(nameLabel)
	
	local authorLabel = Controls.Label{
		x = 4,
		y = 34,
		text = "By V360 (v360.dev)",
	}
	wSelf:addControl(authorLabel)
	
	local githubButton = Controls.Button{
		x = 4,
		y = 44,
		
		width = 58,
		height = 16,
		
		text = "Website",
	}
	githubButton.mouseClick = function(cSelf, m)
		love.system.openURL("https://thev360.github.io/VieWS/")
	end
	wSelf:addControl(githubButton)
	
	local closeButton = Controls.Button{
		x = 66,
		y = 44,
		
		width = 58,
		height = 16,
		
		text = "Close",
	}
	closeButton.mouseClick = function(cSelf, m)
		wSelf:close()
	end
	wSelf:addControl(closeButton)
end

return About
