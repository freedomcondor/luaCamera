Vec = require("Vector")
Vec3 = require("Vector3")
Mat = require("Matrix")

function solveDeg2(A,B,C)
	if A == 0 then
		return -C/B, nil
	end

	local delta = B^2-4*A*C
	if delta < 0 then
		return nil, nil
	end
	if delta == 0 then
		return -B / (2*A),nil
	end

	local x1 = (-B + math.sqrt(delta)) / (2*A)
	local x2 = (-B - math.sqrt(delta)) / (2*A)
	return x1,x2
end

function solve7add1(L,ku,kv,u0,v0,u1,v1,u2,v2,u3,v3,u4,v4,flag)
	local A = Mat:create(8,9,
		--	x		y		z		a 		b       c       p       q       r
	    { {	-ku,    0,     u1-u0,	-ku,    0,      u1-u0,  -ku,    0,      u1-u0   },
		  { 0,      -kv,   v1-v0,	0,      -kv,    v1-v0,  0,      -kv,    v1-v0   },
		  { -ku,    0,     u2-u0,	-ku,    0,      u2-u0,  ku,     0,    -(u2-u0)  },
		  { 0,      -kv,   v2-v0,	0,      -kv,    v2-v0,  0,      kv,   -(v2-v0)  },
		  { -ku,    0,     u3-u0,	ku,     0,    -(u3-u0), ku,     0,    -(u3-u0)  },
		  { 0,      -kv,   v3-v0, 	0,      kv,   -(v3-v0), 0,      kv,   -(v3-v0)  },
		  { -ku,    0,     u4-u0, 	ku,     0,    -(u4-u0), -ku,    0,      u4-u0   },
		  { 0,      -kv,   v4-v0, 	0,      kv,   -(v4-v0), 0,      -kv,    v4-v0   },
		})

	--print("A = ",A)
	flag = flag or 8
	A = A:exc(flag,8)
	A[8] = nil
	A.n = 7

	--print("A = ",A)

	A = A:exc(3,8,"col")

	print("A = ",A)

	local B,_,success = A:tri()
	print("B = ",B)
	--B[7][7] = 1
	local B,_,success = B:dia()
	if success == false then
		print("solve linar equation fail")
		return -1
	end


	x_z = B[1][8]/B[1][1];	x_r = B[1][9]/B[1][1]
	y_z = B[2][8]/B[2][2];	y_r = B[2][9]/B[2][2]
	q_z = B[3][8]/B[3][3];	q_r = B[3][9]/B[3][3]
	a_z = B[4][8]/B[4][4];	a_r = B[4][9]/B[4][4]
	b_z = B[5][8]/B[5][5];	b_r = B[5][9]/B[5][5]
	c_z = B[6][8]/B[6][6];	c_r = B[6][9]/B[6][6]
	p_z = B[7][8]/B[7][7];	p_r = B[7][9]/B[7][7]

	-- ap + bq + cr == 0
	-- Kzz z^2 + Kzr zr + Krr r2
	local Kzz = a_z * p_z + b_z * q_z
	local Kzr = a_z*p_r + a_r*p_z + b_z*q_r + b_r*q_z + c_z
	local Krr = a_r * p_r + b_r * q_r +c_r

	print(Kzz,Kzr,Krr)
	local r_z_res = {}
	r_z_res[1],r_z_res[2] = solveDeg2(Krr,Kzr,Kzz)
	print("r_z1 = ",r_z_res[1])
	print("r_z2 = ",r_z_res[2])

	local z = {n = 0}
	for i = 1,2 do
		if r_z_res[i] >= 0 then
			x_z = x_z + x_r * r_z_res[i]
			y_z = y_z + y_r * r_z_res[i]
			a_z = a_z + a_r * r_z_res[i]
			b_z = b_z + b_r * r_z_res[i]
			c_z = c_z + c_r * r_z_res[i]
			p_z = p_z + p_r * r_z_res[i]
			q_z = q_z + q_r * r_z_res[i]
			local r_z = r_z_res[i]

			-- a2+b2+c2 = L2
			local z_res1 = L^2/(a_z^2 + b_z^2 + c_z^2)
			local z_res2 = L^2/(p_z^2 + q_z^2 + r_z^2)

			z.n = z.n + 1
			z[z.n] = z_res1
			z.n = z.n + 1
			z[z.n] = z_res2
		end
	end

	

	---[[
	print("A = ",A)
	print("B = ",B)
	print("success = ",success)
	--]]
end
