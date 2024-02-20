local Minesweeper = {}

function Minesweeper.setup(vSelf, o)
	o = o or {}
	
	local cfg = {
		statusBar = 12,
		cellSize = Vec2(12, 12),
		gridSize = Vec2(8, 8),
	}
	cfg.totalSize = cfg.cellSize * cfg.gridSize + Vec2(0, statusBar)
	
	local w = Controls.Window {
		title = "Minesweeper",
		size = cfg.totalSize
	}
	vSelf:addWindow(w)
end

return Minesweeper
