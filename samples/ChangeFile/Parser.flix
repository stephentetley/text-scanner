/*
 * Copyright 2020 Stephen Tetley
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *   http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

use Time.LocalDateTime;

use TextScanner.Scanner;
use TextScanner.{return, map, throwError, seqLeft, seqRight, next, nextLine, hasNextLine, nextInt32, nextMatch, 
                    anchorString, findStringInLine,  nextLiteral, liftResult, manyWhileSome, manyWhileTrue, scanLine};

use ChangeFile/Datatypes.{FileType, DataModel, EntityType, Headers, Selection, DataRow, FileHeader, ChangeFile};
use ChangeFile/Datatypes.FileType.{Download, Upload};
use ChangeFile/Datatypes.DataModel.{U1};
use ChangeFile/Datatypes.EntityType.{FuncLoc, ClassFloc, ValuaFloc, Iflotx, Equi, ClassEqui, ValuaEqui, Eqmltxt};
use ChangeFile/Datatypes.Headers.{Headers};
use ChangeFile/Datatypes.Selection.{Selection};
use ChangeFile/Datatypes.DataRow.{DataRow};


namespace ChangeFile/Parser {

    def asterisk(): Scanner[Unit] =  
        nextLiteral("*")
    
    def commentNameValue(name: String, sc: Scanner[a]): Scanner[a] = 
        use TextScanner.flatMap;
        let* _ = anchorString(name + ":");
        sc

    def pFileType(): Scanner[FileType] = 
        use TextScanner.flatMap;
        let* _ = asterisk();
        let* s = next();
        match s {
            case "Download" => return(Download)
            case "Upload" => return(Upload)
            case _ => throwError("FileType")
        }
        

    def pDataModel(): Scanner[DataModel] = 
        let u1 = nextLiteral("U1") `seqRight` return(U1);
        commentNameValue("Data Model",  u1)
        

    def pEntityType(): Scanner[EntityType] =
        use TextScanner.flatMap;
        let body = () -> {
            let* s = next();
            match s {
                case "FUNCLOC"      => return(FuncLoc)
                case "CLASSFLOC"    => return(ClassFloc)
                case "VALUAFLOC"    => return(ValuaFloc)
                case "IFLOTX"       => return(Iflotx)
                case "EQUI"         => return(Equi)
                case "CLASSEQUI"    => return(ClassEqui)
                case "VALUAEQUI"    => return(ValuaEqui)
                case "EQMLTXT"      => return(Eqmltxt)
                case _              => throwError("EntityType")
            }
        };
        commentNameValue("Entity Type", body())

    def pVariant(): Scanner[String] = 
        commentNameValue("Variant", nextLine())
    
    def pUser(): Scanner[String] = 
        commentNameValue("User", nextLine())

    def pDateTime(): Scanner[LocalDateTime] = 
        use TextScanner.flatMap;
        let* d = anchorString("Date:") `seqRight` nextMatch("\d+");
        let* _ = nextLiteral("/");
        let* t = nextLiteral("Time:")  `seqRight` nextMatch("\d+");
        let* patt = liftResult(Time/Format/DateTimeFormatter.fromPattern("yyyyMMdd HHmmss"));
        let* ans = liftResult(Time/LocalDateTime.fromStringWithFormat(d + " " + t, patt));
        return(ans)
        

    def pHeader(): Scanner[FileHeader] = 
        use TextScanner.flatMap;
        let* ft = pFileType();
        let* dm = pDataModel();
        let* et = pEntityType();
        let* v = pVariant();
        let* u = pUser();
        let* dt = pDateTime();
        return({ fileType = ft, dataModel = dm, entityType = et, 
                    variant = v, user = u, dateTime = dt })

    def pSelectionHeader(): Scanner[Unit] = 
         anchorString("Selection:") `seqLeft` nextLine()

    def pSelectionLines(): Scanner[List[String]] = 
        manyWhileSome(findStringInLine("* "), _ -> nextLine())

    def pSelection(): Scanner[Selection] = 
        use TextScanner.flatMap;
        let* _ = pSelectionHeader();
        let* xs = pSelectionLines();
        return(Selection(xs))
    
    /// Note - the first header is prefixed by an asterisk, we can't use `asterisk` to find this 
    /// because `asterisk` can only see a token and there is no whitespace.
    def pColumnHeaders(): Scanner[Headers] = 
        use TextScanner.flatMap;
        let* h1 = map(s -> String.dropLeft(1, s), next());
        let* str = nextLine();
        return(Headers(h1 :: String.splitOn(String.trim(str), Char.toString('\u0009'))))

    
    def pDataRow(): Scanner[DataRow] = 
        use TextScanner.flatMap;
        let* str = nextLine();
        return(DataRow(String.splitOn(String.trimRight(str), Char.toString('\u0009'))))


    pub def pChangeFile(): Scanner[ChangeFile] = 
        use TextScanner.flatMap;
        let* hdr = pHeader();
        let* sel = pSelection();        
        let* cols = pColumnHeaders();
        let* rows = manyWhileTrue(hasNextLine(), pDataRow());
        return({ fileHeader = hdr, selection = sel, headers = cols, dataRows = rows })


}