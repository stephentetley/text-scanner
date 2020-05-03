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

use TextScanner/Internal.{PrimitiveScanner => PrimScanner, Pattern};
use TextScanner/Internal.Pattern.{Pattern};
use TextScanner/Internal/PrimitiveScanner.{quoteLiteral};
use Either.{mapLeft};

namespace TextScanner {

    type alias ErrMsg = String

    /// We define our own result type to remind us that a single error is fatal.
    /// Because java.util.Scanner does not allow backtracking we cannot implement
    /// an `alt` combinator. 
    enum ParseResult[a] {
        case PFatal(String, String),
        case POk(a)
    }

    def nextThreeLines(ps: PrimScanner): String & Impure = 
        let x = TextScanner/Internal/PrimitiveScanner.nextLine(ps);
        let y = TextScanner/Internal/PrimitiveScanner.nextLine(ps);
        let z = TextScanner/Internal/PrimitiveScanner.nextLine(ps);
        match (x, y, z) { 
            case (Ok(a), Ok(b), Ok(c))  => String.unlines(a :: b :: c :: Nil)
            case (Ok(a), Ok(b), _)      => String.unlines(a :: b :: Nil)
            case (Ok(a), _, _)          => a
            case (_, _, _)              => ""
        }


    pub enum Scanner[a] {
        case Scanner(PrimScanner -> ParseResult[a] & Impure)
    }

    
    pub def parseString(ma: Scanner[a], s: String): Result[a, String] = 
        parseStringHelper(ma, s) as & Pure
    
    def parseStringHelper(ma: Scanner[a], s: String): Result[a, String] & Impure = 
        let Scanner(f1) = ma;
        let ps = TextScanner/Internal/PrimitiveScanner.fromString(s);
        let ans = f1(ps);
        TextScanner/Internal/PrimitiveScanner.close(ps);        
        match ans {
            case POk(a) => Ok(a)
            case PFatal(msg, rest) => Err(msg + String.lineSeparator() + "Input:" + String.lineSeparator() + rest)
        }

    pub def parseFile(s: Scanner[a], path: System.FilePath, cs: System.Charset): Result[a, String] & Impure = 
        match System/File.readFile(path, cs) {
            case Err(_) => Err("File error")
            case Ok(text) => parseString(s, text)
        }

    pub def return(x: a): Scanner[a] = 
        Scanner(_ -> POk(x) as & Impure)

    pub def throwError(msg: String): Scanner[a] = 
        Scanner(ps -> PFatal(msg, nextThreeLines(ps)) as & Impure)

    pub def swapError(msg: String, ma: Scanner[a]): Scanner[a] = 
        Scanner(ps -> 
            let Scanner(f1) = ma;
            match f1(ps) {
                case PFatal(_, rest) => PFatal(msg, rest)
                case POk(a) => POk(a)
            }
        )


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

