extension Project.BuildConfiguration.Defaults
{
    enum iOS
    {
        static
        func base(
            _ profiles: [String] = []
            ) -> Project.BuildConfiguration.Base
        {
            return Project
                .BuildConfiguration
                .Base(["platform:ios"] + profiles)
        }
        
        static
        func debug(
            _ profiles: [String] = []
            ) -> Project.BuildConfiguration
        {
            return Project
                .BuildConfiguration
                .Defaults
                .debug(["ios:debug"] + profiles)
        }
        
        static
        func release(
            _ profiles: [String] = []
            ) -> Project.BuildConfiguration
        {
            return Project
                .BuildConfiguration
                .Defaults
                .release(["ios:release"] + profiles)
        }
    }
}
