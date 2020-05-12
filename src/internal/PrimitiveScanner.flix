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

use TextScanner.Error.{IllegalArgumentException, IllegalStateException, InputMismatchException, 
                        NoSuchElementException, PatternSyntaxException};

use TextScanner/Internal.{PrimitiveScanner, Pattern};
use TextScanner/Internal.PrimitiveScanner.{PrimitiveScanner};
use TextScanner/Internal.Pattern.{Pattern};

namespace TextScanner/Internal {

    pub opaque type PrimitiveScanner = ##java.util.Scanner

    pub opaque type Pattern = ##java.util.regex.Pattern

}

namespace TextScanner/Internal/PrimitiveScanner {

    /// Note Scanners typically tim leading space not trailing space...

    pub def fromString(s: String): PrimitiveScanner & Impure = 
        import new java.util.Scanner(String) as newScanner;
        PrimitiveScanner(newScanner(s)) 


    pub def close(sc: PrimitiveScanner): Unit & Impure = 
        import java.util.Scanner.close();
        let PrimitiveScanner(sc1) = sc;
        sc1.close()

    pub def compilePattern(patt: String): Result[Pattern, TextScanner.Error] = 
        import java.util.regex.Pattern:compile(String);
        try {
            Ok(Pattern(compile(patt))) as & Pure
        } catch {
            case _: ##java.util.regex.PatternSyntaxException => Err(PatternSyntaxException)
        }

    pub def getDelimiter(sc: PrimitiveScanner): Pattern & Impure = 
        import java.util.Scanner.delimiter();
        let PrimitiveScanner(sc1) = sc;
        Pattern(sc1.delimiter())

