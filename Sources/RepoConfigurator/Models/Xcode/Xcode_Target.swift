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
extension Xcode
{
    public
    class Target
    {
        // MARK: - Instance level members

        public
        let name: String

        public private(set)
        var includes: [String] = []

        public
        func include(
            _ paths: String...
            )
        {
            includes.append(contentsOf: paths)
        }

        public private(set)
        var excludes: [String] = []

        public
        func exclude(
            _ patterns: String...
            )
        {
            excludes.append(contentsOf: patterns)
        }

        public
        var sourceFilesOptions: [String: String] = [:]

        public private(set)
        var i18nResources: [String] = []

        public
        func i18nResource(
            _ paths: String...
            )
        {
            i18nResources.append(contentsOf: paths)
        }

        public
        let buildSettings = Xcode.BuildSettings()

        public
        let dependencies = Xcode.Dependencies()

        public
        var scripts = Xcode.Scripts()

        public
        var includeCocoapods = false

        // MARK: - Initializers

        //internal
        init(
            _ name: String
            )
        {
            self.name = name
        }
    }
}
