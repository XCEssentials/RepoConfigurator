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
extension CocoaPods.Podfile
{
    struct ConcreteTargetContext
    {
        private
        let buffer: IndentedTextBuffer
        
        //internal
        init(
            with buffer: IndentedTextBuffer
            )
        {
            self.buffer = buffer
        }
    }
}

// MARK: - Content rendering

public
extension CocoaPods.Podfile.ConcreteTargetContext
{
    enum InheritanceMode: String
    {
        case nothing = "none"
        case searchPaths = "search_paths"
        case complete = "complete"
    }
    
    func unitTestTarget(
        _ name: String,
        inherit inheritanceMode: InheritanceMode? = .searchPaths,
        pods: [String],
        otherEntries: [String] = []
        )
    {
        buffer <<< """

            target '\(name)' do

            """

        buffer.indentation.nest{

            buffer <<< inheritanceMode.map{ """
                inherit! :\($0.rawValue)

                """
            }

            buffer <<< pods.map{ """
                \($0)
                """
            }
            
            otherEntries.isEmpty ? () : buffer.appendNewLine()
            
            buffer <<< otherEntries
        }

        buffer <<< """

            end
            """
    }
}
