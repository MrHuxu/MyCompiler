def SmtAnalyzer(n, m)
	qt_tmp = []
	case n
	when 5, 6, 10
		qt_tmp[0] = m[1]
		qt_tmp[1] = m[0]
		qt_tmp[3] = m[2]
		$quarternary.push(qt_tmp)
	when 18, 19, 21, 22
		qt_tmp[0] = m[1]
		qt_tmp[1] = m[2]
		qt_tmp[2] = m[0]
		qt_tmp[3] = 'T'
		$quarternary.push(qt_tmp)
	when 11
		qt_tmp[0] = m[1]
		qt_tmp[1] = m[0]
		$quarternary.push(qt_tmp)
	when 13
		qt_tmp[0] = m[1]
		qt_tmp[1] = m[2]
		qt_tmp[2] = m[0]
		$quarternary.push(qt_tmp)
		qt_tmp = []
		qt_tmp[0] = "goto"
		$quarternary.push(qt_tmp)
	when 7
		$end[$quarternary.length] = 1
		qt_tmp[0] = "goto"
		$quarternary.push(qt_tmp)
	when 8, 9
		$end[$quarternary.length] = 1
	end
end
