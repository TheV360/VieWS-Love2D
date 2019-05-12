VieWSEventRect = VieWSRect:extend()

function VieWSEventRect:new(o)
	VieWSEventRect.super.new(self, o)
end

function VieWSEventRect:doEvent(name, ...)
	self[name](self, ...)
end

function VieWSEventRect:mouse(m) end -- Takes "m" - mouse table
function VieWSEventRect:mouseClick(m) end -- Takes "m" - mouse table
function VieWSEventRect:mouseEnter(m) end -- Takes "m" - mouse table
function VieWSEventRect:mouseExit(m) end -- Takes "m" - mouse table
function VieWSEventRect:wheelMoved(x, y) end -- Takes "x" and "y" - wheel offset

function VieWSEventRect:hide() end -- No args.
function VieWSEventRect:show() end -- No args.

function VieWSEventRect:focus() end -- No args.
function VieWSEventRect:blur() end -- No args.

function VieWSEventRect:keyPressed(key) end -- Takes "key" - key from keyboard as string - Return "true" value to stop event from continuing
function VieWSEventRect:keyReleased(key) end -- Takes "key" - key from keyboard as string - Return "true" value to stop event from continuing
function VieWSEventRect:textInput(t) end -- Takes "t" - text from keyboard - Return "true" value to stop event from continuing

return VieWSEventRect
