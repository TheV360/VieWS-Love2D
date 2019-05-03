function windowConstruction(wSelf)
	logoImage = Image{
		x = 4,
		y = 6,
		image = love.graphics.newImage("resources/logo.png")
	}
	wSelf:addControl("logoImage", logoImage)
	
	versionLabel = Label{
		x = 94,
		y = 14,
		
		text = "v0.1?",
		color = {0.5, 0.5, 0.5, 1}
	}
	wSelf:addControl("versionLabel", versionLabel)
	
	nameLabel = Label{
		x = 4,
		y = 24,
		text = "V360 Window System"
	}
	wSelf:addControl("nameLabel", nameLabel)
	
	authorLabel = Label{
		x = 4,
		y = 34,
		-- text = "By V360 (@V360dev)"
		text = "By V360 (v360.dev)"
	}
	wSelf:addControl("authorLabel", authorLabel)
	
	githubButton = Button{
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
	
	closeButton = Button{
		x = 66,
		y = 44,
		
		width = 58,
		height = 16,
		
		text = "Close"
	}
	closeButton.mouseClick = math.random() > 0.5
	and function(cSelf, m) wSelf:close() end
	or  function(cSelf, m) makeMyWindow() makeMyWindow() wSelf:close() end
	wSelf:addControl("closeButton", closeButton)
end

function makeMyWindow()
	myWindow = Window{
		title = "About VieWS",
		
		x = 16 + math.random(0, 256),
		y = 32 + math.random(0, 128),
		
		width = 128,
		height = 64,
		
		setup = windowConstruction
	}
	view:addWindow(myWindow)
end
makeMyWindow()
	
view:addWindow(Window{
	title = "Rumble Pak",
	
	x = 48,
	y = 48,
	
	width = 64,
	height = 64,
	
	setup = function(wSelf)
		rumbleButton = Button{
			x = 8,
			y = 8,
			
			width = 48,
			height = 48,
			
			text = "Test\nRumble"
		}
		rumbleButton.mouseClick = function(cSelf, m)
			window.shake.x = window.shake.x > 0 and 0 or 16
			window.shake.y = window.shake.x
		end
		wSelf:addControl("rumbleButton", rumbleButton)
	end
})

view:addWindow(Window{
	title = "Lo-fi Color test",
	
	x = 8,
	y = 24,
	
	width = 128,
	height = 160,
	
	setup = function(wSelf)
		imgControl = Image{
			x = 0, y = 0,
			
			image = love.graphics.newImage("resources/colorTest.png")
		}
		wSelf:addControl("imgControl", imgControl)
	end
})
