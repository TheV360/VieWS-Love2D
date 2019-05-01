require "views/views"

function setup()
	view = VieWS{
		width  = window.screen.width,
		height = window.screen.height,
		
		loveFunctions = window.loveFunctions
	}
	
	require "somePlaceToPutWindowInitCode"
end

function update()
	view:update()
end

function draw()
	view:draw()
end