    pub def select(ma: Scanner[Either[a,b]],  mf: Scanner[a -> b]): Scanner[b] = 
        bind(ma,
            e -> match e {
                case Left(a) => map(f -> f(a), mf)
                case Right(b) => return(b)
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

    pub def seqLeft(ma: Scanner[a], mb: Scanner[b]): Scanner[a] = 
        let* a = ma;
        let* _ = mb;
        return(a)

    pub def seqRight(ma :Scanner[a], mb: Scanner[b]): Scanner[b] = 
        let* _ = ma;
        let* b = mb;
        return(b)

    pub def when(ma: Scanner[Bool], mb: Scanner[Unit]): Scanner[Unit] = 
        let selector = map(x -> if (x) Right(()) else Left(()), ma);
        let effect   = map((a,_) -> a, mb);
        select(selector, effect)

    pub def branch(ma: Scanner[Either[a,b]], mleft: Scanner[a -> c], mright: Scanner[b -> c]): Scanner[c] = 
        let* a = ma;
        match a {
            case Left(x) => ap(mleft, return(x))
            case Right(y) => ap(mright, return(y))
        }
        
    pub def ifS(ma: Scanner[Bool], mt: Scanner[a], mf: Scanner[a]): Scanner[a] = 
        let* a = ma;
        if (a) mt else mf

    pub def or(ma: Scanner[Bool], mb: Scanner[Bool]): Scanner[Bool] = 
        let* a = ma;
        if (a) return(true) else mb


    pub def and(ma: Scanner[Bool], mb: Scanner[Bool]): Scanner[Bool] = 
        let* a = ma;
        if (a) mb else return(false)

    pub def fromOption(d: Scanner[a], ma: Scanner[Option[a]]): Scanner[a] = 
        let* a = ma;
        match a { 
            case Some(x) => return(x)
            case None => d
        }

    pub def fromSome(ma: Scanner[Option[a]]): Scanner[a] = 
        let* a = ma;
        match a { 
            case Some(x) => return(x)
            case None => throwError("fromSome")
        }

    // pub def someSeqRight(ma: Scanner[Option[a]], mb: Scanner[b]): Scanner[Option[b]] = 
    //     let* a = ma;
    //     match a { 
    //         case Some(_) => { let* b = mb; return(Some(b)) }
    //         case None => return(None)
    //     }

    pub def liftResult(x: Result[t, String]): Scanner[t] =
        match x { 
            case Ok(a) => return(a)
            case Err(msg) => throwError(msg)
        }

    pub def liftAction( f: () -> Unit & Impure): Scanner[Unit] =
        Scanner(_ -> { f(); POk() })


    pub def any(p: a -> Scanner[Bool], xs: List[a]): Scanner[Bool] = 
        List.foldRight((a,b) -> or(b, p(a)), return(false),  xs)

    pub def all(p: a -> Scanner[Bool], xs: List[a]): Scanner[Bool] = 
        List.foldRight((a,b) -> and(b, p(a)), return(true),  xs)


    pub def while(s: Scanner[Bool]): Scanner[Unit] = 
        let* a = s;
        if (!a) return() else while(s)


    pub def manyWhileSome(p: Scanner[Option[a]], r: a -> Scanner[b]): Scanner[List[b]] = 
        manyWhileSomeHelper(p, r, xs -> xs)

    pub def manyWhileSomeHelper(p: Scanner[Option[a]], r: a -> Scanner[b], k: List[b] -> List[b]): Scanner[List[b]] = 
        let* a = p;
        match a { 
            case None => return(k(Nil))
            case Some(b) => { 
                let* x = r(b);
                manyWhileSomeHelper(p, r, xs -> k(x :: xs))
            }
        } 
             

    pub def manyWhileTrue(p: Scanner[Bool], r: Scanner[a]): Scanner[List[a]] = 
        manyWhileTrueHelper(p, r, xs -> xs)

    pub def manyWhileTrueHelper(p: Scanner[Bool], r: Scanner[a], k: List[a] -> List[a]): Scanner[List[a]] = 
        let* a = p;
        if (!a) 
            return(k(Nil)) 
        else {
            let* x = r;
            manyWhileTrueHelper(p, r, xs -> k(x :: xs))
        }

    def getDelimiter(): Scanner[Pattern] = 
        Scanner(ps -> POk(TextScanner/Internal/PrimitiveScanner.getDelimiter(ps)))

    def setDelimiter(patt: Pattern): Scanner[Unit] = 
        Scanner(ps -> POk(TextScanner/Internal/PrimitiveScanner.setDelimiter(ps, patt)))
    
    pub def withDelimiter(pattern: String, s: Scanner[a]): Scanner[a] =         
        let* oldpatt = getDelimiter();
        let* newpatt = liftResult(TextScanner/Internal/PrimitiveScanner.compilePattern(pattern));
        let* _ = setDelimiter(newpatt);
        let* ans = s;
        let* _ = setDelimiter(oldpatt);
        return(ans)


    pub def scanLine(delimiter: Option[String], s:Scanner[a]): Scanner[a] = 
        let* line1 = nextLine();
        let* delim = match delimiter { 
            case None => getDelimiter()
            case Some(patt) => liftResult(TextScanner/Internal/PrimitiveScanner.compilePattern(patt))
        };
        match parseString(setDelimiter(delim) `seqRight` s, line1) {
            case Ok(a) => return(a)
            case Err(msg) => throwError(msg)
        }
        

    pub def countWhile(s: Scanner[Bool]): Scanner[Int32] = 
        countWhileHelper(s, 0)

    def countWhileHelper(s: Scanner[Bool], n: Int32): Scanner[Int32] = 
        let* a = s;
        if (!a) return(n) else countWhileHelper(s, n+1)

    pub def ignore(s: Scanner[a]): Scanner[Unit] = 
        let* _ = s;
        return()

    pub def alt(s1: Scanner[Option[a]], s2: Scanner[Option[a]]): Scanner[a] = 
        let* a = s1;
        match a { 
            case None => fromSome(s2)
            case Some(x) => return(x)
        }

    def liftPrimHasNext(f: PrimScanner -> Bool & Impure): Scanner[Bool] = 
        Scanner(ps -> POk(f(ps)))

    def liftPrimNext(f: PrimScanner -> Result[a, String] & Impure): Scanner[a] = 
        Scanner(ps -> 
            match f(ps) {
                case Ok(a) => POk(a)
                case Err(msg) => PFatal(msg, nextThreeLines(ps))
            }
        )

    def liftPrimHasNextResult(f: PrimScanner -> Result[Bool, String] & Impure): Scanner[Bool] = 
        liftPrimNext(f) 

    pub def hasNext(): Scanner[Bool] = 
        liftPrimHasNext(TextScanner/Internal/PrimitiveScanner.hasNext)

    pub def next(): Scanner[String] = 
        liftPrimNext(TextScanner/Internal/PrimitiveScanner.next)

    pub def hasNextInt8(): Scanner[Bool] = 
        liftPrimHasNext(TextScanner/Internal/PrimitiveScanner.hasNextInt8)

    pub def nextInt8(): Scanner[Int8] = 
        liftPrimNext(TextScanner/Internal/PrimitiveScanner.nextInt8)

    pub def hasNextInt16(): Scanner[Bool] = 
        liftPrimHasNext(TextScanner/Internal/PrimitiveScanner.hasNextInt16)

    pub def nextInt16(): Scanner[Int16] = 
        liftPrimNext(TextScanner/Internal/PrimitiveScanner.nextInt16)

    pub def hasNextInt32(): Scanner[Bool] = 
        liftPrimHasNext(TextScanner/Internal/PrimitiveScanner.hasNextInt32)

    pub def nextInt32(): Scanner[Int32] = 
        liftPrimNext(TextScanner/Internal/PrimitiveScanner.nextInt32)

    pub def hasNextInt64(): Scanner[Bool] = 
        liftPrimHasNext(TextScanner/Internal/PrimitiveScanner.hasNextInt64)

    pub def nextInt64(): Scanner[Int64] = 
        liftPrimNext(TextScanner/Internal/PrimitiveScanner.nextInt64)

    pub def hasNextBigInt(): Scanner[Bool] = 
        liftPrimHasNext(TextScanner/Internal/PrimitiveScanner.hasNextBigInt)

    pub def nextBigInt(): Scanner[BigInt] = 
        liftPrimNext(TextScanner/Internal/PrimitiveScanner.nextBigInt)

    pub def hasNextFloat32(): Scanner[Bool] = 
        liftPrimHasNext(TextScanner/Internal/PrimitiveScanner.hasNextFloat32)

    pub def nextFloat32(): Scanner[Float32] = 
        liftPrimNext(TextScanner/Internal/PrimitiveScanner.nextFloat32)

    pub def hasNextFloat64(): Scanner[Bool] = 
        liftPrimHasNext(TextScanner/Internal/PrimitiveScanner.hasNextFloat64)

    pub def nextFloat64(): Scanner[Float64] = 
        liftPrimNext(TextScanner/Internal/PrimitiveScanner.nextFloat64)

    pub def hasNextBool(): Scanner[Bool] = 
        liftPrimHasNext(TextScanner/Internal/PrimitiveScanner.hasNextBool)

    pub def nextBool(): Scanner[Bool] = 
        liftPrimNext(TextScanner/Internal/PrimitiveScanner.nextBool)

    pub def hasNextLine(): Scanner[Bool] = 
        liftPrimHasNext(TextScanner/Internal/PrimitiveScanner.hasNextLine)

    pub def nextLine(): Scanner[String] = 
        liftPrimNext(TextScanner/Internal/PrimitiveScanner.nextLine)

    pub def hasNextMatch(pattern: String): Scanner[Bool] = 
        liftPrimHasNextResult(ps -> TextScanner/Internal/PrimitiveScanner.hasNextMatch(ps, pattern)) 
        
    pub def nextMatch(pattern: String): Scanner[String] = 
        liftPrimNext(ps -> TextScanner/Internal/PrimitiveScanner.nextMatch(ps, pattern))

    // `s` should not contain spaces
    pub def hasNextLiteral(s: String): Scanner[Bool] = 
        hasNextMatch(quoteLiteral(s))
    
    // `s` should not contain space
    pub def nextLiteral(s: String): Scanner[Unit] = 
        nextMatch(quoteLiteral(s)) |> ignore

    pub def tryMatch(pattern: String): Scanner[Option[String]] = 
        ifS(hasNextMatch(pattern), map(Some, nextMatch(pattern)), return(None))

    pub def tryLiteral(s: String): Scanner[Option[Unit]] = 
        tryMatch(quoteLiteral(s)) |> map(Option.map(_ -> ()))

    pub def skipMatch(pattern: String): Scanner[Unit] = 
        liftPrimNext(ps -> TextScanner/Internal/PrimitiveScanner.skip(ps, pattern))

    pub def skipString(s: String): Scanner[Unit] = 
        skipMatch(quoteLiteral(s))

    pub def findMatch(pattern: String): Scanner[Option[String]] = 
        findMatchWithinHorizon(pattern, 0)

    pub def findString(s: String): Scanner[Option[Unit]] = 
        findStringWithinHorizon(s, 0)

    pub def anchorMatch(pattern: String): Scanner[String] = 
        let* a = findMatchWithinHorizon(pattern, 0);
        match a { 
            case None => throwError("anchorMatch")
            case Some(x) => return(x)
        }
        
    pub def anchorString(s: String): Scanner[Unit] = 
        anchorMatch(quoteLiteral(s)) |> ignore


    pub def findMatchWithinHorizon(pattern: String, horizon: Int32): Scanner[Option[String]] = 
        liftPrimNext(ps -> TextScanner/Internal/PrimitiveScanner.findWithinHorizon(ps, pattern, horizon))

    /// can have spaces 
    pub def findStringWithinHorizon(s: String, horizon: Int32): Scanner[Option[Unit]] = 
        findMatchWithinHorizon(quoteLiteral(s), horizon) |> map(Option.map(_ -> ()))

    pub def findMatchInLine(pattern: String): Scanner[Option[String]] = 
        liftPrimNext(ps -> TextScanner/Internal/PrimitiveScanner.findInLine(ps, pattern))

    /// can have spaces 
    pub def findStringInLine(s: String): Scanner[Option[Unit]] = 
        findMatchInLine(quoteLiteral(s)) |> map(Option.map(_ -> ()))


    
    pub def anchorMatchInLine(pattern: String): Scanner[String] = 
        let* a = findMatchInLine(pattern);
        match a { 
            case None => throwError("anchorMatchInLine")
            case Some(x) => return(x)
        }
        
    /// can have spaces        
    pub def anchorStringInLine(s: String): Scanner[Unit] = 
        anchorMatchInLine(quoteLiteral(s)) |> ignore


    pub def count(n: Int32, sc: Scanner[a]): Scanner[List[a]] = 
        Scanner(ps -> 
            let Scanner(f1) = sc;
            countHelper(ps, n, f1, 0, (s,t) -> PFatal(s,t), xs -> POk(xs))
        )

    def countHelper(ps: PrimScanner, n: Int32, f1: PrimScanner -> ParseResult[a] & Impure, i: Int32, fk: (ErrMsg, String) -> ParseResult[List[a]], sk: List[a] -> ParseResult[List[a]]): ParseResult[List[a]] & Impure = 
        if (i >= n) 
            sk(Nil)
        else {
            match f1(ps) {
                case POk(a) => countHelper(ps, n, f1, i+1, fk, xs -> sk(a :: xs))
                case PFatal(msg, rest) => fk(msg, rest)
            }
        }

    
}