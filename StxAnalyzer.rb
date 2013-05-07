load "/home/huxu/workspace/MyCompiler/declareID.rb"
def Make_stx_list
0.upto(500) { |i|  $Stx_list[i] = {
    'action' => [],
    'goto' => []
  }  
}
file = File.open("/home/huxu/workspace/MyCompiler/CFG.txt")
$a = 0
file.each_line {|line|
  if $a == 0
    $V = line.split(',')
    $a += 1
  elsif $a == 1
    $T = line.split(',')
    $a += 1
  else 
    $line[$a - 2] = line.split(' ')
    $a += 1
  end
}

$V[-1] = ($V[-1][0]).chr
$T[-1] = ($T[-1][0]).chr
$X = $V[1..(-1)] + $T[0..(-2)]

same = []
$first = ($line.length).times.map {[]}     #初始化二维数组
0.upto($line.length - 1) { |i|  
  index_V = $V.find_index($line[i][0])
  if $V.include?($line[i][2])
    same[same.length] = [$V.find_index($line[i][0]), $V.find_index($line[i][2])]
  elsif $T.include?($line[i][2])
    $first[index_V][$first[index_V].length] = $line[i][2]
  end
}

(same.length - 1).downto(0) { |i|  
  $first[(same[i][0])] += $first[(same[i][1])]
}

0.upto($V.length-1) { |i|  
  $first[i].uniq!
}

$pro_l = []
0.upto(300) { |i|  
  $pro_l[i] = []
  0.upto(300) { |i2|  
    $pro_l[i][i2] = []
  }
}

def closure()
  tmp_line = []
  tmp_act = []
  tmp_rdct = []
  findpoint = 0
  appear = 0
  re = 0
  j = 0
  while j < $pro_l[$pla].length do
    appeared = 0
    0.upto($pro_l[$pla][j].length - 1) { |i|  
      if $pro_l[$pla][j][i] == '`'
        nex = i + 1
        if $V.include?($pro_l[$pla][j][nex])
          0.upto($line.length-1) { |i2|
            if $pro_l[$pla][j][nex] == $line[i2][0]
              tmp_line = $line[i2]
              if $pla == 0
                tmp_line.insert(tmp_line.find_index("->")+1, '`')
                if $V.include?($pro_l[$pla][j][nex+1])
                  0.upto($first[$V.find_index($pro_l[$pla][j][nex+1])].length-1) { |i3| 
                    tmp_line = tmp_line + ['|'] + [$first[$V.find_index($pro_l[$pla][j][nex+1])][i3]]
                  }
                  $pro_l[$pla][$num] = tmp_line
                  $num += 1
                else
                  if $pro_l[$pla][j][nex+1] == '|'
                    tmp_line = tmp_line + ['|'] + [$pro_l[$pla][j][-1]]
                  else
                    tmp_line = tmp_line + ['|'] + [$pro_l[$pla][j][nex+1]]
                  end
                  $pro_l[$pla][$num] = tmp_line
                  $num += 1
                end
              else
                if $V.include?($pro_l[$pla][j][nex+1])
                  0.upto($first[$V.find_index($pro_l[$pla][j][nex+1])].length-1) { |i3| 
                    tmp_line = tmp_line + ['|'] + [$first[$V.find_index($pro_l[$pla][j][nex+1])][i3]]
                  }
                else
                  if $pro_l[$pla][j][nex+1] == '|'
                    tmp_line = tmp_line + $pro_l[$pla][j][(nex+1)..(-1)]
                  elsif tmp_line[0] == $pro_l[$pla][j][nex]
                    tmp_line = tmp_line + ['|'] + [$pro_l[$pla][j][nex+1]]
                  end
                end
                0.upto($num) { |i3|  
                  if tmp_line == $pro_l[$pla][i3]
                    appeared = 1
                  end
                }
                if appeared == 1
                  appeared = 0
                else
                  $pro_l[$pla][$num] = tmp_line
                  $num += 1
                end
              end
            end
          }
        end
        break
      end
    }
    j += 1
  end      
  0.upto($pla-1) { |i|  
    if $pro_l[i] == $pro_l[$pla]
      re = 1
      appear = i
      break
    end
  } 
  if re == 1
    if $V.include?($shiftin)
      $Stx_list[$k]['goto'][$V.find_index($shiftin)] = appear
    elsif $T.include?($shiftin)
      tmp_act[0] = 's'
      tmp_act[1] = appear
      $Stx_list[$k]['action'][$T.find_index($shiftin)] = tmp_act.join('')
    end
    $pro_l[$pla].clear
    $pla -= 1
    $num = 0
  else
    if $V.include?($shiftin)
      $Stx_list[$k]['goto'][$V.find_index($shiftin)] = $pla
    elsif $T.include?($shiftin)
      tmp_act[0] = 's'
      tmp_act[1] = $pla
      $Stx_list[$k]['action'][$T.find_index($shiftin)] = tmp_act.join('')
    end
    0.upto($num-1) { |i|  
      findpoint = $pro_l[$pla][i].find_index('`')
      if $pro_l[$pla][i][findpoint+1] == '|'
        0.upto($line.length-1) { |i2|  
          tmp_rdct = $line[i2] - ['`']
          if tmp_rdct == $pro_l[$pla][i][0..findpoint-1]
            findpoint.upto($pro_l[$pla][i].length-1) { |i3|  
              if $pro_l[$pla][i][i3] == '|'
                if $pro_l[$pla][i][i3+1] == '$' && $pro_l[$pla][i][0] == "S'"
                  $Stx_list[$pla]['action'][$T.find_index('$')] = "acc"
                else
                  tmp_act[0] = 'r'
                  tmp_act[1] = i2
                  $Stx_list[$pla]['action'][$T.find_index($pro_l[$pla][i][i3+1])] = tmp_act.join('')
                end
              end
            }
          end
        }
      end
    }
    $numofpro[$pla] = $num
    $num = 0
  end
