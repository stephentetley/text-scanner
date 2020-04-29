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

use TextScanner/Internal.PrimitiveScanner;
use TextScanner/Internal.PrimitiveScanner.{PrimitiveScanner};

namespace TextScanner/Internal {

    pub opaque type PrimitiveScanner = ##java.util.Scanner

}

namespace TextScanner/Internal/PrimitiveScanner {



    pub def fromString(s: String): PrimitiveScanner & Impure = 
        import new java.util.Scanner(String) as newScanner;
        PrimitiveScanner(newScanner(s)) 

    pub def hasNext(sc: PrimitiveScanner): Bool & Impure = 
        import java.util.Scanner.hasNext();
        let PrimitiveScanner(sc1) = sc;
        sc1.hasNext()

    pub def next(sc: PrimitiveScanner): Result[String, String] & Impure = 
        import java.util.Scanner.next();
        try {
            let PrimitiveScanner(sc1) = sc;
            Ok(sc1.next())
        } catch {
            case _: ##java.util.NoSuchElementException => Err("Err - no more tokens")
            case _: ##java.lang.IllegalStateException => Err("Err - scanner is closed")
        }


    pub def hasNextInt8(sc: PrimitiveScanner): Bool & Impure = 
        import java.util.Scanner.hasNextByte();
        let PrimitiveScanner(sc1) = sc;
        sc1.hasNextByte()

    pub def nextInt8(sc: PrimitiveScanner): Int8 & Impure = 
        import java.util.Scanner.nextByte();
        let PrimitiveScanner(sc1) = sc;
        sc1.nextByte()

    pub def hasNextInt16(sc: PrimitiveScanner): Bool & Impure = 
        import java.util.Scanner.hasNextShort();
        let PrimitiveScanner(sc1) = sc;
        sc1.hasNextShort()

    pub def nextInt16(sc: PrimitiveScanner): Int16 & Impure = 
        import java.util.Scanner.nextShort();
        let PrimitiveScanner(sc1) = sc;
        sc1.nextShort()

    pub def hasNextInt32(sc: PrimitiveScanner): Bool & Impure = 
        import java.util.Scanner.hasNextInt();
        let PrimitiveScanner(sc1) = sc;
        sc1.hasNextInt()

    pub def nextInt32(sc: PrimitiveScanner): Int32 & Impure = 
        import java.util.Scanner.nextInt();
        let PrimitiveScanner(sc1) = sc;
        sc1.nextInt()

    pub def hasNextInt64(sc: PrimitiveScanner): Bool & Impure = 
        import java.util.Scanner.hasNextLong();
        let PrimitiveScanner(sc1) = sc;
        sc1.hasNextLong()

    pub def nextInt64(sc: PrimitiveScanner): Int64 & Impure = 
        import java.util.Scanner.nextLong();
        let PrimitiveScanner(sc1) = sc;
        sc1.nextLong()

    pub def hasNextBigInt(sc: PrimitiveScanner): Bool & Impure = 
        import java.util.Scanner.hasNextBigInteger();
        let PrimitiveScanner(sc1) = sc;
        sc1.hasNextBigInteger()

    pub def nextBigInt(sc: PrimitiveScanner): BigInt & Impure = 
        import java.util.Scanner.nextBigInteger();
        let PrimitiveScanner(sc1) = sc;
        sc1.nextBigInteger()

    pub def hasNextFloat32(sc: PrimitiveScanner): Bool & Impure = 
        import java.util.Scanner.hasNextFloat();
        let PrimitiveScanner(sc1) = sc;
        sc1.hasNextFloat()

    pub def nextFloat32(sc: PrimitiveScanner): Float32 & Impure = 
        import java.util.Scanner.nextFloat();
        let PrimitiveScanner(sc1) = sc;
        sc1.nextFloat()

    pub def hasNextFloat64(sc: PrimitiveScanner): Bool & Impure = 
        import java.util.Scanner.hasNextDouble();
        let PrimitiveScanner(sc1) = sc;
        sc1.hasNextDouble()

    pub def nextFloat64(sc: PrimitiveScanner): Float64 & Impure = 
        import java.util.Scanner.nextDouble();
        let PrimitiveScanner(sc1) = sc;
        sc1.nextDouble()

    pub def hasNextBool(sc: PrimitiveScanner): Bool & Impure = 
        import java.util.Scanner.hasNextBoolean();
        let PrimitiveScanner(sc1) = sc;
        sc1.hasNextBoolean()

    pub def nextBool(sc: PrimitiveScanner): Bool & Impure = 
        import java.util.Scanner.nextBoolean();
        let PrimitiveScanner(sc1) = sc;
        sc1.nextBoolean()

    pub def hasNextLine(sc: PrimitiveScanner): Bool & Impure = 
        import java.util.Scanner.hasNextLine();
        let PrimitiveScanner(sc1) = sc;
        sc1.hasNextLine()

    pub def nextLine(sc: PrimitiveScanner): String & Impure = 
        import java.util.Scanner.nextLine();
        let PrimitiveScanner(sc1) = sc;
        sc1.nextLine()


    pub def hasNextLiteral(sc: PrimitiveScanner, lit: String): Bool & Impure = 
        import java.util.Scanner.hasNext(String);
        let PrimitiveScanner(sc1) = sc;
        sc1.hasNext(lit)

    pub def nextLiteral(sc: PrimitiveScanner, lit: String): String & Impure = 
        import java.util.Scanner.next(String);
        let PrimitiveScanner(sc1) = sc;
        sc1.next(lit)


    /// Warning throws error if pattern is invalid.
    pub def hasNextMatch(sc: PrimitiveScanner, regex: String): Result[Bool, String] & Impure = 
        import java.util.Scanner.hasNext(##java.util.regex.Pattern);
        import java.util.regex.Pattern:compile(String);
        try {
            let PrimitiveScanner(sc1) = sc;
            let patt: ##java.util.regex.Pattern = compile(regex);
            Ok(sc1.hasNext(patt))
        } catch {
            case _: ##java.util.regex.PatternSyntaxException => Err("TextScanner/Internal.PrimitiveScanner.hasNextMatch - pattern syntax error")
            case _: ##java.lang.IllegalArgumentException =>  Err("TextScanner/Internal.PrimitiveScanner.hasNextMatch - illegal argument error")
        }


    pub def nextMatch(sc: PrimitiveScanner, regex: String): Result[String, String] & Impure = 
        import java.util.Scanner.next(##java.util.regex.Pattern);        
        import java.util.regex.Pattern:compile(String);
        try {
            let PrimitiveScanner(sc1) = sc;
            let patt: ##java.util.regex.Pattern = compile(regex);
            Ok(sc1.next(patt))
        } catch {
            case _: ##java.util.regex.PatternSyntaxException => Err("TextScanner/Internal/PrimitiveScanner.nextMatch - pattern syntax error")
            case _: ##java.lang.IllegalArgumentException =>  Err("TextScanner/Internal/PrimitiveScanner.nextMatch - illegal argument error")
        }




}