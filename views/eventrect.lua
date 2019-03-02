VieWSEventRect = VieWSRect:extend()

function VieWSEventRect:new(o)
	VieWSEventRect.super.new(self, o)
end

function VieWSEventRect:mouse(m) end
function VieWSEventRect:mouseClick() end
function VieWSEventRect:mouseEnter(m) end
function VieWSEventRect:mouseExit(m) end
function VieWSEventRect:wheelMoved(x, y) end

function VieWSEventRect:hide() end
function VieWSEventRect:show() end

function VieWSEventRect:focus() end
function VieWSEventRect:blur() end

function VieWSEventRect:keyPressed(key) return false end
function VieWSEventRect:textInput(t) end

return VieWSEventRect
