prufer_decode :: [Int] -> [(Int, Int)]
prufer_decode prufer_code = go prufer_code degree [] 
  where
    n = length prufer_code + 2

    degree :: [(Int, Int)]
    degree = foldl (\d i -> update_degree i d) [(i, 1) | i <- [1..n]] prufer_code
      where
        update_degree i [] = []
        update_degree i ((k, v):rest)
          | i == k    = (k, v + 1) : rest
          | otherwise = (k, v) : update_degree i rest

    go :: [Int] -> [(Int, Int)] -> [(Int, Int)] -> [(Int, Int)]
    go [] deg edges = connect_last_two deg edges
    go (x:xs) deg edges =
        let
            leaf = head $ filter (\i -> lookup_degree i deg == 1) [1..n]
            deg' = update_degree x (-1) $ update_degree leaf (-1) deg
        in
            go xs deg' ((leaf, x) : edges)

    connect_last_two :: [(Int, Int)] -> [(Int, Int)] -> [(Int, Int)]
    connect_last_two deg edges =
        let
            [u, v] = filter (\i -> lookup_degree i deg == 1) [1..n]
        in
            (u, v) : edges

    lookup_degree :: Int -> [(Int, Int)] -> Int
    lookup_degree i deg = case lookup i deg of
        Just d  -> d
        Nothing -> 0

    update_degree :: Int -> Int -> [(Int, Int)] -> [(Int, Int)]
    update_degree i delta [] = [(i, delta)]
    update_degree i delta ((k, v):xs)
        | i == k    = (k, v + delta) : xs
        | otherwise = (k, v) : update_degree i delta xs



-- Funkcja kalkulująca sume różnych liczb bezkwadratowych w n wierszach trjokata Pascala
sumSquareFreeDistinctPascal :: Int -> Int
sumSquareFreeDistinctPascal n = sum (filter isSquareFree (distinctNumbers n))
    where
        -- Generowanie n wierszy trójkąta Pascala
         -- Funkcja genreująca n wierszy w trójkącie pascala
        generatePascalRows :: Int -> [[Int]]
        generatePascalRows n = take n (generatePascalRow [1])

        -- Funkcja genreująca jeden wiersz w trójkącie pascala
        generatePascalRow :: [Int] -> [[Int]]
        generatePascalRow row = row : generatePascalRow (nextRow row)

        -- Funckja kalkulująca zawartosc nastepnego wiersza na podstawie poprzedniego
        nextRow :: [Int] -> [Int]
        nextRow xs = zipWith (+) (0:xs) (xs ++ [0])


        -- Usuwanie duplikatów z listy wierszy trojkata Pascala
        -- Funkcja usuwająca duplikaty z listy
        distinctNumbers :: Int -> [Int]
        distinctNumbers n = removeDuplicates (concat (generatePascalRows n))

        -- Funkcja wspomagająca usuwanie duplikatów z listy
        removeDuplicates :: (Eq a) => [a] -> [a]
        removeDuplicates [] = []
        removeDuplicates (x:xs) = x : removeDuplicates (filter (/= x) xs)


        -- Sprawdzanie czy dane liczba jest bezkwadratowa (wyokonywane dla różnych liczb w n wierszach trójkata Pascala)
        -- Funkcja sprawdzająca czy liczba jest bezkwadratowa
        isSquareFree :: Int -> Bool
        isSquareFree n = not (hasSquareFactor n)

        -- Funckja sprawdzajaca czy liczba ma doskonałe dzielniki
        hasSquareFactor :: Int -> Bool
        hasSquareFactor n = any (\p -> n `mod` (p * p) == 0) (takeWhile (\p -> p * p <= n) primes)

        -- Funkcja generująca nieskonczną liste liczb pierwszych obliczane są tylko te wartości które są
        -- wymagane w obliczeniach
        primes :: [Int]
        primes = sieve [2..]
        -- algorytm sieva generujacy liste liczby pierwszych
        sieve (p:xs) = p : sieve [x | x <- xs, x `mod` p /= 0]

--Funkcja rozpoczyna poszukiwanie okresow
cycleLengthAndDigits :: Int -> (Int, String)
cycleLengthAndDigits d = findCycle 1 [] [] 0 d

--Funkcja wykrywa okresy i zapisuje ich dlugosci i wyglad
findCycle :: Int -> [Int] -> [Int] -> Int -> Int -> (Int, String)
findCycle currentRemainder previousRemainders digits count d
    | current == 0 = (0, "")
    | elemIndex current previousRemainders /= -1 = 
        let cycleStart = elemIndex current previousRemainders
            cycleDigits = take (count - cycleStart) (drop cycleStart digits)
        in (count - cycleStart, map toChar cycleDigits)
    | otherwise = findCycle nextRemainder (previousRemainders ++ [current]) (digits ++ [nextDigit]) (count + 1) d
  where
    current = (currentRemainder * 10) `mod` d
    nextRemainder = current
    nextDigit = (currentRemainder * 10) `div` d
    toChar n = head (show n)

findIndex :: Int -> [Int] -> Int -> Int
findIndex _ [] _ = -1
findIndex x (y:ys) i
    | x == y = i
    | otherwise = findIndex x ys (i + 1)

elemIndex :: Int -> [Int] -> Int
elemIndex x xs = findIndex x xs 0

--Funkcja znajduje najdluzsze okresy ze wszystkich znalezionych
longestCycles :: Int -> [(Int, Int, String)]
longestCycles n = filter ((== maxCycleLength) . snd3) allCycles
  where
    allCycles = [(d, cycleLength, digits) | d <- [2..n], let (cycleLength, digits) = cycleLengthAndDigits d]
    maxCycleLength = customMaximum (map snd3 allCycles)
    snd3 (_, x, _) = x

customMaximum :: [Int] -> Int
customMaximum [x] = x
customMaximum (x:xs) = max x (customMaximum xs)

displayResults :: Int -> IO ()
displayResults n = mapM_ display (longestCycles n)
  where
    display (d, len, cycle) = putStrLn $ "1/" ++ show d ++ " has cycle length: " ++ show len ++ " which looks like: " ++ "0.(" ++ cycle ++ ")"

-- Główna funkcja testowa
main :: IO ()
main = do
    
  putStrLn "Task 11, enter the value of n:"
  n <- readLn
  displayResults n

  putStrLn "Zadanie 29: Kod Prufer'a"
  let prufer_code:: [Int] = [4,4]
  print prufer_code
  let edges = prufer_decode prufer_code
  print edges

  putStrLn "Zadanie 37: Wprowadz liczba wierszy trjojkata Pascala:"
  n_pascal <- readLn :: IO Int
  let totalSumPascalTriangle = sumSquareFreeDistinctPascal  n_pascal
  putStrLn $ "Suma różnych liczb bezkwadratowych w " ++ show n_pascal ++ " pierwszych wierszach trjókata Pascala = " ++ show totalSumPascalTriangle
