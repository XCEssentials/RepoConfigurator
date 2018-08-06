extension Xcode.Project.BuildConfiguration.Defaults
{
    enum iOS
    {
        static
        func base(
            _ profiles: [String] = []
            ) -> Xcode.Project.BuildConfiguration.Base
        {
            return Xcode
                .Project
                .BuildConfiguration
                .Base(["platform:ios"] + profiles)
        }
        
        static
        func debug(
            _ profiles: [String] = []
            ) -> Xcode.Project.BuildConfiguration
        {
            return Xcode
                .Project
                .BuildConfiguration
                .Defaults
                .debug(["ios:debug"] + profiles)
        }
        
        static
        func release(
            _ profiles: [String] = []
            ) -> Xcode.Project.BuildConfiguration
        {
            return Xcode
                .Project
                .BuildConfiguration
                .Defaults
                .release(["ios:release"] + profiles)
        }
    }
}
