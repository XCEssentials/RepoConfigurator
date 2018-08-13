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
    struct Project: FixedNameTextFile
    {
        public
        static
        let fileName: String = "project.yml" // Struct SPEC!

        public
        let specFormat: Struct.Spec

        //---

        public
        var fileContent: [IndentedTextGetter]
        {
            return [Struct.generateSpec(specFormat, for: self)]
        }

        //---

        public
        final
        class BuildConfigurations
        {
            public
            var all = BuildConfiguration.Base()

            public
            var debug = BuildConfiguration.Defaults.General.debug()

            public
            var release = BuildConfiguration.Defaults.General.release()
        }

        //---

        public
        let name: String

        //---

        public
        let configurations = BuildConfigurations()

        public private(set)
        var targets: [Target] = []

        //---

        public
        init(
            _ name: String,
            specFormat: Struct.Spec,
            configureProject: (inout Xcode.Project) -> Void
            )
        {
            self.name = name
            self.specFormat = specFormat

            //---

            configureProject(&self)
        }

        //---

        public
        mutating
        func target(
            _ name: String,
            _ platform: OSIdentifier,
            _ type: Target.InternalType,
            _ configureTarget: (inout Target) -> Void
            )
        {
            targets
                .append(Target(platform, name, type, configureTarget))
        }

        //---

        public
        var variants: [Xcode.Project.Variant] = []
    }
}
