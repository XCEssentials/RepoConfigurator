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
protocol Gem
{
    static
    var gemName: String { get } // for Gemfile, require, etc.
    
    static
    var gemCallName: String { get } // how to call in command line, script, etc.
}

public
extension Gem
{
    static
    var gemName: String
    {
        return String(describing: self).lowercased()
    }
    
    static
    var gemCallName: String
    {
        return gemName
    }
}

public
extension Gem
{
    static
    func call(
        _ method: GemCallMethod
        ) -> String
    {
        switch method
        {
        case .directly:
            return gemCallName
            
        case .viaBundler:
            return Bundler.execPrefix + gemCallName
        }
    }
}

//---

public
enum GemCallMethod
{
    case directly
    case viaBundler
}
