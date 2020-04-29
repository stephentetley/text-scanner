use TextScanner.{runWithString, return, next}; // , hasNextInt32, nextInt32, hasNextBool, nextBool, nextMatch};

@test
def test01(): Result[Int32, String] = 
    runWithString(return(10), "Ten")

@test
def test02(): Result[String, String] = 
    runWithString(next(), "Ten")


// @test
// def test03(): Result[String, String] & Impure = 
//     let sc = fromString("123456 ");
//     sc.nextMatch("[0-9]*")
    