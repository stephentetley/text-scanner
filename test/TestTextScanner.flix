use TextScanner.{parseString, return, next, count, nextInt32}; // , hasNextInt32, nextInt32, hasNextBool, nextBool, nextMatch};
use TextScanner.{ScannerError};

@test
def test01(): Result[Int32, ScannerError] = 
    parseString(return(10), "Ten")

@test
def test02(): Result[String, ScannerError] = 
    parseString(next(), "Ten")

@test
def test03(): Result[Int32, ScannerError] = 
    parseString(nextInt32(), "1 2 3 4 5 6")
    

@test
def test04(): Result[List[Int32], ScannerError] = 
    parseString(count(5, nextInt32()), "1 2 3 4 5 6")
    