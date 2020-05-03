
use LineCount.{runLineCounter};

def runOnFile(msg: String, f: String -> Int, path: String): Unit & Impure = 
    let path1 = System/FilePath.new(path);
    match System/File.readFile(path1, System/Charset.utf_16le()) { 
        case Err(err) => Console.printLine(err)
        case Ok(s) => {
            runLineCounter(msg, f, s)
        }

    }

@test
def test01(): Unit & Impure = 
    runOnFile("lineCount01", LineCount.lineCount01, "e:\coding\flix\text-scanner\testdata\flix_dir.txt");
    runOnFile("lineCount02", LineCount.lineCount02, "e:\coding\flix\text-scanner\testdata\flix_dir.txt")


