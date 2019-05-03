-- VieWS.

require "views/geometry"

VieWSRect = require("views/viewsrect")
VieWSEventRect = require("views/eventrect")
Desktop = require("views/desktop")
Popup = require("views/popup")

Control = require("views/controls/control")
Panel = require("views/controls/panel")
Window = require("views/window")
Label = require("views/controls/label")
Image = require("views/controls/image")
Button = require("views/controls/button")

VieWS = VieWSRect:extend()
-- VieWS = VieWSEventRect:extend()

VieWS.WindowSort = function(wa, wb) return wa.z < wb.z end

function VieWS:new(o)
	VieWS.super.new(self, o)
	
	-- The mouse
	self.mouse = {
		x = 0, y = 0
	}
	
	-- Desktop
	self.desktop = Desktop{
		parent = self
	}
	
	-- Popups (right click stuff, menu bar stuff.)
	self.popups = {}
	
	-- Window stuff
	self.windows = {}
	self.windowDrag = {
		index = nil,
		
		-- Offset while dragging
		x = 0,
		y = 0
	}
	
	-- For getting width and height of text
	self.font = love.graphics.getFont()
	
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
	
	window:switchCursor("mouse")
	
	self.mouse.x, self.mouse.y = window.mouse.sx, window.mouse.sy
	self.mouse.window = nil
	
	if not window.mouse.down[1] then
		self.windowDrag.window = nil
	elseif self.windowDrag.window then
		self.windowDrag.window.position.x = self.mouse.x - self.windowDrag.x
		self.windowDrag.window.position.y = self.mouse.y - self.windowDrag.y
		
		window:switchCursor("move")
	end
	
	self.desktop:update()
	
	for i, w in ipairs(self.windows) do
		w.z = i
		
		w.hover = w:onWindow(self.mouse.x, self.mouse.y)
		w.hoverContent = w:onContent(self.mouse.x, self.mouse.y)
		
		if w.hover or w.hoverContent then
			self.mouse.window = w -- gets topmost window
		end
		
		if not self.windowDrag.window then
			if w.hover and not w.hoverContent and self.mouse.y - w.position.y < 0 then
				window:switchCursor("movable")
			elseif w.hover then
				window:switchCursor("mouse")
			end
		end
		
		w:update()
	end
	
	if self.mouse.window then
		local w = self.mouse.window
		
		if w.hoverContent then
			w:mouse(self.mouse)
		elseif w.hover then
			-- w:mouse(self.mouse)
		end
		
		if window.mouse.press[1] then
			-- Push window to front.
			w.z = #self.windows + 1
			
			if w.hoverContent then
				-- The mouse is over the content, and it has clicked.
				w:mouseClick(self.mouse)
			elseif w.hover then
				-- The mouse is not over the content, but is over the window.
				if self.mouse.y - w.position.y < 0 then
					-- The mouse is over the top part of the window.
					self.windowDrag.window = w
					self.windowDrag.x = self.mouse.x - w.position.x
					self.windowDrag.y = self.mouse.y - w.position.y
					
					window:switchCursor("move")
				end
			end
		end
	end
	
	-- Delete windows marked for deletion
	for i = #self.windows, 1, -1 do
		if self.windows[i].status == "close" then
			table.remove(self.windows, i)
		end
	end
	
	-- Lua doesn't like it if you remove a numeric thing while it's in the pairs loop, hence the other loop.
	for i, w in pairs(self.windows) do
		if type(i) ~= "number" and self.windows[i].status == "close" then
			self.windows[i] = nil
		end
	end
	
	table.sort(self.windows, VieWS.WindowSort)
end

function VieWS:draw()
	local _, w
	
	self.desktop:draw()
	
	for _, w in ipairs(self.windows) do
		w:drawBorder()
		
		love.graphics.setColor(1, 1, 1)
		w:draw()
		
		w:drawShadow()
	end
end

function VieWS:mousemoved(m)
end
