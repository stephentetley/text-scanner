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



namespace TextScanner/Internal/Utils {

    pub def timeOperationNanos(thunk: Unit -> a & e): (Int64, a) & Impure = 
        import java.lang.System:nanoTime();
        let t0 = nanoTime();
        let a = thunk() as & Impure;
        let t1 = nanoTime();
        (t1 - t0, a)

    pub def timeOperationMillis(thunk: Unit -> a & e): (Int64, a) & Impure = 
        import java.lang.System:currentTimeMillis();
        let t0 = currentTimeMillis();
        let a = thunk() as & Impure;
        let t1 = currentTimeMillis();
        (t1 - t0, a)

}
