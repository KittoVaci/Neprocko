-- 4. úloha
--
-- 1) Implementujte kódování a dekódování RLE (https://en.wikipedia.org/wiki/Run-length_encoding):

-- >>> rleEncode "hello"
-- <interactive>:1612:2-10: error:
--     Variable not in scope: rleEncode :: [Char] -> t
--
rleEncode :: (Eq a) => [a] -> [(Int, a)]
rleEncode [] = []
rleEncode k = pruchod k []
  where
    pruchod [] l = reverse l
    pruchod (x:xs) [] = pruchod xs [(1, x)]
    pruchod (x:xd) ((a, b):xs) = 
      if x == b
        then pruchod xd ((a + 1, b):xs)
        else pruchod xd ((1 , x):(a, b):xs)


-- >>> rleDecode [(1,'h'),(1,'e'),(2,'l'),(1,'o')]
-- <interactive>:1593:2-10: error:
--     Variable not in scope: rleDecode :: [(Integer, Char)] -> t
--
rleDecode :: [(Int, a)] -> [a]
rleDecode [] = []
rleDecode k = pruchod k
  where
    pruchod [] = []
    pruchod ((b, c):xs) =  rleToString (b, c) ++ pruchod xs
    
rleToString :: (Int, a) -> [a]
rleToString (x, y) = 
  if x > 1
  then [y] ++ rleToString (x - 1, y) 
  else [y]


-- 2) Definujte nekonečný seznam všech prvočísel. Pokuste se o efektivní řešení.

-- >>> take 5 primes
-- [2,3,5,7,11]
--

primes :: [Integer]
primes = prober [2..]
    where
      prober (prime:xs) = prime : prober[x|x <- xs, isPrime x]
      isPrime x = all (\p -> x `mod` p > 0) (takeWhile (\p -> p*p <= x) primes)



-- 3) Implementujte mergesort.

mergeWith :: (a -> a -> Bool) -> [a] -> [a] -> [a]
mergeWith _ [] [] = []
mergeWith _ [] a = a
mergeWith _ a [] = a
mergeWith f (a:ax) (b:bx) = 
  if f a b 
    then [a] ++ mergeWith f ax (b:bx)
    else [b] ++ mergeWith f (a:ax) bx

sortWith  :: (a -> a -> Bool) -> [a] -> [a]
sortWith _ [] = []
sortWith f a = 
  if length a < 2 
    then a
    else mergeWith f (sortWith f (take half a)) (sortWith f (drop half a))
  where
    half = length a `div` 2

-- Prvním argumentem je funkce, která provádí porovnávání.
--
-- >>> sortWith (<) [10,9..1]
-- [1,2,3,4,5,6,7,8,9,10]
--
-- >>> sortWith (>) [10,9..1]
-- [10,9,8,7,6,5,4,3,2,1]
--
-- BONUS)
--
-- Implementujte následující funkce:

-- combinations n x vygeneruje seznam všech kombinací délky n ze seznamu x.
-- Na pořadí kombinací ve výsledném seznamu nezáleží.
--
-- >>> combinations 2 "abcd"
-- ["ab","ac","ad","bc","bd","cd"]
--
combinations :: Int -> [a] -> [[a]]
combinations = undefined

-- permutations x vygeneruje seznam všech permutací. Na pořadí permutací ve
-- výsledném seznamu nezáleží.
--
-- >>> permutations "abc"
-- ["abc","bac","bca","acb","cab","cba"]
--
permutations :: [a] -> [[a]]
permutations = undefined

-- Pomocí těchto funkcí definujte "variace" (občas najdete v české literatuře,
-- v angličtině pro to termín asi neexistuje): kombinace, kde záleží na pořadí
--
-- >>> variations 2 "abc"
-- ["ab","ba","ac","ca","bc","cb"]
--
variations :: Int -> [a] -> [[a]]
variations = undefined

