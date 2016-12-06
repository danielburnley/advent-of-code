input = ARGV[0]

day = input[0...input.length-1].to_i
challenge = input[input.length-1...input.length]

if(day >= 1 && day <= 25 && (challenge == 'a' || challenge == 'b'))
 	puts "Running day #{day}#{challenge}"
	exec("erlc day#{day}/day#{day}.erl && erl -noshell -s day#{day} start_#{challenge} -s init stop")
end