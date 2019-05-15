-- 5. úloha
--
-- 1) Definujte datový typ 'Trie k v' reprezentující trii, kde klíče (řetězce)
-- jsou typu '[k]' a hodnoty typu 'v'.
data Optional v = Empty | Value v deriving (Show, Eq)
data Trie k v = Leaf (Optional v) | Node (Optional v) [(k, Trie k v)] deriving (Show, Eq)

-- Implementujte následující:

empty :: Trie k v
empty = Leaf Empty

-- 'empty' je jednoduše konstanta, reprezentující prádznou trii.
--
-- > empty == fromList []
--

singleton :: [k] -> v -> Trie k v
singleton [] v = Leaf (Value v)
singleton (k:ks) v = Node Empty [(k, singleton ks v)]

-- 'singleton ks v' je trie, která obsahuje právě jednen klíč 'ks'
-- s hodnotou 'v'.
--
-- > singleton ks v == fromList [(ks, v)]
--

insertWith :: (Ord k) => (v -> v -> v) -> [k] -> v -> Trie k v -> Trie k v
insertWith _ k v empty = singleton k v
insertWith _ (k:ks) value (Leaf val) = Node val [(k, (singleton ks value))]
-- snažil jsem se dodělat, ale hází mi to chyby a nedokážu si s tím poradit
-- insertWith f [] (Value value) (Leaf val) = singleton [] (f value (Just val))
-- insertWith f [] value (Node val l) = Node (f value val) l
-- insertWith f (x:xs) value (Node v [(key, val):t])
--  | x == xs = Node v [(key, insertWith f xs val):t]
--  | otherwise = Node v [(key, val):"..."] -- nedokon4eno

-- 'insertWith f ks new t' vloží klíč 'ks' s hodnotou 'new' do trie 't'. Pokud
-- trie již klíč 'ks' (s hodnotou 'old') obsahuje, původní hodnota je nahrazena
-- hodnotou 'f new old'.
--
-- > insertWith (++) "a" "x" empty                  == fromList [("a","x")]
-- > insertWith (++) "a" "x" (fromList [("a","y")]) == fromList [("a","xy")]
--

insert :: (Ord k) => [k] -> v -> Trie k v -> Trie k v
insert ks new t = insertWith (replace) ks new t

replace value _ = value
-- 'insert ks new t' vloží klíč 'ks' s hodnotou 'new' do trie 't'. Pokud trie
-- již klíč 'ks' obsahuje, původní hodnota je nahrazena hodnotou 'new'
--
-- Hint: použijte 'insertWith'
--
-- > insert "a" "x" (fromList [("a","y")]) == fromList [("a","x")]
--

find :: (Ord k) => [k] -> Trie k v -> Maybe v
find [] (Leaf (Value v)) = (Just v)
find [] (Node (Value v) _) = (Just v)
find (k:ks) (Node _ t) = find ks (extract k [t])
  where
    extract k [] = empty
    extract k [(key, val):t]
      | k == key = val
      | otherwise = extract k [t]
find _ empty = Nothing

-- 'find k t' vrátí hodnotu odpovídající klíči 'k' (jako 'Just v'), pokud
-- existuje, jinak 'Nothing'.
--
-- > find "a" empty                  == Nothing
-- > find "a" (fromList [("a","x")]) == Just "x"
--

member :: (Ord k) => [k] -> Trie k v -> Bool
member [] (Leaf (Value _)) = True
member [] (Node (Value _) _) = True
member (k:ks) (Node _ t) = member ks (extract k [t])
  where
    extract k [] = empty
    extract k [(key, val):t]
      | k == key = val
      | otherwise = extract k [t]
member _ _ = False

-- 'member k t' zjistí, jestli se klíč 'k' nalézá v trii 't'.
--
-- Hint: použijte 'find'
--
--
-- Funkce 'fromList' není nutná, ale může se vám hodit pro testování.

fromList :: (Ord k) => [([k], v)] -> Trie k v
fromList [] = empty
fromList ((k, v):[]) = singleton k v 
fromList l = Node Empty (map extract l)
    where
      extract (k:ks, v) = (k, (singleton ks v))

-- BONUS) Implementujte funkci

delete :: (Ord k) => [k] -> Trie k v -> Trie k v
delete [] t = t
delete _ empty = empty
delete k t
  | (member k t) = (superDelete k t)
  | otherwise = empty
      where
        superDelete _ _ = empty -- Dodelat superDelete

-- 'delete ks t' smaže klíč 'ks' (a odpovídající hodnotu) z trie 't', pokud
-- klíč 'ks' není v trii obsažený, 'delete' vrátí původní trii.
--
-- > delete "a" (fromList [("b","y")]) == fromList [("b","y")]
-- > delete "a" (fromList [("a","x")]) == fromList []