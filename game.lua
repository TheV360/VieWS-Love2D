require "views/views"

function setup()
	love.mouse.setVisible(false)
	
	view = VieWS{
		width  = window.screen.width,
		height = window.screen.height,
		
		loveFunctions = window.loveFunctions
	}
	
	function makeMyWindow()
		myWindow = Window{
			title = "About VieWS",
			
			x = 16,
			y = 32,
			
			width = 128,
			height = 64,
			
			setup = function(self)
				logoImage = Image{
					x = 4,
					y = 6,
					image = love.graphics.newImage("resources/logo.png")
				}
				self:addControl("logoImage", logoImage)
				
				versionLabel = Label{
					x = 94,
					y = 14,
					
					text = "v0.1?",
					color = {0.5, 0.5, 0.5, 1}
				}
				self:addControl("versionLabel", versionLabel)
				
				nameLabel = Label{
					x = 4,
					y = 24,
					text = "V360 Window System"
				}
				self:addControl("nameLabel", nameLabel)
				
				authorLabel = Label{
					x = 4,
					y = 34,
					text = "By V360 (@0x560360)"
				}
				self:addControl("authorLabel", authorLabel)
				
				githubButton = Button{
					x = 4,
					y = 44,
					
					width = 58,
					height = 16,
					
					text = "Github"
				}
				githubButton.mouseClick = function(m)
					love.system.openURL("https://thev360.github.io/VieWS/")
				end
				self:addControl("githubButton", githubButton)
				
				closeButton = Button{
					x = 66,
					y = 44,
					
					width = 58,
					height = 16,
					
					text = "Close"
				}
				closeButton.mouseClick = makeMyWindow
				self:addControl("closeButton", closeButton)
			end
		}
		view:addWindow(myWindow)
	end
	makeMyWindow()
	
	-- view:addWindow(Window{
	-- 	title = "Window 2",
		
	-- 	x = 48,
	-- 	y = 48,
		
	-- 	width = 128,
	-- 	height = 64,
		
	-- 	borderless = true
	-- 	-- border = {top = 4, right = 1, bottom = 1, left = 1}
	-- })
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
