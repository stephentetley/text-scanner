use TextScanner.{runWithString, return, next, count, nextInt32}; // , hasNextInt32, nextInt32, hasNextBool, nextBool, nextMatch};

@test
def test01(): Result[Int32, String] = 
    runWithString(return(10), "Ten")

@test
def test02(): Result[String, String] = 
    runWithString(next(), "Ten")

@test
def test03(): Result[Int32, String] = 
    runWithString(nextInt32(), "1 2 3 4 5 6")
    

@test
def test04(): Result[List[Int32], String] = 
    runWithString(count(5, nextInt32()), "1 2 3 4 5 6")
    