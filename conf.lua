function love.conf(t)
	local w, h = 512, 342
	local scale = 1
	
	t.window.width = w * scale
	t.window.height = h * scale
	
	t.window.resizable = true
end
