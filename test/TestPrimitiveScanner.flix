use TextScanner/Internal/PrimitiveScanner.{fromString, hasNextInt32, nextInt32, hasNextBool, nextBool, nextMatch};

@test
def test01(): Int32 & Impure = 
    let sc = fromString("12345 1234");
    if (sc.hasNextInt32()) 
        sc.nextInt32()
    else 
        0

@test
def test02(): List[Bool] & Impure = 
    let sc = fromString("true false");
    sc.nextBool() :: sc.nextBool() :: Nil


@test
def test03(): Result[String, String] & Impure = 
    let sc = fromString("123456 ");
    sc.nextMatch("[0-9]*")
    