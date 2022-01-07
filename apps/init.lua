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

function colorTestWindow()
	view:addWindow(Controls.Window {
		title = "Lo-fi Color test",
		
		size = Vec2(128, 160),
		
		setup = function(wSelf)
			imgControl = Controls.Image {
				position = Vec2(0, 0),
				
				image = love.graphics.newImage("resources/colorTest.png")
			}
			wSelf:addControl(imgControl)
		end
	})
end

function windowMakerWindow()
	view:addWindow(Controls.Window {
		title = "Window Maker",
		
		size = Vec2(128, 96),
		
		setup = function(wSelf)
			infoLabel = Controls.Label {
				text = "Hello! This window makes windows.",
				
				position = Vec2(8, 8),
				size = Vec2(112, 16),
			}
			wSelf:addControl(infoLabel)
			
			local bTopLeft = Vec2(8, 32)
			local bMargin = Vec2(0, 4)
			local bSize = Vec2(56, 16)
			local bOfs = bSize + bMargin
			
			newAboutWindowButton = Controls.Button {
				text = "About",
				position = bTopLeft,
				size = bSize,
			}
			newAboutWindowButton.mouseClick = function(cSelf, m)
				aboutWindow()
			end
			wSelf:addControl(newAboutWindowButton)
			
			newPaletteWindow = Controls.Button {
				text = "Palette",
				position = bTopLeft + Vec2(0, 1) * bOfs,
				size = bSize,
			}
			newPaletteWindow.mouseClick = function(cSelf, m)
				paletteWindow()
			end
			wSelf:addControl(newPaletteWindow)
			
			newPatternsWindow = Controls.Button {
				text = "Patterns",
				position = bTopLeft + Vec2(1, 1) * bOfs,
				size = bSize,
			}
			newPatternsWindow.mouseClick = function(cSelf, m)
				patternsWindow()
			end
			wSelf:addControl(newPatternsWindow)
			
			newGraphWindow = Controls.Button {
				text = "Panels",
				position = bTopLeft + Vec2(0, 2) * bOfs,
				size = bSize,
			}
			newGraphWindow.mouseClick = function(cSelf, m)
				graphWindow()
			end
			wSelf:addControl(newGraphWindow)
			
			newAlwaysOnTopWindowButton = Controls.Button {
				text = "ways On T",
				position = bTopLeft + Vec2(1, 2) * bOfs,
				size = bSize,
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
