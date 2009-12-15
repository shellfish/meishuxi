-- return the sum of an array
function sum(a)
	local n = 0
	for i,v in ipairs(a) do n=n+v end
	return n
end

--return the average of an array
function avg(a)
	return sum(a)/#a
end

--return the Covariance of an array
function Cov(a,b)
	assert(#a == #b)
	local c = {}

	local avg_a = avg(a)
	local avg_b = avg(b)

	for i, v in ipairs(a) do
		local one, two = v, b[i]
		c[i] = (one - avg_a)*(two - avg_b)	
	end
	return avg(c)
end

--return the Variance of an array
function Variance(a)
	local n=0
	for i,v in ipairs(a) do n=n+(v-avg(a))*(v-avg(a)) end
	return n/#a
end

--return the Correlation of two sorts of variables
function Correlation(a,b)
	return Cov(a,b)/math.sqrt(Variance(a))/math.sqrt(Variance(b))	
end


print(Correlation({1, 4, 9}, {2, 6, 8}))

