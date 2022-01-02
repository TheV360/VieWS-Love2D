function love.load()
	Object = require("objects/object")
	OptObject = require("objects/optobject")
	
	GameWindow = require("window/window")
	Util = require("window/util")
	GameWindow.pixelPerfect()
	
	utf8 = require("utf8")
	
	-- Set up pixel font
	local supportedCharacters = [[ !"#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\]^_`abcdefghijklmnopqrstuvwxyz{|}~◆◇▼▲▽△★☆■□🙂☹←↑→↓😔🙃]]
	font = love.graphics.newImageFont("resources/fonts/6x8.png", supportedCharacters)
	
	-- local supportedCharacters = [[ !"#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\]^_`abcdefghijklmnopqrstuvwxyz{|}~]]
	-- font = love.graphics.newImageFont("resources/fonts/graph.png", supportedCharacters, 1)
	
	-- local supportedCharacters = [[ !"#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\]^_`abcdefghijklmnopqrstuvwxyz{|}~]]
	-- font = love.graphics.newImageFont("resources/fonts/ms_gothic.png", supportedCharacters)
	
	love.graphics.setFont(font)
	
	require("views/views")
	
	window = GameWindow{
		title = "VieWS",
		version = "v0.1",
		icon = love.image.newImageData("resources/icon.png"),
		
		screen = {
			width  = 512,
			height = 342
		},
		shake = true,
		-- shader = "resources/shaders/shader.glsl",
		
		mouse = {
			cursors = {
				[""] = {},
				["mouse"] = {
					image = love.graphics.newImage("resources/cursors/mouse.png"),
					-- home = {x = 0, y = 0} -- home on first white pixel
					home = {x = 1, y = 2} -- home on first black pixel
				},
				["hand"] = {
					image = love.graphics.newImage("resources/cursors/hand.png"),
					-- home = {x = 4, y = 0} -- home on first white pixel
					home = {x = 4, y = 1} -- home on first black pixel
				},
				["movable"] = {
					image = love.graphics.newImage("resources/cursors/movable.png"),
					-- home = {x = 4, y = 0} -- home on first white pixel
					home = {x = 4, y = 1} -- home on first black pixel
				},
				["move"] = {
					image = love.graphics.newImage("resources/cursors/move.png"),
					-- home = {x = 4, y = 0} -- home on first white pixel
					home = {x = 4, y = 1} -- home on first black pixel
				},
				["pinch"] = {
					image = love.graphics.newImage("resources/cursors/pinch.png"),
					-- home = {x = 4, y = 0} -- home on first white pixel
					home = {x = 4, y = 1} -- home on first black pixel
				},
				["wait"] = {
					image = love.graphics.newImage("resources/cursors/wait.png"),
					home = {x = 3, y = 1},
					anim = {
						x = 0,
						y = 0,
						width = 16,
						height = 16,
						time = 3,
						
						{},
						{x = 16},
						{x = 32},
						{x = 48}
					}
				}
			},
			defaultCursor = "mouse"
		},
		debug = true,
		
		setup = function()
			view = VieWS{
				width  = window.screen.width,
				height = window.screen.height,
				
				loveFunctions = window.loveFunctions
			}
			
			require("somePlaceToPutWindowInitCode")
		end,
		update = function(dt)
			view:update(dt)
		end,
		draw = function()
			view:draw()
		end
	}
	
	window:setup()
end

function love.update(dt)
	window:update(dt)
end

function love.draw()
	window:draw()
end
