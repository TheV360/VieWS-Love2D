local Launcher = {}

function Launcher.setup(vSelf)
	local cfg = {
		pop = {
			{"About", "about"},
			{"Fixed Pt", "fixedPoint"},
			{"Palette", "palette"},
			{"Patterns", "patterns"},
			{"Eyes", "eyes"},
		},
		topLeft = Vec2(8, 32),
		margin = Vec2(2, 4),
		buttonSize = Vec2(54, 16),
	}
	cfg.offset = cfg.buttonSize + cfg.margin
	
	local windowSize = Vec2(128, cfg.topLeft.y + math.ceil(#cfg.pop / 2) * (cfg.buttonSize.y + cfg.margin.y) - cfg.margin.y + 8)
	
	view:addWindow(Controls.Window {
		title = "Launchpad",
		
		size = windowSize,
		
		setup = function(wSelf)
			infoLabel = Controls.Label {
				text = "Hello! This window launches windows.",
				
				position = Vec2(8, 8),
				size = Vec2(wSelf.size.x - 16, 16),
			}
			wSelf:addControl(infoLabel)
			
			for i = 1, #cfg.pop do
				local name, appFile = unpack(cfg.pop[i])
				local ofs = Vec2((i - 1) % 2, math.floor((i - 1) / 2))
				
				local nwButton = Controls.Button {
					text = name,
					position = cfg.topLeft + ofs * cfg.offset,
					size = cfg.buttonSize,
				}
				nwButton.mouseClick = function()
					vSelf:try(function()
						dofile("apps/" .. appFile .. ".lua").setup(vSelf)
					end)
				end
				
				wSelf:addControl(nwButton)
			end
		end
	})
end

return Launcher
