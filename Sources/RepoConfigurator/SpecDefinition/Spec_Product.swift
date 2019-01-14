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
extension Spec
{
    struct Product
    {
        public
        let name: String
        
        public
        let summary: String
        
        public
        let copyrightYear: UInt
        
        public
        let deploymentTargets: [OSIdentifier: VersionString]
        
        public
        enum InitializationError: Error
        {
            case nameAutoDetectionFailed
        }
        
        public
        init(
            name: String? = nil,
            summary: String,
            copyrightYear: UInt? = nil,
            deploymentTargets: [OSIdentifier: VersionString],
            shouldReport: Bool = false
            ) throws
        {
            self.name = try name
                ?? LocalRepo.current().name
                ?! InitializationError.nameAutoDetectionFailed // non-nil, but zero-length
            
            self.summary = summary
            
            self.copyrightYear = copyrightYear
                ?? UInt(
                    Calendar
                        .current
                        .component(.year, from: Date())
                )
            
            self.deploymentTargets = deploymentTargets
            
            //---
            
            if
                shouldReport
            {
                report()
            }
        }
    }
}

// MARK: - Helpers

public
extension Spec.Product
{
    func report()
    {
        print("✅ Product name (without company prefix): \(name)")
    }
}
