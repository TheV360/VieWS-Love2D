local Minesweeper = {}

function Minesweeper.setup()
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
	view:addWindow(w)
end

return Minesweeper
