local About = {}

function About.setup()
	view:addWindow(Controls.Window {
		title = "About VieWS",
		
		-- x = 16 + math.random(0, view.size.x),
		-- y = 32 + math.random(0, view.size.y),
		
		size = Vec2(128, 64),
		
		setup = About.setupComponents,
		
		border = Sides(Controls.Window.SideWidth * 3, Controls.Window.SideWidth, Controls.Window.SideWidth),
	})
end

function About.setupComponents(wSelf)
	local img = love.graphics.newImage("resources/logo.png")
	
	local logoImage = Controls.Image {
		position = Vec2(4, 6),
		image = img,
		color = 1,
	}
	local logoImageGhost = Controls.Image {
		position = Vec2(4, 6) + 1,
		image = img,
		color = 3,
	}
	
	logoImageGhost.mouseEnter = function(m)
		self.redraw = false
		logoImage:doRedraw()
	end
	wSelf:addControl(logoImageGhost)
	wSelf:addControl(logoImage)
	
	local versionLabel = Controls.Label {
		position = Vec2(94, 14),
		text = "v0.1?",
		color = 1,
	}
	wSelf:addControl(versionLabel)
	
	local nameLabel = Controls.Label {
		position = Vec2(4, 24),
		text = "V360 Window System",
	}
	wSelf:addControl(nameLabel)
	
	local authorLabel = Controls.Label {
		position = Vec2(4, 34),
		text = "By V360 (@V360dev)",
	}
	wSelf:addControl(authorLabel)
	
	local githubButton = Controls.Button {
		position = Vec2(4, 44),
		size = Vec2(58, 16),
		text = "Nothing",
	}
	--[[githubButton.mouseClick = function(cSelf, m)
		love.system.openURL("https://thev360.github.io/VieWS/")
	end]]
	wSelf:addControl(githubButton)
	
	local closeButton = Controls.Button {
		position = Vec2(66, 44),
		size = Vec2(58, 16),
		text = "Close",
	}
	closeButton.mouseClick = function(cSelf, m)
		wSelf:close()
	end
	wSelf:addControl(closeButton)
end

return About
