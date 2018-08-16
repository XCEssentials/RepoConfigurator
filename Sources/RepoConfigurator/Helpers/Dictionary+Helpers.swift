/*

 MIT License

 Copyright (c) 2018 Maxim Khatskevich

 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:

 The above copyright notice and this permission notice shall be included in all
 copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 SOFTWARE.

 */

public
extension Dictionary
{
    mutating
    func override(
        with overrides: [Key: Value]
        )
    {
        self.merge(overrides, uniquingKeysWith: { _, new in new })
    }

    mutating
    func override<S>(
        with overrides: S
        )
        where
        S: Sequence,
        S.Element == (Key, Value)
    {
        self.merge(overrides, uniquingKeysWith: { _, new in new })
    }

    mutating
    func override(
        _ overrides: (Key, Value)...
        )
    {
        self.merge(overrides, uniquingKeysWith: { _, new in new })
    }

    func overriding(
        with overrides: [Key: Value]
        ) -> [Key: Value]
    {
        return self.merging(overrides, uniquingKeysWith: { _, new in new })
    }

    func overriding<S>(
        with overrides: S
        ) -> [Key: Value]
        where
        S: Sequence,
        S.Element == (Key, Value)
    {
        return self.merging(overrides, uniquingKeysWith: { _, new in new })
    }
}
