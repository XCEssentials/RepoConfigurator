public
extension Xcode.Project
{
    public
    struct BuildConfiguration
    {
        public
        struct Base
        {
            public
            let profiles: [String]
            
            //---
            
            // internal
            init(
                _ profiles: [String] = []
                )
            {
                self.profiles = profiles
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
        enum InternalType: String
        {
            case
                debug,
                release
        }
        
        //---
        
        public
        let name: String
        
        public
        let type: InternalType
        
        public
        let profiles: [String]
        
        //---
        
        public
        var externalConfig: String? // *.xcconfig file
        
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
            _ name: String,
            _ type: InternalType,
            _ profiles: [String] = []
            )
        {
            self.name = name
            self.type = type
            self.profiles = profiles
        }
    }
}
