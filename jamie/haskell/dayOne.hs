moveStart (dir:dirs) = 
	let (x,y) = move (dir:dirs) (0, 0) 'N'
  	in abs x + abs y

move :: [[Char]] -> (Int,Int) -> Char -> (Int,Int)
move [] x _ = x
move (('L':distS):xs) (x,y) 'N' = 
	let dist = read distS :: Int 
  	in move xs (x - dist, y) 'W'
move (('L':distS):xs) (x,y) 'E' = 
	let dist = read distS :: Int
  	in move xs (x, y + dist) 'N'
move (('L':distS):xs) (x,y) 'S' = 
	let dist = read distS :: Int
   	in move xs (x + dist, y) 'E'
move (('L':distS):xs) (x,y) 'W' = 
	let dist = read distS :: Int
	in move xs (x, y - dist) 'S'

move (('R':distS):xs) (x,y) 'N' =
	let dist = read distS :: Int
	in move xs (x + dist, y) 'E'
move (('R':distS):xs) (x,y) 'E' =
	let dist = read distS :: Int
  	in move xs (x, y - dist) 'S'
move (('R':distS):xs) (x,y) 'S' = 
	let dist = read distS :: Int
	in move xs (x - dist, y) 'W'
move (('R':distS):xs) (x,y) 'W' =
	let dist = read distS :: Int
	in move xs (x, y + dist) 'N'
