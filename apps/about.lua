local About = {}

function About.setup()
	view:addWindow(Controls.Window {
		title = "About VieWS",
		
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
	wSelf:addControl(logoImage)
	
	local versionLabel = Controls.Label {
		position = Vec2(94, 14),
		text = "0.1",
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
	
	local moreButton = Controls.Button {
		position = Vec2(4, 44),
		size = Vec2(58, 16),
		text = "More",
	}
	moreButton.mouseClick = function(cSelf, m)
		About.setup()
	end
	wSelf:addControl(moreButton)
	
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
