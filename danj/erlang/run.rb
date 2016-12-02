input = ARGV[0]

day = input[0...input.length-1].to_i
challenge = input[input.length-1...input.length]


puts "[#{day}]"
puts "[#{challenge}]"

if(day >= 1 && day <= 25 && (challenge == 'a' || challenge == 'b'))
 	puts "Running exercise #{day}"
	exec("erlc exercise#{day}.erl && erl -noshell -s exercise#{day} start#{challenge} -s init stop")
end