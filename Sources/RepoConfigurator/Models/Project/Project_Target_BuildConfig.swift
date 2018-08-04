public
extension Project.Target
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
