--given two arrays and return the degree of severe
--a is the teacher's marks,b is the students' real marks
function Severe(a,b)
	assert(#a==#b)
	local m, n, s1, s2 = 0, 0, 0, 0
	
	for i,v in ipairs(a) do
		if v < b[i] then 
			m = m + 1
			s1=s1+b[i]-v
		elseif v > b[i] then 
			n = n + 1
			s2=s2+v-b[i]
		else end
	end

	return 100/160*(80*s1/m + s1/m -80*s2/#a - s2/m)
end
