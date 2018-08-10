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
extension Xcode.Project.Target
{
    public
    struct BuildConfiguration
    {
        public
        struct Base
        {
            // internal
            init(
                _ overrides: [KeyValuePair] = []
                )
            {
                self.overrides = overrides
            }
            
            //---
            
            public private(set)
            var overrides: [KeyValuePair] = []
            
            public
            mutating
            func override(
                _ pairs: KeyValuePair...
                )
            {
                overrides.append(contentsOf: pairs)
            }
        }
        
        //---
        
        public
        let name: String
        
        //---
        
        public private(set)
        var overrides: [KeyValuePair] = []
        
        public
        mutating
        func override(
            _ pairs: KeyValuePair...
            )
        {
            overrides.append(contentsOf: pairs)
        }
        
        //---
        
        // internal
        init(
            _ name: String
            )
        {
            self.name = name
        }
    }
}
