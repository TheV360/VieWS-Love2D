function aboutWindow()
	require("apps/about").setup()
end

function graphWindow()
	require("apps/graph").setup()
end

function barWindow()
	require("apps/bar").setup()
end

function alwaysOnTopWindow()
	require("apps/alwaysOnTop").setup()
end

function patternsWindow()
	require("apps/patterns").setup()
end

function fixedPointWindow()
	require("apps/fixedPoint").setup()
end

function paletteWindow()
	require("apps/palette").setup()
end

function rumblePakWindow()
	view:addWindow(Controls.Window{
		title = "Rumble Pak",
		
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
			wSelf:addControl(rumbleButton)
		end
	})
end

function colorTestWindow()
	view:addWindow(Controls.Window{
		title = "Lo-fi Color test",
		
		width = 128,
		height = 160,
		
		setup = function(wSelf)
			imgControl = Controls.Image{
				x = 0, y = 0,
				
				image = love.graphics.newImage("resources/colorTest.png")
			}
			wSelf:addControl(imgControl)
		end
	})
end

function windowMakerWindow()
	view:addWindow(Controls.Window{
		title = "Window Maker",
		
		-- x = 52,
		-- y = 56,
		
		width = 128,
		height = 96,
		
		-- border = Sides(1),
		
		setup = function(wSelf)
			infoLabel = Controls.Label{
				text = "Hello! This window makes windows.",
				
				x = 8,
				y = 8,
				
				width = 112,
				height = 16,
			}
			wSelf:addControl(infoLabel)
			
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
			wSelf:addControl(newAboutWindowButton)
			
			newRumblePakWindowButton = Controls.Button{
				text = "Rumble Pak",
				
				x = 8,
				y = 52,
				
				width = 56,
				height = 16
			}
			newRumblePakWindowButton.mouseClick = function(cSelf, m)
				rumblePakWindow()
			end
			wSelf:addControl(newRumblePakWindowButton)
			
			newColorTestWindow = Controls.Button{
				text = "Color Test",
				
				x = 64,
				y = 52,
				
				width = 56,
				height = 16
			}
			newColorTestWindow.mouseClick = function(cSelf, m)
				colorTestWindow()
			end
			wSelf:addControl(newColorTestWindow)
			
			newGraphWindow = Controls.Button{
				text = "Panels",
				
				x = 64,
				y = 72,
				
				width = 56,
				height = 16
			}
			newGraphWindow.mouseClick = function(cSelf, m)
				graphWindow()
			end
			wSelf:addControl(newGraphWindow)
			
			newAlwaysOnTopWindowButton = Controls.Button{
				text = "Always On Top",
				
				x = 8,
				y = 72,
				
				width = 56,
				height = 16
			}
			newAlwaysOnTopWindowButton.mouseClick = function(cSelf, m)
				alwaysOnTopWindow()
			end
			wSelf:addControl(newAlwaysOnTopWindowButton)
		end
	})
end
-- windowMakerWindow()
patternsWindow()
barWindow()
fixedPointWindow()
paletteWindow()
