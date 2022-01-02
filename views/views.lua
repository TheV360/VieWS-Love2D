-- VieWS.

require("views/geometry")

Mouse = require("views/mouse")

VieWSRect = require("views/viewsrect")
VieWSEventRect = require("views/eventrect")
Desktop = require("views/desktop")
Popup = require("views/popup")

Effects = {}
Effects.Effect = require("views/effects/effect")
Effects.OpenWindow = require("views/effects/openWindow")
Effects.CloseWindow = require("views/effects/closeWindow")

Controls = {}
Controls.Control = require("views/controls/control")
Controls.Panel = require("views/controls/panel")
Controls.Label = require("views/controls/label")
Controls.Image = require("views/controls/image")
Controls.Button = require("views/controls/button")
Controls.CheckBox = require("views/controls/checkbox")
Controls.Slider = require("views/controls/slider")
Controls.Picker = require("views/controls/picker")
Controls.PixelGrid = require("views/controls/pixelGrid")
Controls.Window = require("views/controls/window")

VieWS = VieWSRect:extend()
-- VieWS = VieWSEventRect:extend()

VieWS.WindowSort = function(wa, wb) return wa.z < wb.z end

VieWS.PALETTE_GRAY = {
	{ 0, 0, 0 },
	{ 1/3, 1/3, 1/3 },
	{ 2/3, 2/3, 2/3 },
	{ 1, 1, 1 },
}
VieWS.PALETTE_CGA = {
	{ 0, 0, 0 },
	{ 0, 1, 1 },
	{ 1, 0, 1 },
	{ 1, 1, 1 },
}
VieWS.PALETTE_PURPLE = {
	{ 0, 0, 0 },
	{ 3/5, 9/20, 13/15 },
	{ 9/10, 17/20, 1 },
	{ 1, 1, 1 },
}
VieWS.PALETTE_AYU_DARK = {
	{ 3/4, 3/4, 3/4 },
	{ 1, 180/255, 84/255 },
	{ 178/255, 148/255, 187/255 },
	{ 15/255, 20/255, 26/255 },
}
VieWS.PALETTE = VieWS.PALETTE_PURPLE

function VieWS:new(o)
	VieWS.super.new(self, o)
	
	-- The mouse
	self.mouse = {
		x = 0, y = 0,
		
		drag = {
			index = nil,
			
			-- Offset while dragging
			x = 0,
			y = 0
		}
	}
	
	-- Desktop
	self.desktop = Desktop{
		parent = self
	}
	
	-- Popups (right click stuff, menu bar stuff.)
	self.popups = {}
	
	-- Window stuff
	self.windows = {}
	
	-- For getting width and height of text
	self.font = love.graphics.getFont()
	
	-- Stack of effects objects (window close, etc.)
	self.effects = {}
	
	-- Mouse object (handles cursors and inputs)
	self.mouseInput = Mouse(
		function()
			local p = screen:pointIn(Vec2(love.mouse.getPosition())):floor()
			if Util.pointInBox(p, Vec2.zero() - 4, screen.size + 4) then
				return p:clamp(Vec2.zero(), screen.size)
			else
				return false
			end
		end,
		{
			-- cursors have their home coord on the first black pixel
			[""] = {},
			["mouse"] = {
				image = "resources/cursors/mouse.png",
				home = Vec2(1, 2)
			},
			["hand"] = {
				image = "resources/cursors/hand.png",
				home = Vec2(4, 1)
			},
			["movable"] = {
				image = "resources/cursors/movable.png",
				home = Vec2(4, 1)
			},
			["move"] = {
				image = "resources/cursors/move.png",
				home = Vec2(4, 1)
			},
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
					{ ofs = Vec2(16, 0), }, -- only override ofs
					{ ofs = Vec2(32, 0), },
					{ ofs = Vec2(48, 0), },
				}
			}
		}
	)
	self.mouseInput:setCursor("mouse")
	
	-- Lazy way to do this...
	self.corner = love.graphics.newImage("resources/corner.png")
end

function VieWS:addWindow(w)
	w.parent = self
	w.z = #self.windows + 1
	
	table.insert(self.windows, w)
end

function VieWS:switchCursor(k)
	self.mouseInput:setCursor(k)
end

