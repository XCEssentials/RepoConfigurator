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

import Foundation

//---

public
class ExternalFile
{
    // MARK: Type level members

    public
    enum Errors: Error
    {
        case resourceNotFound
    }

    private
    static
    var currentBundle: Bundle
    {
        return .init(for: self)
    }

    // MARK: Initializers

    private
    init() {}
}

//---

public
extension ExternalFile
{
    static
    func load(
        from source: URL
        ) throws -> String
    {
        return try String(contentsOf: source)
    }

    static
    func loadFromResource(
        named resourceName: String,
        withExtension resourceExtension: String,
        encoding: String.Encoding = .utf8
        ) throws -> String
    {
        guard
            let source = currentBundle.url(
                forResource: resourceName,
                withExtension: resourceExtension
            )
        else
        {
            throw Errors.resourceNotFound
        }

        //---

        return try String(
            contentsOf: source,
            encoding: encoding
        )
    }
}
