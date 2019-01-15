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
extension Spec
{
    struct Company
    {
        public
        let prefix: String // product/project/module name prefix
        
        public
        let name: String
        
        public
        let identifier: String
        
        public
        let developmentTeamId: String
        
        public
        enum InitializationError: Error
        {
            case companyNameAutoDetectionFailed
        }
        
        public
        init(
            prefix: String? = nil,
            name: String? = nil,
            identifier: String = "",
            developmentTeamId: String = "",
            shouldReport: Bool = false
            ) throws
        {
            let prefix = prefix
                ?? "" // totally fine to be empty
            
            let name = try name
                ?? LocalRepo.current().context
                ?! InitializationError.companyNameAutoDetectionFailed
            
            //---
            
            self.prefix = prefix
            self.name = name
            self.identifier = identifier
            self.developmentTeamId = developmentTeamId
            
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
extension Spec.Company
{
    func report()
    {
        print("✅ Company name: \(name)")
    }
}
