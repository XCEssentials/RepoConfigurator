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
    final
    class Project: FixedNameTextFile
    {
        // MARK: - Type level members

        public
        static
        let fileName: String = "project.yml" // Struct SPEC!

        // MARK: - Instance level members

        public
        let specFormat: Struct.Spec

        public
        var fileContent: [IndentedTextGetter]
        {
            return [Struct.generateSpec(specFormat, for: self)]
        }

        public
        let name: String

        public
        let buildSettings = Xcode.Project.BuildSettings()

        public private(set)
        var targets: [String: Target] = [:]

        public
        func target(
            _ name: String,
            _ platform: OSIdentifier,
            _ type: Target.InternalType,
            _ configureTarget: (Target) -> Void
            )
        {
            targets[name] = .init(name, platform, type, configureTarget)
        }

        public
        var variants: [Xcode.Project.Variant] = []

        // MARK: - Initializers

        public
        init(
            _ name: String,
            specFormat: Struct.Spec,
            configureProject: (Xcode.Project) -> Void
            )
        {
            self.name = name
            self.specFormat = specFormat

            //---

            configureProject(self)
        }
    }
}
