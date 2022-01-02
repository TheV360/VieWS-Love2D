local Mouse = Object:extend()

--[[
	["pinch"] = {
		image = "resources/cursors/pinch.png",
		home = Vec2(4, 1)
	},
	["wait"] = {
		image = "resources/cursors/wait.png",
		home = Vec2(3, 1),
		anim = {
			ofs = Vec2(0, 0),
			size = Vec2(16, 16),
			time = 3,
			
			{}, -- no overrides of the above
			{ ofs = Vec(16, 0), }, -- only override ofs
			{ ofs = Vec(32, 0), },
			{ ofs = Vec(48, 0), },
		}
	}
]]

function Mouse:new(posFn, cursors)
	self.input = Util.inputManager(
		{1, 2, 3, 4, 5},
		function(btn) return love.mouse.isDown(btn) end
	)
	
	self.cursor = {
		key = false, -- if false, the mouse is not displayed.
		
		anim = {
			frame = 1,
			timer = 0,
		}
	}
	
	self.cursors = {}
	for k, cursor in pairs(cursors) do
		local img = cursor.image
		if type(img) == 'string' then
			img = love.graphics.newImage(img)
		end
		
		local home = cursor.home or Vec2.zero()
		
		local anim = cursor.anim
		local frames = {}
		if type(anim) == "table" then
			for i, frame in ipairs(anim) do
				frames[i] = {
					quad = love.graphics.newQuad(
						frame.ofs and frame.ofs.x or anim.ofs.x,
						frame.ofs and frame.ofs.y or anim.ofs.y,
						frame.size and frame.size.x or anim.size.x,
						frame.size and frame.size.y or anim.size.y,
						img
					),
					time = frame.time or anim.time or 1
				}
			end
		elseif img then
			local s = Vec2(img:getDimensions())
			frames[1] = {
				quad = love.graphics.newQuad(
					0, 0, s.x, s.y, s.x, s.y
				),
				time = false
			}
		else
			frames[1] = { quad = false, time = false }
		end
		
		self.cursors[k] = {
			image = img,
			frames = frames,
			home = home,
		}
	end
	
	self.getPositionFn = posFn or love.mouse.getPosition
	
	self.position = Vec2.zero()
	self.oldPosition = self.position
end

function Mouse:setCursor(key)
	key = key or ""
	if self.cursor.key == key then return end
	
	self.cursor.key = key
	local value = self.cursors[self.cursor.key]
	local anim = self.cursor.anim
	
	anim.frame = 1
	anim.timer = value.frames[anim.frame].time
	
	love.mouse.setVisible(not value.image)
end

function Mouse:update()
	-- Update the mouse's position
	local newPosition = self.getPositionFn()
	if newPosition then
		self.oldPosition = self.position
		self.position = newPosition
	end
	
	-- Update the cursor animations
	local value = self.cursors[self.cursor.key]
	local anim = self.cursor.anim
	if anim.timer then
		anim.timer = anim.timer - 1
		if anim.timer <= 0 then
			anim.frame = anim.frame + 1
			if anim.frame >= #value.frames then
				anim.frame = 1
			end
			anim.timer = value.frames[anim.frame].time
		end
	end
	
	-- Update the button state.
	self.input:update()
end

function Mouse:draw()
	local value = self.cursors[self.cursor.key]
	local anim = self.cursor.anim
	
	if not value.image then return end
	
	love.graphics.setColor(1, 1, 1)
	love.graphics.draw(
		value.image, value.frames[anim.frame].quad,
		(self.position - value.home):unpack()
	)
end

return Mouse
