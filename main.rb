# To change this template, choose Tools | Templates
# and open the template in the editor.
load "/home/huxu/workspace/MyCompiler/LexAnalyzer.rb"
load "/home/huxu/workspace/MyCompiler/StxAnalyzer.rb"
load "/home/huxu/workspace/MyCompiler/declareID.rb"
load "/home/huxu/workspace/MyCompiler/SmtAnalyzer.rb"

LexAnalyzer()
Make_stx_list()
j = 0
tmp = []
smt_tmp = []
while j <= $sentence.length-1
	#行首为注释符，跳过此行不归约
	if $sentence[j] == '#'        
		j += 1
	#行首为if或while，必须将这行直到end之间的内容放进tmp里进行归约
	elsif $sentence[j] == 'f' || $sentence[j] == 'e'
		inputtmp = 0
		j.upto($sentence.length-1) { |i|  
			if $sentence[i] == 'f' || $sentence[i] == 'e'
				inputtmp += 1
			elsif $sentence[i] == 'd'
				inputtmp -= 1
				if inputtmp == 0
					tmp = [] + $sentence[j..i] + ['$']
					j.upto(i){|k| smt_tmp.push($token[k]) if $sentence[k] != '#'}
					tmp = tmp - ['#'] if tmp.include?('#')         #去掉注释内容
					StxAnalyzer(tmp, $getNumofLine[j], $getNumofLine[i], smt_tmp)
					smt_tmp.clear
					j = i + 1
					break
				end
			end
		}
	#若行首为其他元素，则将该行放入tmp里进行归约
	else
		j.upto($sentence.length-1) { |i|  
			if i == $sentence.length-1
				tmp = [] + $sentence[j..i] + ['$']
				j.upto(i){|k| smt_tmp.push($token[k]) if $sentence != ['#']}
				tmp = tmp - ['#'] if tmp.include?('#')
				StxAnalyzer(tmp, $getNumofLine[j], nil, smt_tmp)
				smt_tmp.clear
				j = i + 1
				break
			elsif $getNumofLine[j] != $getNumofLine[i]
				tmp = [] + $sentence[j..i-1] + ['$']
				j.upto(i-1){|k| smt_tmp.push($token[k]) if $sentence != ['#']}
				tmp = tmp - ['#'] if tmp.include?('#')
				StxAnalyzer(tmp, $getNumofLine[j], nil, smt_tmp)
				smt_tmp.clear
				j = i
				break
			end
		}
	end
end

0.upto($quarternary.length-1){|i|
	if $quarternary[i][0] == "goto" && ($f_w_l[i-1] == 'f' || $f_w_l[i-1] == 'e')
		$goto.push(i)
	elsif $quarternary[i][0] == "goto" && ($f_w_l[i] == 'l')
		if $f_w_l[$goto.last] == 'l'
			$quarternary[$goto.last].push(i+1)
			$goto.pop
		end
		$end[i] = nil
		$quarternary[$goto.last].push(i+2)
		$goto.pop
		$goto.push(i)
	end
	if $end[i] == 1 
		if !$goto.empty?
			while (1)
				if $f_w_l[$goto.last-1] == 'f'
					$quarternary[$goto.last].push(i+1)
					$goto.pop
				else $f_w_l[$goto.last-1] == 'e'
					$quarternary[$goto.last].push(i+2)
					$quarternary[i].push($goto.last)
					$goto.pop
					break
				end
			end
		end
	end
}
0.upto($quarternary.length-1){|i|
	if $f_w_l[i] == 'f' || $f_w_l[i] == 'e'
		$quarternary[i][3] = i+3
	end
	print i+1, " (  "
	0.upto(3){|i2|
		print $quarternary[i][i2] if $quarternary[i][i2] != nil
		print " " if $quarternary[i][i2] == nil
		print ', ' if i2 != 3
	}
	print "   )"
	print "\n"
}
puts $goto