end

$pro_l[0][0] = %w{S' -> ` S | $}
closure()
0.upto($line.length - 1) { |i2|  
  if $line[i2][2] != '`'
    $line[i2].insert(2, '`')
  end
}

def goto(m,n)
  $shiftin = n
  appeared = 0
  0.upto($numofpro[$k]-1) { |i|  
    if m[i][m[i].find_index('`')+1] == n
      $goto_arr = [] + m[i]
      point = $goto_arr.find_index('`')
      $goto_arr[point] = n
      $goto_arr[point+1] = '`'
      $pro_l[$pla+1][$num] = $goto_arr
      $num += 1
      appeared = 1
    end
  }  
  if appeared == 1
    $pla +=1
    closure()
  end
end

$k = 0
while $k <= $pla do
  0.upto($X.length-1) { |i|  
    goto($pro_l[$k],$X[i])
  }
  $k += 1
end
0.upto($pla) { |i|  
  if $pro_l[i] == $pro_l[$pla-1]
  end 
}

0.upto($line.length-1) { |i|  $line[i].delete_at(2)}
end

def StxAnalyzer(m, n, o, p)
	$ex = [] + m
	$con = [] + p
	$stack[0] = 0
	$smt_stack [0] = 0
	$ip = 0
	while $ip < $ex.length 
		if $Stx_list[$stack[-1]]['action'][$T.find_index($ex[$ip])] == nil
#			puts "Error!"
			break
		elsif $Stx_list[$stack[-1]]['action'][$T.find_index($ex[$ip])] == "acc"
#			print "line ", n, ":   "
#			puts "Victory!"
			break
		elsif $Stx_list[$stack[-1]]['action'][$T.find_index($ex[$ip])].split('')[0] == 's'
			$stack[$stack.length] = [$ex[$ip]]
			$smt_stack.push($con[$ip])
			if $con[$ip] == 'else'
				$f_w_l[$quarternary.length] = 'l'
				else_tmp = [] + ["goto"]
				$quarternary.push(else_tmp)
			elsif $con[$ip] == "if"
				$f_w_l[$quarternary.length] = 'f'
			elsif $con[$ip] == "while"
				$f_w_l[$quarternary.length] = 'e'
			end
			$stack[$stack.length] = Integer($Stx_list[$stack[-2]]['action'][$T.find_index($ex[$ip])].split('')[1..($Stx_list[$stack[-2]]['action'][$T.find_index($ex[$ip])].split('').length-1)].join(''))
			$smt_stack.push(0)
		#	$stack.each{|i|print i, " "}
		#	print "               "
		#	print "将终结符",$stack[-2],"压入栈，并且将状态栈顶改为",$stack[-1], "\n"
			$ip += 1
		elsif $Stx_list[$stack[-1]]['action'][$T.find_index($ex[$ip])].split('')[0] == 'r'
			rdct_tmp = Integer($Stx_list[$stack[-1]]['action'][$T.find_index($ex[$ip])].split('')[1..($Stx_list[$stack[-1]]['action'][$T.find_index($ex[$ip])].split('').length-1)].join(''))
			1.upto($line[rdct_tmp].length-2) { |i|  2.times {$stack.pop}}
			$stack[$stack.length] = $line[rdct_tmp][0]
			if $line[rdct_tmp].length-2 != 1
				1.upto($line[rdct_tmp].length-2) {|i|
					$smt_result.push($smt_stack[-2])
					2.times{$smt_stack.pop}
				}
				$smt_stack.push('T')
				$smt_stack.push(0)
				SmtAnalyzer(rdct_tmp, $smt_result)
				$smt_result.clear
			end
			$stack[$stack.length] = $Stx_list[$stack[-2]]['goto'][$V.find_index($line[rdct_tmp][0])]
		#	$stack.each{|i|print i, " "}
		#	print "               "
		#	print "将栈中非状态指示元素按", $line[rdct_tmp], "进行归约，将非终结符", $line[rdct_tmp][0], "压入栈，并将栈顶状态指示元素改为", $stack[-1], "\n"
		end
	end
	$stack.clear
end
