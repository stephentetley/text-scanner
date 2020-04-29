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
        let sc = TextScanner/Internal/PrimitiveScanner.fromString(s);
        match f1(sc) {
            case POk(a) => Ok(a)
            case PFatal(msg) => Err(msg)
        }

    pub def return(x: a): Scanner[a] = 
        Scanner(_ -> POk(x) as & Impure)

    pub def throwError(msg: String): Scanner[a] = 
        Scanner(_ -> PFatal(msg) as & Impure)

    pub def map(f: a -> b, ma: Scanner[a]): Scanner[b] = 
        Scanner(sc -> 
            let Scanner(f1) = ma;
            match f1(sc) {
                case PFatal(msg) => PFatal(msg)
                case POk(a) => POk(f(a))
            }
        )
    
    pub def ap(mf: Scanner[a -> b], ma: Scanner[a]): Scanner[b] = 
        Scanner(sc -> 
            let Scanner(f1) = mf;
            match f1(sc) {
                case PFatal(msg) => PFatal(msg)
                case POk(f) => {
                    let Scanner(f2) = ma;
                    match f2(sc) {
                        case PFatal(msg) => PFatal(msg)
                        case POk(a) => POk(f(a))
                    }
                }
            }
        )

    pub def bind(ma: Scanner[a], k: a -> Scanner[b]): Scanner[b] = 
        Scanner(sc -> 
            let Scanner(f1) = ma;
            match f1(sc) {
                case PFatal(msg) => PFatal(msg)
                case POk(a) => {
                    let Scanner(f2) = k(a);
                    f2(sc)                    
                }
            }
        )

    pub def flatMap(k: a -> Scanner[b], ma: Scanner[a]): Scanner[b] = bind(ma, k)


    def liftNext(f: PrimScanner -> Result[a, String] & Impure): Scanner[a] = 
        Scanner(sc -> 
            match f(sc) {
                case Ok(a) => POk(a)
                case Err(msg) => PFatal(msg)
            }
        )


    pub def next(): Scanner[String] = 
        liftNext(TextScanner/Internal/PrimitiveScanner.next)


}