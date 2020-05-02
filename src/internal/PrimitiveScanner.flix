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

    pub def nextInt8(sc: PrimitiveScanner): Result[Int8, String] & Impure = 
        import java.util.Scanner.nextByte();
        try {
            let PrimitiveScanner(sc1) = sc;
            Ok(sc1.nextByte())
        } catch {
            case _: ##java.util.InputMismatchException => Err("Err - not an Int8")
            case _: ##java.util.NoSuchElementException => Err("Err - no more tokens")
            case _: ##java.lang.IllegalStateException => Err("Err - scanner is closed")
        }

    pub def hasNextInt16(sc: PrimitiveScanner): Bool & Impure = 
        import java.util.Scanner.hasNextShort();
        let PrimitiveScanner(sc1) = sc;
        sc1.hasNextShort()

    pub def nextInt16(sc: PrimitiveScanner): Result[Int16, String] & Impure = 
        import java.util.Scanner.nextShort();
        try {
            let PrimitiveScanner(sc1) = sc;
            Ok(sc1.nextShort())            
        } catch {
            case _: ##java.util.InputMismatchException => Err("Err - not an Int16")
            case _: ##java.util.NoSuchElementException => Err("Err - no more tokens")
            case _: ##java.lang.IllegalStateException => Err("Err - scanner is closed")
        }

    pub def hasNextInt32(sc: PrimitiveScanner): Bool & Impure = 
        import java.util.Scanner.hasNextInt();
        let PrimitiveScanner(sc1) = sc;
        sc1.hasNextInt()

    pub def nextInt32(sc: PrimitiveScanner): Result[Int32, String] & Impure = 
        import java.util.Scanner.nextInt();
        try {
            let PrimitiveScanner(sc1) = sc;
            Ok(sc1.nextInt())
        } catch {
            case _: ##java.util.InputMismatchException => Err("Err - not an Int32")
            case _: ##java.util.NoSuchElementException => Err("Err - no more tokens")
            case _: ##java.lang.IllegalStateException => Err("Err - scanner is closed")
        }

    pub def hasNextInt64(sc: PrimitiveScanner): Bool & Impure = 
        import java.util.Scanner.hasNextLong();
        let PrimitiveScanner(sc1) = sc;
        sc1.hasNextLong()

    pub def nextInt64(sc: PrimitiveScanner): Result[Int64, String] & Impure = 
        import java.util.Scanner.nextLong();
        try { 
            let PrimitiveScanner(sc1) = sc;
            Ok(sc1.nextLong())        
        } catch {
            case _: ##java.util.InputMismatchException => Err("Err - not an Int64")
            case _: ##java.util.NoSuchElementException => Err("Err - no more tokens")
            case _: ##java.lang.IllegalStateException => Err("Err - scanner is closed")
        }

    pub def hasNextBigInt(sc: PrimitiveScanner): Bool & Impure = 
        import java.util.Scanner.hasNextBigInteger();
        let PrimitiveScanner(sc1) = sc;
        sc1.hasNextBigInteger()

    pub def nextBigInt(sc: PrimitiveScanner): Result[BigInt, String] & Impure = 
        import java.util.Scanner.nextBigInteger();
        try {
            let PrimitiveScanner(sc1) = sc;
            Ok(sc1.nextBigInteger())
        } catch {
            case _: ##java.util.InputMismatchException => Err("Err - not a BitInt")
            case _: ##java.util.NoSuchElementException => Err("Err - no more tokens")
            case _: ##java.lang.IllegalStateException => Err("Err - scanner is closed")
        }

    pub def hasNextFloat32(sc: PrimitiveScanner): Bool & Impure = 
        import java.util.Scanner.hasNextFloat();
        let PrimitiveScanner(sc1) = sc;
        sc1.hasNextFloat()

    pub def nextFloat32(sc: PrimitiveScanner): Result[Float32, String] & Impure = 
        import java.util.Scanner.nextFloat();
        try {
            let PrimitiveScanner(sc1) = sc;
            Ok(sc1.nextFloat())
        } catch {
            case _: ##java.util.InputMismatchException => Err("Err - not a Float32")
            case _: ##java.util.NoSuchElementException => Err("Err - no more tokens")
            case _: ##java.lang.IllegalStateException => Err("Err - scanner is closed")
        }

    pub def hasNextFloat64(sc: PrimitiveScanner): Bool & Impure = 
        import java.util.Scanner.hasNextDouble();
        let PrimitiveScanner(sc1) = sc;
        sc1.hasNextDouble()

    pub def nextFloat64(sc: PrimitiveScanner): Result[Float64, String] & Impure = 
        import java.util.Scanner.nextDouble();
        try {
            let PrimitiveScanner(sc1) = sc;
            Ok(sc1.nextDouble())
        } catch {
            case _: ##java.util.InputMismatchException => Err("Err - not a Float64")
            case _: ##java.util.NoSuchElementException => Err("Err - no more tokens")
            case _: ##java.lang.IllegalStateException => Err("Err - scanner is closed")
        }

    pub def hasNextBool(sc: PrimitiveScanner): Bool & Impure = 
        import java.util.Scanner.hasNextBoolean();
        let PrimitiveScanner(sc1) = sc;
        sc1.hasNextBoolean()

    pub def nextBool(sc: PrimitiveScanner): Result[Bool, String] & Impure = 
        import java.util.Scanner.nextBoolean();
        try {
            let PrimitiveScanner(sc1) = sc;
            Ok(sc1.nextBoolean())
        } catch {
            case _: ##java.util.InputMismatchException => Err("Err - not a Bool")
            case _: ##java.util.NoSuchElementException => Err("Err - no more tokens")
            case _: ##java.lang.IllegalStateException => Err("Err - scanner is closed")
        }

    pub def hasNextLine(sc: PrimitiveScanner): Bool & Impure = 
        import java.util.Scanner.hasNextLine();
        let PrimitiveScanner(sc1) = sc;
        sc1.hasNextLine()

    pub def nextLine(sc: PrimitiveScanner): Result[String, String] & Impure = 
        import java.util.Scanner.nextLine();
        try {
            let PrimitiveScanner(sc1) = sc;
            Ok(sc1.nextLine())
        } catch {
            case _: ##java.util.NoSuchElementException => Err("Err - no more tokens")
            case _: ##java.lang.IllegalStateException => Err("Err - scanner is closed")
        }


    /// Warning throws error if pattern is invalid.
    pub def hasNextMatch(sc: PrimitiveScanner, pattern: String): Result[Bool, String] & Impure = 
        import java.util.Scanner.hasNext(String);
        try {
            let PrimitiveScanner(sc1) = sc;
            Ok(sc1.hasNext(pattern))
        } catch {
            case _: ##java.lang.IllegalStateException => Err("Err - scanner is closed")
        }

    pub def nextMatch(sc: PrimitiveScanner, pattern: String): Result[String, String] & Impure = 
        import java.util.Scanner.next(String);
        try {
            let PrimitiveScanner(sc1) = sc;
            Ok(sc1.next(pattern))
        } catch {
            case _: ##java.util.NoSuchElementException => Err("Err - no more tokens")
            case _: ##java.lang.IllegalStateException => Err("Err - scanner is closed")
        }

    pub def quoteLiteral(s: String): String = 
        import java.util.regex.Pattern:quote(String);
        quote(s) as & Pure

    /// Should not contain whitespace
    pub def hasNextToken(sc: PrimitiveScanner, s: String): Result[Bool, String] & Impure = 
        hasNextMatch(sc, quoteLiteral(s))

    /// Should not contain whitespace
    pub def nextToken(sc: PrimitiveScanner, s: String): Result[String, String] & Impure = 
        nextMatch(sc, quoteLiteral(s))

    pub def skip(sc: PrimitiveScanner, pattern: String): Result[Unit, String] & Impure = 
        import java.util.Scanner.skip(String);
        try {
            let PrimitiveScanner(sc1) = sc;
            sc1.skip(pattern);
            Ok()
        } catch {
            case _: ##java.lang.IllegalStateException => Err("Err - scanner is closed")
        }

    pub def skipString(sc: PrimitiveScanner, s: String): Result[Unit, String] & Impure = 
        skip(sc, quoteLiteral(s))

    pub def findWithinHorizon(sc: PrimitiveScanner, pattern: String, horizon: Int32): Result[Option[String], String] & Impure=
        import java.util.Scanner.findWithinHorizon(String, Int32);
        let PrimitiveScanner(sc1) = sc;
        try {
            let s = sc1.findWithinHorizon(pattern, horizon);
            if (isNull(s)) 
                Ok(None) 
            else 
                Ok(Some(s))
        } catch {
            case _: ##java.lang.IllegalArgumentException => Err("Err - illegal argument")
            case _: ##java.lang.IllegalStateException => Err("Err - scanner is closed")
        }
    
}