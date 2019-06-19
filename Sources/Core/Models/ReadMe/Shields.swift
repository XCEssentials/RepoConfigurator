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

import PathKit

//---

/**
 https://shields.io/
 */
public
enum Shields {}

// MARK: - Badge

public
extension Shields
{
    struct Badge
    {
        // MARK: Type level members

        public
        enum Errors: Error
        {
            case invalidParamters(message: String)
            case failedToGenerateOutputURL
        }

        public
        static
        let baseURL = "https://img.shields.io"

        // MARK: Instance level members

        public
        let output: URL

        // MARK: Initializers

        //internal
        init(
            _ linkPath: Path,
            _ parameters: [(key: String, value: Any)]?
            ) throws
        {
            guard
                var result = URL
                    .init(string: type(of: self).baseURL)?
                    .appendingPathComponent(linkPath.string)
            else
            {
                throw Errors.failedToGenerateOutputURL
            }

            //---

            if
                let parameters = parameters,
                var urlComponents = URLComponents
                    .init(
                        url: result,
                        resolvingAgainstBaseURL: false
                    )
            {
                urlComponents.queryItems = parameters.map{

                    return .init(name: $0.key, value: "\($0.value)")
                }

                result = urlComponents.url ?? result
            }

            //---

            self.output = result
        }

        /**
         Compose custom static badge.
         */
        public
        static
        func `static`(
            _ subject: String,
            status: String,
            color: String,
            _ parameters: Parameters? = nil
            ) throws -> Badge
        {
            guard
                !subject.isEmpty
            else
            {
                throw Errors.invalidParamters(
                    message: "Subject can NOT be blank!"
                )
            }

            guard
                !status.isEmpty
            else
            {
                throw Errors.invalidParamters(
                    message: "Status can NOT be blank!"
                )
            }

            guard
                !color.isEmpty
            else
            {
                throw Errors.invalidParamters(
                    message: "Color can NOT be blank!"
                )
            }

            //---

            return try .init(
                .init("badge/\(subject)-\(status)-\(color).svg"),
                parameters?.output
            )
        }

        /**
         Compose one of the built-in badges supported by Shields.io.
         */
        public
        static
        func special(
            _ linkPath: Path,
            _ parameters: Parameters? = nil
            ) throws -> Badge
        {
            guard
                !linkPath.components.isEmpty
            else
            {
                print(linkPath)
                
                throw Errors.invalidParamters(
                    message: "Link path can NOT be blank!"
                )
            }

            //---

            return try .init(
                linkPath,
                parameters?.output
            )
        }

        // Implement 'dynamic' too???
    }
}

// MARK: - Badge Style

public
extension Shields
{
    enum Style: String
    {
        case plastic = "plastic"
        case flat = "flat"
        case flatSquare = "flat-square"
        case forTheBadge = "for-the-badge"
        case popout = "popout"
        case popoutSquare = "popout-square"
        case social = "social"
    }
}

// MARK: - Badge Parameters

public
extension Shields
{
    struct Parameters
    {
        // MARK: Instance level members

        public
        let output: [(key: String, value: Any)]

        // MARK: Initializers

        public
        static
        func parameters(
            longCache: Bool? = true,
            style: Style? = nil,
            label: String? = nil,
            logo: String? = nil,
            logoColor: String? = nil,
            logoWidth: UInt? = nil,
            links: (left: String, right: String)? = nil,
            colorA: String? = nil,
            colorB: String? = nil,
            maxAge: UInt? = nil
            ) -> Parameters
        {
            var result: [(String, Any)] = []

            //---

            longCache.map{

                result += [("longCache", $0)]
            }

            style.map{

                result += [("style", $0)]
            }

            label.map{

                result += [("label", $0)]
            }

            logo.map{

                result += [("logo", $0)]
            }

            logoColor.map{

                result += [("logoColor", $0)]
            }

            logoWidth.map{

                result += [("logoWidth", $0)]
            }

            links.map{

                result += [("link", $0.left), ("link", $0.right)]
            }

            colorA.map{

                result += [("colorA", $0)]
            }

            colorB.map{

                result += [("colorB", $0)]
            }

            maxAge.map{

                result += [("maxAge", $0)]
            }

            //---

            return .init(output: result)
        }
    }
}
