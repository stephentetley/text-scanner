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

    pub def asterisk(): Scanner[Unit] =  
        nextLiteral("*")
    
    pub def commentNameValue(name: String, sc: Scanner[a]): Scanner[a] = 
        use TextScanner.flatMap;
        let* _ = anchorString(name + ":");
        sc

    pub def pFileType(): Scanner[FileType] = 
        use TextScanner.flatMap;
        let* _ = asterisk();
        let* s = next();
        match s {
            case "Download" => return(Download)
            case "Upload" => return(Upload)
            case _ => throwError("FileType")
        }
        

    pub def pDataModel(): Scanner[DataModel] = 
        let u1 = nextLiteral("U1") `seqRight` return(U1);
        commentNameValue("Data Model",  u1)
        

    pub def pEntityType(): Scanner[EntityType] =
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



    pub def pVariant(): Scanner[String] = 
        commentNameValue("Variant", nextLine())
    
    pub def pUser(): Scanner[String] = 
        commentNameValue("User", nextLine())

    pub def pDateTime(): Scanner[LocalDateTime] = 
        use TextScanner.liftAction;
        use TextScanner.flatMap;
        let* _ = liftAction(_ -> Console.printLine("HERE"));
        let* d = anchorString("Date:") `seqRight` nextMatch("\d+");
        let* _ = nextLiteral("/");
        let* t = nextLiteral("Time:")  `seqRight` nextMatch("\d+");
        let* _ = liftAction(_ -> Console.printLine("DEBUG:" + d + " " + t));
        let* patt = liftResult(Time/Format/DateTimeFormatter.fromPattern("yyyyMMdd HHmmss"));
        let* ans = liftResult(Time/LocalDateTime.fromStringWithFormat(d + " " + t, patt));
        return(ans)
        

    pub def pHeader(): Scanner[FileHeader] = 
        use TextScanner.flatMap;
        let* ft = pFileType();
        let* dm = pDataModel();
        let* et = pEntityType();
        let* v = pVariant();
        let* u = pUser();
        let* dt = pDateTime();
        return({ fileType = ft, dataModel = dm, entityType = et, 
                    variant = v, user = u, dateTime = dt })

    pub def pSelectionHeader(): Scanner[Unit] = 
         anchorString("Selection:") `seqLeft` nextLine()

    pub def pSelectionLines(): Scanner[List[String]] = 
        manyWhileSome(findStringInLine("* "), _ -> nextLine())

    pub def pSelection(): Scanner[Selection] = 
        use TextScanner.flatMap;
        let* _ = pSelectionHeader();
        let* xs = pSelectionLines();
        return(Selection(xs))
    

    pub def pColumnHeaders(): Scanner[Headers] = 
        use TextScanner.flatMap;
        let* str = asterisk() `seqRight` nextLine();
        return(Headers(String.splitOn(str, "\t")))

    
    pub def pDataRow(): Scanner[DataRow] = 
        use TextScanner.flatMap;
        let* str = nextLine();
        return(DataRow(String.splitOn(str, "\t")))


    pub def pChangeFile(): Scanner[ChangeFile] = 
        use TextScanner.flatMap;
        let* hdr = pHeader();
        let* sel = pSelection();
        let* cols = pColumnHeaders();
        let* rows = manyWhileTrue(hasNextLine(), pDataRow());
        return({ fileHeader = hdr, selection = sel, headers = cols, dataRows = rows })


}