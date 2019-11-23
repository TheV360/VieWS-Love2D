function aboutWindow()
	require("apps.about").setup()
end

function graphWindow()
	require("apps.graph").setup()
end

function rumblePakWindow()
	view:addWindow(Window{
		title = "Rumble Pak",
		
		x = 48,
		y = 48,
		
		width = 64,
		height = 64,
		
		setup = function(wSelf)
			rumbleButton = Controls.Button{
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
end

function colorTestWindow()
	view:addWindow(Window{
		title = "Lo-fi Color test",
		
		x = 8,
		y = 24,
		
		width = 128,
		height = 160,
		
		setup = function(wSelf)
			imgControl = Controls.Image{
				x = 0, y = 0,
				
				image = love.graphics.newImage("resources/colorTest.png")
			}
			wSelf:addControl("imgControl", imgControl)
		end
	})
end

function windowMakerWindow()
	view:addWindow(Window{
		title = "Window Maker",
		
		x = 52,
		y = 56,
		
		width = 128,
		height = 96,
		
		setup = function(wSelf)
			infoLabel = Controls.Label{
				text = "Hello! This window makes windows.",
				
				x = 8,
				y = 8,
				
				width = 112,
				height = 16,
			}
			wSelf:addControl("infoLabel", infoLabel)
			
			newAboutWindowButton = Controls.Button{
				text = "About Window",
				
				x = 8,
				y = 32,
				
				width = 112,
				height = 16
			}
			newAboutWindowButton.mouseClick = function(cSelf, m)
				aboutWindow()
			end
			wSelf:addControl("newAboutWindowButton", newAboutWindowButton)
			
			newRumblePakWindowButton = Controls.Button{
				text = "Rumble Pak Window",
				
				x = 8,
				y = 52,
				
				width = 112,
				height = 16
			}
			newRumblePakWindowButton.mouseClick = function(cSelf, m)
				rumblePakWindow()
			end
			wSelf:addControl("newRumblePakWindowButton", newRumblePakWindowButton)
			
			--[[newColorTestWindow = Controls.Button{
				text = "Color Test Window",
				
				x = 8,
				y = 72,
				
				width = 112,
				height = 16
			}
			newColorTestWindow.mouseClick = function(cSelf, m)
				colorTestWindow()
			end
			wSelf:addControl("newColorTestWindow", newColorTestWindow)]]
			
			newGraphWindow = Controls.Button{
				text = "Graph Window",
				
				x = 8,
				y = 72,
				
				width = 112,
				height = 16
			}
			newGraphWindow.mouseClick = function(cSelf, m)
				graphWindow()
			end
			wSelf:addControl("newGraphWindow", newGraphWindow)
		end
	})
end
windowMakerWindow()