function VieWS:update(dt)
	local i, w, tmp
	
	-- FX
	for i = #self.effects, 1, -1 do
		self.effects[i].life = self.effects[i].life - 1
		
		if self.effects[i].life < 0 then
			table.remove(self.effects, i)
		end
	end
	
	self.mouseInput:update()
	self.mouse.x = self.mouseInput.position.x
	self.mouse.y = self.mouseInput.position.y
	
	if self.mouse.drag.window then
		if not self.mouseInput.input.down[1] then
			self.mouse.drag.window = nil
			
			self.mouseInput:setCursor("mouse")
		elseif self.mouse.drag.window then
			-- self.mouse.drag.window.velocity = Util.degreeDistance(self.mouse.drag.window.velocity, (self.mouse.drag.window.position.x - (self.mouse.x - self.mouse.drag.x)) * dt * 16)
			
			self.mouse.drag.window.position.x = self.mouse.x - self.mouse.drag.x
			self.mouse.drag.window.position.y = math.max(24, self.mouse.y - self.mouse.drag.y)
			
			self.mouseInput:setCursor("move")
		end
	else
		self.mouseInput:setCursor("mouse")
	end
	
	self.desktop:update()
	
	for i, w in ipairs(self.windows) do
		if w.onTop then
			w.z = 999 + i
		else
			w.z = i
		end
		
		w.hover = w:isOver(Point(self.mouse.x, self.mouse.y))
		
		if w.hover then
			self.mouse.windowTmp = w -- gets topmost window
		end
		
		w:update(dt)
	end
	
	if self.mouse.window and self.mouse.window ~= self.mouse.windowTmp then
		self.mouse.window:mouseExit(self.mouse)
	end
	
	self.mouse.window = self.mouse.windowTmp
	self.mouse.windowTmp = nil
	
	if self.mouse.window then
		local w = self.mouse.window
		
		w:mouse(self.mouse)
		
		if self.mouseInput.input.down[1] then w:mouseDown(self.mouse) end
		if self.mouseInput.input.release[1] then w:mouseUp(self.mouse) end
		
		if self.mouseInput.input.press[1] then
			-- Push window to front.
			w.z = #self.windows + 1
			
			w:mouseClick(self.mouse)
		end
	end
	
	-- Delete windows marked for deletion
	for i = #self.windows, 1, -1 do
		w = self.windows[i]
		
		if w.status == "open" then
			if w.border then
				table.insert(self.effects, Effects.OpenWindow{
					x = w.position.x - w.border.left,
					y = w.position.y - w.border.top,
					width = w.size.x + w.border.left + w.border.right,
					height = w.size.y + w.border.top + w.border.bottom
				})
			else
				table.insert(self.effects, Effects.OpenWindow{
					x = w.position.x,
					y = w.position.y,
					width = w.size.x,
					height = w.size.y
				})
			end
			w.status = "normal"
		elseif w.status == "close" then
			if w.border then
				table.insert(self.effects, Effects.CloseWindow{
					x = w.position.x - w.border.left,
					y = w.position.y - w.border.top,
					width = w.size.x + w.border.left + w.border.right,
					height = w.size.y + w.border.top + w.border.bottom
				})
			else
				table.insert(self.effects, Effects.CloseWindow{
					x = w.position.x,
					y = w.position.y,
					width = w.size.x,
					height = w.size.y
				})
			end
			table.remove(self.windows, i)
		end
	end
	
	-- Lua doesn't like it if you remove a numeric thing while it's in the pairs loop, hence the other loop.
	for i, w in pairs(self.windows) do
		if type(i) ~= "number" then
			if w.status == "open" then
				if w.border then
					table.insert(self.effects, Effects.OpenWindow{
						x = w.position.x - w.border.left,
						y = w.position.y - w.border.top,
						width = w.size.x + w.border.left + w.border.right,
						height = w.size.y + w.border.top + w.border.bottom
					})
				else
					table.insert(self.effects, Effects.OpenWindow{
						x = w.position.x,
						y = w.position.y,
						width = w.size.x,
						height = w.size.y
					})
				end
				w.status = "normal"
			elseif w.status == "close" then
				if w.border then
					table.insert(self.effects, Effects.CloseWindow{
						x = w.position.x - w.border.left,
						y = w.position.y - w.border.top,
						width = w.size.x + w.border.left + w.border.right,
						height = w.size.y + w.border.top + w.border.bottom
					})
				else
					table.insert(self.effects, Effects.CloseWindow{
						x = w.position.x,
						y = w.position.y,
						width = w.size.x,
						height = w.size.y
					})
				end
				self.windows[i] = nil
			end
		end
	end
	
	table.sort(self.windows, VieWS.WindowSort)
end

function VieWS:draw()
	local _, w
	
	self.desktop:draw()
	
	for _, w in ipairs(self.windows) do
		love.graphics.push()
		-- love.graphics.origin()
		love.graphics.translate(w.position.x, w.position.y)
		
		-- love.graphics.translate(w.size.x / 2, 0)
		-- love.graphics.rotate(math.rad(w.velocity))
		-- love.graphics.translate(-w.size.x / 2, 0)
		
		love.graphics.translate(-w.position.x, -w.position.y)
		w:drawShadow()
		
		w:drawBorder()
		
		love.graphics.translate(w.position.x, w.position.y)
		w:draw()
		love.graphics.pop()
	end
	
	-- FX
	for i = 1, #self.effects do
		self.effects[i]:draw()
	end
	
	love.graphics.setColor(VieWS.PALETTE[1])
	love.graphics.draw(self.corner, 0, 0, 0)
	love.graphics.draw(self.corner, screen.size.x, 0, math.rad(90))
	love.graphics.draw(self.corner, 0, screen.size.y, math.rad(270))
	love.graphics.draw(self.corner, screen.size.x, screen.size.y, math.rad(180))
	
	self.mouseInput:draw()
end

function VieWS:mousemoved(m)
end
