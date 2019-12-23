local About = {}

function About.setup()
	view:addWindow(Controls.Window{
		title = "About VieWS",
		
		x = 16 + math.random(0, 256),
		y = 32 + math.random(0, 128),
		
		width = 128,
		height = 64,
		
		setup = About.setupComponents
	})
end

function About.setupComponents(wSelf)
	logoImage = Controls.Image{
		x = 4,
		y = 6,
		image = love.graphics.newImage("resources/logo.png")
	}
	wSelf:addControl("logoImage", logoImage)
	
	versionLabel = Controls.Label{
		x = 94,
		y = 14,
		
		text = "v0.1?",
		color = {0.5, 0.5, 0.5, 1}
	}
	wSelf:addControl("versionLabel", versionLabel)
	
	nameLabel = Controls.Label{
		x = 4,
		y = 24,
		text = "V360 Window System"
	}
	wSelf:addControl("nameLabel", nameLabel)
	
	authorLabel = Controls.Label{
		x = 4,
		y = 34,
		text = "By V360 (v360.dev)"
	}
	wSelf:addControl("authorLabel", authorLabel)
	
	githubButton = Controls.Button{
		x = 4,
		y = 44,
		
		width = 58,
		height = 16,
		
		text = "Website"
	}
	githubButton.mouseClick = function(cSelf, m)
		love.system.openURL("https://thev360.github.io/VieWS/")
	end
	wSelf:addControl("githubButton", githubButton)
	
	closeButton = Controls.Button{
		x = 66,
		y = 44,
		
		width = 58,
		height = 16,
		
		text = "Close"
	}
	closeButton.mouseClick = function(cSelf, m)
		wSelf:close()
	end
	wSelf:addControl("closeButton", closeButton)
end

return About