    pub def setDelimiter(sc: PrimitiveScanner, pattern: Pattern): Unit & Impure = 
        import java.util.Scanner.useDelimiter(##java.util.regex.Pattern);
        let PrimitiveScanner(sc1) = sc;
        let Pattern(p1) = pattern;
        let _  = sc1.useDelimiter(p1);
        ()

    pub def hasNext(sc: PrimitiveScanner): Bool & Impure = 
        import java.util.Scanner.hasNext();
        let PrimitiveScanner(sc1) = sc;
        sc1.hasNext()

    pub def next(sc: PrimitiveScanner): Result[String, TextScanner.Error] & Impure = 
        import java.util.Scanner.next();
        try {
            let PrimitiveScanner(sc1) = sc;
            Ok(sc1.next())
        } catch {
            case _: ##java.util.NoSuchElementException => Err(NoSuchElementException)
            case _: ##java.lang.IllegalStateException => Err(IllegalStateException)
        }


    pub def hasNextInt8(sc: PrimitiveScanner): Bool & Impure = 
        import java.util.Scanner.hasNextByte();
        let PrimitiveScanner(sc1) = sc;
        sc1.hasNextByte()

    pub def nextInt8(sc: PrimitiveScanner): Result[Int8, TextScanner.Error] & Impure = 
        import java.util.Scanner.nextByte();
        try {
            let PrimitiveScanner(sc1) = sc;
            Ok(sc1.nextByte())
        } catch {
            case _: ##java.util.InputMismatchException => Err(InputMismatchException)
            case _: ##java.util.NoSuchElementException => Err(NoSuchElementException)
            case _: ##java.lang.IllegalStateException => Err(IllegalStateException)
        }

    pub def hasNextInt16(sc: PrimitiveScanner): Bool & Impure = 
        import java.util.Scanner.hasNextShort();
        let PrimitiveScanner(sc1) = sc;
        sc1.hasNextShort()

    pub def nextInt16(sc: PrimitiveScanner): Result[Int16, TextScanner.Error] & Impure = 
        import java.util.Scanner.nextShort();
        try {
            let PrimitiveScanner(sc1) = sc;
            Ok(sc1.nextShort())            
        } catch {
            case _: ##java.util.InputMismatchException => Err(InputMismatchException)
            case _: ##java.util.NoSuchElementException => Err(NoSuchElementException)
            case _: ##java.lang.IllegalStateException => Err(IllegalStateException)
        }

    pub def hasNextInt32(sc: PrimitiveScanner): Bool & Impure = 
        import java.util.Scanner.hasNextInt();
        let PrimitiveScanner(sc1) = sc;
        sc1.hasNextInt()

    pub def nextInt32(sc: PrimitiveScanner): Result[Int32, TextScanner.Error] & Impure = 
        import java.util.Scanner.nextInt();
        try {
            let PrimitiveScanner(sc1) = sc;
            Ok(sc1.nextInt())
        } catch {
            case _: ##java.util.InputMismatchException => Err(InputMismatchException)
            case _: ##java.util.NoSuchElementException => Err(NoSuchElementException)
            case _: ##java.lang.IllegalStateException => Err(IllegalStateException)
        }

    pub def hasNextInt64(sc: PrimitiveScanner): Bool & Impure = 
        import java.util.Scanner.hasNextLong();
        let PrimitiveScanner(sc1) = sc;
        sc1.hasNextLong()

    pub def nextInt64(sc: PrimitiveScanner): Result[Int64, TextScanner.Error] & Impure = 
        import java.util.Scanner.nextLong();
        try { 
            let PrimitiveScanner(sc1) = sc;
            Ok(sc1.nextLong())        
        } catch {
            case _: ##java.util.InputMismatchException => Err(InputMismatchException)
            case _: ##java.util.NoSuchElementException => Err(NoSuchElementException)
            case _: ##java.lang.IllegalStateException => Err(IllegalStateException)
        }

    pub def hasNextBigInt(sc: PrimitiveScanner): Bool & Impure = 
        import java.util.Scanner.hasNextBigInteger();
        let PrimitiveScanner(sc1) = sc;
        sc1.hasNextBigInteger()

    pub def nextBigInt(sc: PrimitiveScanner): Result[BigInt, TextScanner.Error] & Impure = 
        import java.util.Scanner.nextBigInteger();
        try {
            let PrimitiveScanner(sc1) = sc;
            Ok(sc1.nextBigInteger())
        } catch {
            case _: ##java.util.InputMismatchException => Err(InputMismatchException)
            case _: ##java.util.NoSuchElementException => Err(NoSuchElementException)
            case _: ##java.lang.IllegalStateException => Err(IllegalStateException)
        }

    pub def hasNextFloat32(sc: PrimitiveScanner): Bool & Impure = 
        import java.util.Scanner.hasNextFloat();
        let PrimitiveScanner(sc1) = sc;
        sc1.hasNextFloat()

    pub def nextFloat32(sc: PrimitiveScanner): Result[Float32, TextScanner.Error] & Impure = 
        import java.util.Scanner.nextFloat();
        try {
            let PrimitiveScanner(sc1) = sc;
            Ok(sc1.nextFloat())
        } catch {
            case _: ##java.util.InputMismatchException => Err(InputMismatchException)
            case _: ##java.util.NoSuchElementException => Err(NoSuchElementException)
            case _: ##java.lang.IllegalStateException => Err(IllegalStateException)
        }

    pub def hasNextFloat64(sc: PrimitiveScanner): Bool & Impure = 
        import java.util.Scanner.hasNextDouble();
        let PrimitiveScanner(sc1) = sc;
        sc1.hasNextDouble()

    pub def nextFloat64(sc: PrimitiveScanner): Result[Float64, TextScanner.Error] & Impure = 
        import java.util.Scanner.nextDouble();
        try {
            let PrimitiveScanner(sc1) = sc;
            Ok(sc1.nextDouble())
        } catch {
            case _: ##java.util.InputMismatchException => Err(InputMismatchException)
            case _: ##java.util.NoSuchElementException => Err(NoSuchElementException)
            case _: ##java.lang.IllegalStateException => Err(IllegalStateException)
        }

    pub def hasNextBool(sc: PrimitiveScanner): Bool & Impure = 
        import java.util.Scanner.hasNextBoolean();
        let PrimitiveScanner(sc1) = sc;
        sc1.hasNextBoolean()

    pub def nextBool(sc: PrimitiveScanner): Result[Bool, TextScanner.Error] & Impure = 
        import java.util.Scanner.nextBoolean();
        try {
            let PrimitiveScanner(sc1) = sc;
            Ok(sc1.nextBoolean())
        } catch {
            case _: ##java.util.InputMismatchException => Err(InputMismatchException)
            case _: ##java.util.NoSuchElementException => Err(NoSuchElementException)
            case _: ##java.lang.IllegalStateException => Err(IllegalStateException)
        }

    pub def hasNextLine(sc: PrimitiveScanner): Bool & Impure = 
        import java.util.Scanner.hasNextLine();
        let PrimitiveScanner(sc1) = sc;
        sc1.hasNextLine()

    pub def nextLine(sc: PrimitiveScanner): Result[String, TextScanner.Error] & Impure = 
        import java.util.Scanner.nextLine();
        try {
            let PrimitiveScanner(sc1) = sc;
            Ok(sc1.nextLine())
        } catch {
            case _: ##java.util.NoSuchElementException => Err(NoSuchElementException)
            case _: ##java.lang.IllegalStateException => Err(IllegalStateException)
        }


    /// Warning throws error if pattern is invalid.
    pub def hasNextMatch(sc: PrimitiveScanner, pattern: String): Result[Bool, TextScanner.Error] & Impure = 
        import java.util.Scanner.hasNext(String);
        try {
            let PrimitiveScanner(sc1) = sc;
            Ok(sc1.hasNext(pattern))
        } catch {
            case _: ##java.lang.IllegalStateException => Err(IllegalStateException)
        }

    pub def nextMatch(sc: PrimitiveScanner, pattern: String): Result[String, TextScanner.Error] & Impure = 
        import java.util.Scanner.next(String);
        try {
            let PrimitiveScanner(sc1) = sc;
            Ok(sc1.next(pattern))
        } catch {
            case _: ##java.util.NoSuchElementException => Err(NoSuchElementException)
            case _: ##java.lang.IllegalStateException => Err(IllegalStateException)
        }

    pub def quoteLiteral(s: String): String = 
        import java.util.regex.Pattern:quote(String);
        quote(s) as & Pure

    
    pub def skip(sc: PrimitiveScanner, pattern: String): Result[Unit, TextScanner.Error] & Impure = 
        import java.util.Scanner.skip(String);
        try {
            let PrimitiveScanner(sc1) = sc;
            sc1.skip(pattern);
            Ok()
        } catch {
            case _: ##java.lang.IllegalStateException => Err(IllegalStateException)
        }

    pub def findInLine(sc: PrimitiveScanner, pattern: String): Result[Option[String], TextScanner.Error] & Impure=
        import java.util.Scanner.findInLine(String);
        let PrimitiveScanner(sc1) = sc;
        try {
            let s = sc1.findInLine(pattern);
            if (isNull(s)) 
                Ok(None) 
            else 
                Ok(Some(s))
        } catch {
            case _: ##java.lang.IllegalArgumentException => Err(IllegalArgumentException)
            case _: ##java.lang.IllegalStateException => Err(IllegalStateException)
        }
    
    pub def findWithinHorizon(sc: PrimitiveScanner, pattern: String, horizon: Int32): Result[Option[String], TextScanner.Error] & Impure=
        import java.util.Scanner.findWithinHorizon(String, Int32);
        let PrimitiveScanner(sc1) = sc;
        try {
            let s = sc1.findWithinHorizon(pattern, horizon);
            if (isNull(s)) 
                Ok(None) 
            else 
                Ok(Some(s))
        } catch {
            case _: ##java.lang.IllegalArgumentException => Err(IllegalArgumentException)
            case _: ##java.lang.IllegalStateException => Err(IllegalStateException)
        }

}