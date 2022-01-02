local Minesweeper = {}

Minesweeper.Images = {
	
}

function Minesweeper.setup()
	view:addWindow(Controls.Window{
		title = "Minesweeper",
	})
end

return Minesweeper
