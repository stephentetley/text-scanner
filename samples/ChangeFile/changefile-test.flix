use TextScanner.{Scanner, parseString, seqRight, nextLiteral, nextLine, map, next, anchorStringInLine};
use TextScanner/Internal/Utils.{timeOperationNanos};

pub def runTimed(operation: () -> a & e): a & Impure =         
        let (nt, a) = timeOperationNanos(operation) as & Impure;
        let msg = "Time: ${ Int64.toString(nt) }";
        Console.printLine(msg);
        a


@test
def test01(): Result[ChangeFile/Datatypes.ChangeFile, String] & Impure = 
    let src = 
        "G:\work\Projects\assets\asset_patch\file_download_edm\car36_outstation_valuaequi.txt" |> System/FilePath.new;
    let work = () -> 
        match TextScanner.parseFile(ChangeFile/Parser.pChangeFile(), src, System/Charset.utf_8() ) { 
            case Err(e) => Err(e)
            case Ok(a) => Ok(a)
        };
    runTimed(work)
        
@test
def test02(): Result[ChangeFile/Datatypes.FileType, String] & Impure = 
    let src = 
        "G:\work\Projects\assets\asset_patch\file_download_edm\car36_outstation_valuaequi.txt" |> System/FilePath.new;
    match TextScanner.parseFile(ChangeFile/Parser.pFileType(), src, System/Charset.utf_8() ) { 
        case Err(e) => Err(e)
        case Ok(a) => Ok(a)
    }

@test
def test03(): Result[ChangeFile/Datatypes.Selection, String] & Impure = 
    let src = 
        "G:\work\Projects\assets\asset_patch\file_download_edm\car36_outstation_valuaequi.txt" |> System/FilePath.new;
    match TextScanner.parseFile(ChangeFile/Parser.pHeader() `seqRight` ChangeFile/Parser.pSelection(), src, System/Charset.utf_8() ) { 
        case Err(e) => Err(e)
        case Ok(a) => Ok(a)
    }

@test
def test04(): Result[String, String] = 
    TextScanner.parseString(nextLiteral("*") `seqRight` next(), "*     Data Model: U1" )

@test
def test05(): Result[String, String] = 
    TextScanner.parseString(anchorStringInLine("Data Model:") `seqRight` next(), "Data Model: U1" )

@test
def test06(): Result[String, String] = 
    TextScanner.parseString(anchorStringInLine("Data Model:") `seqRight` map(_ -> "U1", nextLiteral("U1")), "Data Model: U1" )

@test
def test06a(): Result[String, String] = 
    TextScanner.parseString(anchorStringInLine("Data Model:") `seqRight` map(_ -> "U1", nextLiteral("U1")), "* Data Model: U1" )

@test
def test07(): Result[ChangeFile/Datatypes.DataModel, String] = 
    TextScanner.parseString(ChangeFile/Parser.pDataModel(), "* Data Model: U1" )

@test
def test08(): Result[String, String] = 
    TextScanner.parseString(ChangeFile/Parser.asterisk() `seqRight` next(), "* Data Model: U1" )

// @test
// def test02(): Result[S4Download/Parser.DownloadFile, String] & Impure = 
//     let src = 
//         "G:\work\Projects\assets\asset_patch\file_download_edm\car36_outstation_valuaequi.txt" |> FilePath.new;
//     match TextParser.parseFile(S4Download/Parser.pDownload(), src, Charset.utf_8() ) { 
//         case Err(e) => Err(TextParser.showParserError(e))
//         case Ok(a) => Ok(a)
//     }


// @test
// def test03(): Unit & Impure = 
//     let src = 
//         "G:\work\Projects\assets\asset_patch\file_download_edm\LSTN_RELAY_1_FUNCTION_valuaequi.txt" |> FilePath.new;
//     match TextParser.parseFile(S4Download/Parser.pDownload(), src, Charset.utf_8() ) { 
//         case Err(e) => Console.printLine(TextParser.showParserError(e))
//         case Ok(a) => {
//             let rows = S4Download.makeRows(a);
//             List.foreach(S4Download.getValue("CHARID") >> Console.printLine, rows)
//         }
//     }


// @test
// def test04(): Unit & Impure = 
//     let src = 
//         "G:\work\Projects\assets\asset_patch\file_download_edm\LSTN_RELAY_1_FUNCTION_valuaequi.txt" |> FilePath.new;
//     match TextParser.parseFile(S4Download/Parser.extractColumnHeadings(), src, Charset.utf_8() ) { 
//         case Err(e) => Console.printLine(TextParser.showParserError(e))
//         case Ok(xs) => {
//             List.foreach(Console.printLine, xs)
//         }
//     }


// @test
// def download01(): String = 
//     runOrError(S4Download/Parser.download(), x -> x, "* Download")

// @test
// def dataModel01(): String = 
//     runOrError(S4Download/Parser.dataModel(), x -> x, "* Data Model: U1")

// @test
// def entityType01(): String = 
//     runOrError(S4Download/Parser.entityType(), x -> x, "* Entity Type: EQUI")

// @test
// def variant01(): String = 
//     runOrError(S4Download/Parser.variant(), x -> x, "* Variant:")

// @test
// def user01(): String = 
//     runOrError(S4Download/Parser.user(), x -> x, "* User: TETLEYS")

// @test
// def dateTime01(): String = 
//     let conv = p -> { let (x,y) = p; x + ", " + y } ;
//     runOrError(S4Download/Parser.dateTime(),  conv, "* Date: 20200306 / Time:090808")
