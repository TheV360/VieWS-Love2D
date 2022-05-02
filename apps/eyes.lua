local Eyes = {}

function Eyes.setup(vSelf, o)
	o = o or {}
	
	-- The number of eyes to draw.
	local eyeCount = o.eyes or 2
	
	vSelf:addWindow(Controls.Window {
		title = (eyeCount > 1) and "Eyes" or "Eye",
		
		size = o.size or Vec2(192, 128),
		
		setup = function(wSelf)
			-- The size of a single eye.
			local eyeSize = wSelf.size / Vec2(eyeCount, 1)
			
			-- The size of a pupil.
			local pupilRadius = 0.6
			local pupilSize = eyeSize * pupilRadius
			
			local myCanvas = Controls.Canvas {
				size = wSelf.size,
				
				draw = function(self)
					local mousePos = vSelf.mouse.position - wSelf.position
					love.graphics.clear(VieWS.PALETTE[3])
					
					love.graphics.setColor(VieWS.PALETTE[4])
					for i = 1, eyeCount do
						local pos = Vec2((i - 0.5) * eyeSize.x, eyeSize.y / 2):round()
						
						love.graphics.setColor(VieWS.PALETTE[4])
						love.graphics.ellipse(
							"fill",
							pos.x, pos.y,
							eyeSize.x / 2, eyeSize.y / 2
						)
					end
					
					love.graphics.setColor(VieWS.PALETTE[1])
					for i = 1, eyeCount do
						local eyePos = Vec2((i - 0.5) * eyeSize.x, eyeSize.y / 2)
						
						local pupilPos = (mousePos - eyePos) / eyeSize
						local pupilDist = math.min(pupilPos:magnitude(), 1 - pupilRadius)
						
						pupilPos = (pupilPos:normalize() * pupilDist * (eyeSize / 2)) + eyePos
						
						if Util.isInfinity(pupilPos.x) or Util.isNaN(pupilPos.x)
						or Util.isInfinity(pupilPos.y) or Util.isNaN(pupilPos.y) then
							pupilPos = eyePos
						end
						
						pupilPos = pupilPos:round()
						
						love.graphics.ellipse(
							"fill",
							pupilPos.x, pupilPos.y,
							pupilSize.x / 2, pupilSize.y / 2
						)
					end
				end,
				
				keepDrawing = true,
			}
			wSelf:addControl(myCanvas)
		end,
	})
end

return Eyes
