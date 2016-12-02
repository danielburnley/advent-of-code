import Data.List.Split

main = do
	contents <- getContents
        let splitted = splitOn ", " contents
	    result = partAStart splitted
            strResult = show result
        putStrLn strResult

partAStart :: [[Char]] -> Int
partAStart (dir:dirs) = 
	let (x,y) = partA (dir:dirs) (0, 0) 'N'
  	in abs x + abs y

partA :: [[Char]] -> (Int,Int) -> Char -> (Int,Int)
partA [] pos _ = pos
partA (dir:xs) pos compass =
	let (x, y, newCompass) = move dir pos compass
        in partA xs (x, y) newCompass

move :: [Char] -> (Int,Int) -> Char -> (Int,Int,Char)
move ('L':distS) (x,y) 'N' = 
	let dist = read distS :: Int 
  	in (x - dist, y, 'W')
move ('L':distS) (x,y) 'E' = 
	let dist = read distS :: Int
  	in (x, y + dist, 'N')
move ('L':distS) (x,y) 'S' = 
	let dist = read distS :: Int
   	in (x + dist, y, 'E')
move ('L':distS) (x,y) 'W' = 
	let dist = read distS :: Int
	in (x, y - dist, 'S')

move ('R':distS) (x,y) 'N' =
	let dist = read distS :: Int
	in (x + dist, y, 'E')
move ('R':distS) (x,y) 'E' =
	let dist = read distS :: Int
  	in (x, y - dist, 'S')
move ('R':distS) (x,y) 'S' = 
	let dist = read distS :: Int
        in (x - dist, y, 'W')
move ('R':distS) (x,y) 'W' =
	let dist = read distS :: Int
	in (x, y + dist, 'N')
