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

use TextScanner/Internal.{PrimitiveScanner => PrimScanner};

namespace TextScanner {

    type alias ErrMsg = String

    /// We define our own result type to remind us that a single error is fatal.
    /// Because java.util.Scanner does not allow backtracking we cannot implement
    /// an `alt` combinator. 
    enum ParseResult[a] {
        case PFatal(String),
        case POk(a)
    }

    pub enum Scanner[ans] {
        case Scanner(PrimScanner -> ParseResult[ans] & Impure)
    }

    pub def runWithString(ma: Scanner[a], s: String): Result[a, String] = 
        runWithStringHelper(ma, s) as & Pure
    
    pub def runWithStringHelper(ma: Scanner[a], s: String): Result[a, String] & Impure = 
        let Scanner(f1) = ma;
        let ps = TextScanner/Internal/PrimitiveScanner.fromString(s);
        match f1(ps) {
            case POk(a) => Ok(a)
            case PFatal(msg) => Err(msg)
        }

    pub def return(x: a): Scanner[a] = 
        Scanner(_ -> POk(x) as & Impure)

    pub def throwError(msg: String): Scanner[a] = 
        Scanner(_ -> PFatal(msg) as & Impure)

    pub def map(f: a -> b, ma: Scanner[a]): Scanner[b] = 
        Scanner(ps -> 
            let Scanner(f1) = ma;
            match f1(ps) {
                case PFatal(msg) => PFatal(msg)
                case POk(a) => POk(f(a))
            }
        )
    
    pub def ap(mf: Scanner[a -> b], ma: Scanner[a]): Scanner[b] = 
        Scanner(ps -> 
            let Scanner(f1) = mf;
            match f1(ps) {
                case PFatal(msg) => PFatal(msg)
                case POk(f) => {
                    let Scanner(f2) = ma;
                    match f2(ps) {
                        case PFatal(msg) => PFatal(msg)
                        case POk(a) => POk(f(a))
                    }
                }
            }
        )

    pub def bind(ma: Scanner[a], k: a -> Scanner[b]): Scanner[b] = 
        Scanner(ps -> 
            let Scanner(f1) = ma;
            match f1(ps) {
                case PFatal(msg) => PFatal(msg)
                case POk(a) => {
                    let Scanner(f2) = k(a);
                    f2(ps)                    
                }
            }
        )

    pub def flatMap(k: a -> Scanner[b], ma: Scanner[a]): Scanner[b] = bind(ma, k)


    def liftHasNext(f: PrimScanner -> Bool & Impure): Scanner[Bool] = 
        Scanner(ps -> POk(f(ps)))

    def liftNext(f: PrimScanner -> Result[a, String] & Impure): Scanner[a] = 
        Scanner(ps -> 
            match f(ps) {
                case Ok(a) => POk(a)
                case Err(msg) => PFatal(msg)
            }
        )

    pub def hasNext(): Scanner[Bool] = 
        liftHasNext(TextScanner/Internal/PrimitiveScanner.hasNext)

    pub def next(): Scanner[String] = 
        liftNext(TextScanner/Internal/PrimitiveScanner.next)

    pub def hasNextInt8(): Scanner[Bool] = 
        liftHasNext(TextScanner/Internal/PrimitiveScanner.hasNextInt8)

    pub def nextInt8(): Scanner[Int8] = 
        liftNext(TextScanner/Internal/PrimitiveScanner.nextInt8)

    pub def hasNextInt16(): Scanner[Bool] = 
        liftHasNext(TextScanner/Internal/PrimitiveScanner.hasNextInt16)

    pub def nextInt16(): Scanner[Int16] = 
        liftNext(TextScanner/Internal/PrimitiveScanner.nextInt16)

    pub def hasNextInt32(): Scanner[Bool] = 
        liftHasNext(TextScanner/Internal/PrimitiveScanner.hasNextInt32)

    pub def nextInt32(): Scanner[Int32] = 
        liftNext(TextScanner/Internal/PrimitiveScanner.nextInt32)

    pub def hasNextInt64(): Scanner[Bool] = 
        liftHasNext(TextScanner/Internal/PrimitiveScanner.hasNextInt64)

    pub def nextInt64(): Scanner[Int64] = 
        liftNext(TextScanner/Internal/PrimitiveScanner.nextInt64)

    pub def hasNextBigInt(): Scanner[Bool] = 
        liftHasNext(TextScanner/Internal/PrimitiveScanner.hasNextBigInt)

    pub def nextBigInt(): Scanner[BigInt] = 
        liftNext(TextScanner/Internal/PrimitiveScanner.nextBigInt)

    pub def hasNextFloat32(): Scanner[Bool] = 
        liftHasNext(TextScanner/Internal/PrimitiveScanner.hasNextFloat32)

    pub def nextFloat32(): Scanner[Float32] = 
        liftNext(TextScanner/Internal/PrimitiveScanner.nextFloat32)

    pub def hasNextFloat64(): Scanner[Bool] = 
        liftHasNext(TextScanner/Internal/PrimitiveScanner.hasNextFloat64)

    pub def nextFloat64(): Scanner[Float64] = 
        liftNext(TextScanner/Internal/PrimitiveScanner.nextFloat64)

    pub def hasNextBool(): Scanner[Bool] = 
        liftHasNext(TextScanner/Internal/PrimitiveScanner.hasNextBool)

    pub def nextBool(): Scanner[Bool] = 
        liftNext(TextScanner/Internal/PrimitiveScanner.nextBool)

    pub def hasNextLine(): Scanner[Bool] = 
        liftHasNext(TextScanner/Internal/PrimitiveScanner.hasNextLine)

    pub def nextLine(): Scanner[String] = 
        liftNext(TextScanner/Internal/PrimitiveScanner.nextLine)

    pub def hasNextMatch(pattern: String): Scanner[a] = 
        Scanner(ps -> 
            match TextScanner/Internal/PrimitiveScanner.hasNextMatch(ps, pattern) {
                case Ok(a) => POk(a)
                case Err(msg) => PFatal(msg)
            }
        )

    pub def nextMatch(pattern: String): Scanner[String] = 
        Scanner(ps -> 
            match TextScanner/Internal/PrimitiveScanner.nextMatch(ps, pattern) {
                case Ok(a) => POk(a)
                case Err(msg) => PFatal(msg)
            }
        )

    pub def skip(pattern: String): Scanner[Unit] = 
        Scanner(ps -> 
            match TextScanner/Internal/PrimitiveScanner.skip(ps, pattern) {
                case Ok(a) => POk(a)
                case Err(msg) => PFatal(msg)
            }
        )

    pub def count(n: Int32, sc: Scanner[a]): Scanner[List[a]] = 
        Scanner(ps -> 
            let Scanner(f1) = sc;
            countHelper(ps, n, f1, 0, s -> PFatal(s), xs -> POk(xs))
        )

    def countHelper(ps: PrimScanner, n: Int32, f1: PrimScanner -> ParseResult[a] & Impure, i: Int32, fk: ErrMsg -> ParseResult[List[a]], sk: List[a] -> ParseResult[List[a]]): ParseResult[List[a]] & Impure = 
        if (i >= n)
            sk(Nil)
        else {
            match f1(ps) {
                case POk(a) => countHelper(ps, n, f1, i+1, fk, xs -> sk(a :: xs))
                case PFatal(msg) => fk(msg)
            }
        }

    
}