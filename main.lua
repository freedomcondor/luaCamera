require("solveSquare")

local a = 3
local uv = {}
uv[1] = {x = a, y = a}
uv[2] = {x = -a, y = a}
uv[3] = {x = -a, y = -a}
uv[4] = {x = a, y = -a}

local ku,kv,u0,v0
ku = 4
kv = 4
--u0 = 4
--v0 = 4
u0 = 1
v0 = 1

local c = Mat:create{
		{ku,	0,	u0},
		{0,		kv,	v0},
		{0,		0,	1},
	}

res = solveSquare(uv,5,c)
