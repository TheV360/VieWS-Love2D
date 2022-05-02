local Bar = {}

function Bar.setup(vSelf)
	local cfg = {
		pop = {
			{"About", "about"},
			{"Fixed Pt", "fixedPoint"},
			{"Palette", "palette"},
			{"Patterns", "patterns"},
			{"Eyes", "eyes"},
		},
		topLeft = Vec2(8, -1),
		marginX = 2,
	}
	
	local wSelf = Controls.Window {
		title = "VieWS Menu",
		
		position = Vec2(0, 0),
		size = Vec2(vSelf.size.x, 12),
		
		border = Sides(0, 0, 1, 0),
		
		onTop = true,
	}
	
	local x = 0
	for i = 1, #cfg.pop do
		local name, appFile = unpack(cfg.pop[i])
		
		local lButton = Controls.Button {
			text = name,
			position = cfg.topLeft + Vec2(x, 0),
			height = 14,
		}
		x = x + lButton.size.x + cfg.marginX
		lButton.mouseClick = function()
			vSelf:try(function()
				dofile("apps/" .. appFile .. ".lua").setup(vSelf)
			end)
		end
		
		wSelf:addControl(lButton)
	end
	
	vSelf:addWindow(wSelf)
end

return Bar
