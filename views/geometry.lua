function Point(x, y)
	return {x = x or 0, y = y or 0}
end

function Size(width, height)
	return {width = width or 1, height = height or 1}
end

function Rect(x, y, width, height)
	return {position = Point(x, y), size = Size(width, height)}
end

function Sides(top, right, bottom, left)
	return {
		top    = top                    or 1,
		right  = right           or top or 1,
		bottom = bottom          or top or 1,
		left   = left   or right or top or 1
	}
end

function Align(v, h)
	local s = {}
	
	v = v or "top"
	h = h or "left"
	
	if v == "center" or v == "middle" then
		s.vertical = 0
	elseif v == "top"  then
		s.vertical = -1
	elseif v == "bottom" then
		s.vertical = 1
	end
	
	if h == "center" or h == "middle" then
		s.horizontal = 0
	elseif h == "left"  then
		s.horizontal = -1
	elseif h == "right" then
		s.horizontal = 1
	end
	
	return s
end

-- Utilities:

function AlignRect(r, h, v)
	if     h == "center" then
		r.position.x = r.position.x - math.floor(r.size.width / 2)
	elseif h == "right"  then
		r.position.x = r.position.x - r.size.width - 1
	end
	
	if     v == "center" then
		r.position.y = r.position.y - math.floor(r.size.height / 2)
	elseif v == "bottom" then
		r.position.y = r.position.y - r.size.height - 1
	end
	
	return r
end

function SidesAroundRect(s, r)
	return Rect(
		r.position.x - s.left,
		r.position.y - s.top,
		r.size.width + s.left + s.right,
		r.size.height + s.top + s.bottom
	)
end
