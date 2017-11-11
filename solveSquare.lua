Vec = require("Vector")
Mat = require("Matrix")

function solveSquare(uv,_L,camera,distort)
	--[[
		uv[1] = {x = **, y = **}
		uv[2] = {x = **, y = **}
		uv[3] = {x = **, y = **}
		uv[4] = {x = **, y = **}

		L is a number to the side

		camera is a Matrix3/Matrix, or a {ku,kv,u0,v0}
	--]]

	-- undistort
		-- to be filled
	if distort ~= nil then
		-- undistort get new uv, new camera
		-- solveSquare(newuv,L,newcamera)
	end

	local ku,kv,u0,v0
	local u1,v1,u2,v2,u3,v3,u4,v4
	local L = _L

	-- get ku,kv,u0,v0
	if type(camera) == "table" then
		if type(camera[1]) == "table" then
			ku = camera[1][1]
			kv = camera[2][2]
			u0 = camera[1][3]
			v0 = camera[2][3]
		else
			ku = camera[1]
			kv = camera[2]
			u0 = camera[3]
			u0 = camera[4]
		end
	else
		print("camera parameter wrong")
		return nil
	end

	-- get u1v1 to u4v4
	-- assert
	if type(uv) == "table" then
		if type(uv[1]) == "table" then
			u1 = uv[1].x;   v1 = uv[1].y;
			u2 = uv[2].x;   v2 = uv[2].y;
			u3 = uv[3].x;   v3 = uv[3].y;
			u4 = uv[4].x;   v4 = uv[4].y;
		else
			u1 = uv[1];   v1 = uv[2];
			u2 = uv[3];   v2 = uv[4];
			u3 = uv[5];   v3 = uv[6];
			u4 = uv[7];   v4 = uv[8];
		end
	else
		print("camera parameter wrong")
		return nil
	end

	-- assert in case someone is nil
	ku = ku or 1; kv = kv or 1; u0 = u0 or 1; v0 = v0 or 1;
	u1 = u1 or 1; v1 = v1 or 1; u2 = u2 or 1; v2 = v2 or 1;
	u3 = u3 or 1; v3 = v3 or 1; u4 = u4 or 1; v4 = v4 or 1;

	--[[ print check
	print("ku = ",ku); print("kv = ",kv); print("u0 = ",u0); print("v0 = ",v0);
	print("u1 = ",u1); print("v1 = ",v1); print("u2 = ",u2); print("v2 = ",v2);
	print("u3 = ",u3); print("v3 = ",v3); print("u4 = ",u4); print("v4 = ",v4);
	--]]

	----------------------------------------------------------
	-- now we have ku kv u0 v0, and u* v*, and L 
	-- trick starts
	local A = Mat:create(8,8,
		-- 	x		y (z)	a		b		c		p		q		r
		{ {	-ku,	0,		-ku,	0,		u1-u0,	-ku,	0,		u1-u0	},
		  {	0,		-kv,	0,		-kv,	v1-v0,	0,		-kv,	v1-v0	},

		  {	-ku,	0,		-ku,	0,		u2-u0,	ku,		0,	  -(u2-u0)	},
		  {	0,		-kv,	0,		-kv,	v2-v0,	0,		kv,	  -(v2-v0)	},

		  {	-ku,	0,		ku,		0,	  -(u3-u0),	ku,		0,	  -(u3-u0)	},
		  {	0,		-kv,	0,		kv,	  -(v3-v0),	0,		kv,	  -(v3-v0)	},

		  {	-ku,	0,		ku,		0,	  -(u4-u0),	-ku,	0,		u4-u0	},
		  {	0,		-kv,	0,		kv,	  -(v4-v0),	0,		-kv,	v4-v0	},
		})
	--A = A:exc(1,5,"col")
		-- c,y,a,b,x,p,q,r
	--A = A:exc(3,8,"col")
		-- c,y,r,b,x,p,q,a

	local B = Vec:create(8,{ 
		--	z
			u1-u0,
			v1-v0,
			u2-u0,
			v2-v0,
			u3-u0,
			v3-v0,
			u4-u0,
			v4-v0,
			})
	B = -B
	local AB = A:link(B,"col")
	local res,exc,success = AB:dia()
	local Ks = res:takeDia()
	local Zs = res:takeVec(9,"col")
	
	---[[ print check A and B
	print("A=",A)
	print("B=",B)
	print("AB=",AB)
	print("res=",res)
	print("exc=",exc)
	print("success=",success)
	print("Ks = ",Ks)
	print("Zs = ",Zs)
	--]]

	return 0
end
