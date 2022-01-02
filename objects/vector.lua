local ffi = require("ffi")
ffi.cdef[[
	typedef struct {
		double x, y;
	} v_vector2;
]]

local Vector
local vector_mt_index = {
	add = function(self, other) return Vector(self.x + other.x, self.y + other.y) end,
	sub = function(self, other) return Vector(self.x - other.x, self.y - other.y) end,
	mul = function(self, scalar) return Vector(self.x * scalar, self.y * scalar) end,
	
	dot = function(self, other) return (self.x * other.x) + (self.y * other.y) end,
	cross = function(self, other) error("Not defined for 2D vector.") end,
	
	magnitude = function(self) return math.sqrt((self.x * self.x) + (self.y * self.y)) end,
	normalize = function(self) return self * (1 / self:magnitude()) end,
	angleBetween = function(self, other)
		return math.acos(self:dot(other) / (self:magnitude() * other:magnitude()))
	end,
	
	rotate = function(self, rad)
		local s, c = math.sin(rad), math.cos(rad)
		return Vector(
			self.x * c - self.y * s,
			self.x * s + self.y * c
		)
	end
}
local vector_mt = {
	__add = vector_mt_index.add,
	__sub = vector_mt_index.sub,
	__mul = vector_mt_index.mul,
	__len = vector_mt_index.magnitude,
	__index = vector_mt_index
}
Vector = ffi.metatype("v_vector2", vector_mt)

return Vector
