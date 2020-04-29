use TextScanner/Internal/PrimitiveScanner.{fromString, hasNextInt32, nextInt32, hasNextBool, nextBool, nextMatch};

@test
def test01(): Result[Int32, String] & Impure = 
    let sc = fromString("12345 1234");
    if (sc.hasNextInt32()) 
        sc.nextInt32()
    else 
        Err("err")

@test
def test02(): Result[List[Bool], String] & Impure = 
    use Result.flatMap;
    let sc = fromString("true false");
    let* a = sc.nextBool();
    let* b = sc.nextBool();
    Ok(a :: b :: Nil)
    


@test
def test03(): Result[String, String] & Impure = 
    let sc = fromString("123456 ");
    sc.nextMatch("[0-9]*")
    