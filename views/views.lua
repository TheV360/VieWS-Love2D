-- VieWS.

require "views/geometry"

VieWSRect = require("views/viewsrect")
VieWSEventRect = require("views/eventrect")
Desktop = require("views/desktop")
Popup = require("views/popup")

Controls = {}
Controls.Control = require("views/controls/control")
Controls.Panel = require("views/controls/panel")
Controls.Label = require("views/controls/label")
Controls.Image = require("views/controls/image")
Controls.Button = require("views/controls/button")

Effects = {}
Effects.Effect = require("views/effects/effect")
Effects.OpenWindow = require("views/effects/openWindow")
Effects.CloseWindow = require("views/effects/closeWindow")

Window = require("views/window")

VieWS = VieWSRect:extend()
-- VieWS = VieWSEventRect:extend()

VieWS.WindowSort = function(wa, wb) return wa.z < wb.z end

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
	
	-- Handles all love callbacks
	self.loveFunctions = o.loveFunctions
end

function VieWS:addWindow(w)
	w.parent = self
	w.z = #self.windows + 1
	
	table.insert(self.windows, w)
end

function VieWS:update()
	local i, w, tmp
	
	-- FX
	for i = #self.effects, 1, -1 do
		self.effects[i].life = self.effects[i].life - 1
		
		if self.effects[i].life < 0 then
			table.remove(self.effects, i)
		end
	end
	
	window:switchCursor("mouse")
	
	self.mouse.x, self.mouse.y = window.mouse.sx, window.mouse.sy
	
	if not window.mouse.down[1] then
		self.mouse.drag.window = nil
	elseif self.mouse.drag.window then
		self.mouse.drag.window.position.x = self.mouse.x - self.mouse.drag.x
		self.mouse.drag.window.position.y = self.mouse.y - self.mouse.drag.y
		
		window:switchCursor("move")
	end
	
	self.desktop:update()
	
	for i, w in ipairs(self.windows) do
		w.z = i
		
		w.hover = w:onWindow(self.mouse.x, self.mouse.y)
		w.hoverContent = w:onContent(self.mouse.x, self.mouse.y)
		
		if w.hover or w.hoverContent then
			self.mouse.windowTmp = w -- gets topmost window
		end
		
		w:update()
	end
	
	if self.mouse.window and self.mouse.window ~= self.mouse.windowTmp then
		self.mouse.window:mouseExit(self.mouse)
	end
	
	self.mouse.window = self.mouse.windowTmp
	self.mouse.windowTmp = nil
	
	if self.mouse.window then
		local w = self.mouse.window
		
		w:mouse(self.mouse)
		
		if window.mouse.press[1] then
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
					width = w.size.width + w.border.left + w.border.right,
					height = w.size.height + w.border.top + w.border.bottom
				})
			else
				table.insert(self.effects, Effects.OpenWindow{
					x = w.position.x,
					y = w.position.y,
					width = w.size.width,
					height = w.size.height
				})
			end
			w.status = "normal"
		elseif w.status == "close" then
			if w.border then
				table.insert(self.effects, Effects.CloseWindow{
					x = w.position.x - w.border.left,
					y = w.position.y - w.border.top,
					width = w.size.width + w.border.left + w.border.right,
					height = w.size.height + w.border.top + w.border.bottom
				})
			else
				table.insert(self.effects, Effects.CloseWindow{
					x = w.position.x,
					y = w.position.y,
					width = w.size.width,
					height = w.size.height
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
						width = w.size.width + w.border.left + w.border.right,
						height = w.size.height + w.border.top + w.border.bottom
					})
				else
					table.insert(self.effects, Effects.OpenWindow{
						x = w.position.x,
						y = w.position.y,
						width = w.size.width,
						height = w.size.height
					})
				end
				w.status = "normal"
			elseif w.status == "close" then
				if w.border then
					table.insert(self.effects, Effects.CloseWindow{
						x = w.position.x - w.border.left,
						y = w.position.y - w.border.top,
						width = w.size.width + w.border.left + w.border.right,
						height = w.size.height + w.border.top + w.border.bottom
					})
				else
					table.insert(self.effects, Effects.CloseWindow{
						x = w.position.x,
						y = w.position.y,
						width = w.size.width,
						height = w.size.height
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
		w:drawShadow()
		
		w:drawBorder()
		
		w:draw()
	end
	
	-- FX
	for i = 1, #self.effects do
		self.effects[i]:draw()
	end
end

function VieWS:mousemoved(m)
end
