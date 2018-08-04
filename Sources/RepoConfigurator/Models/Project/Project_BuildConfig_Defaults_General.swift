extension Project.BuildConfiguration.Defaults
{
    enum General
    {
        static
        func debug(
            _ profiles: [String] = []
            ) -> Project.BuildConfiguration
        {
            return Project
                .BuildConfiguration
                .Defaults
                .debug(["general:debug"] + profiles)
        }
        
        static
        func release(
            _ profiles: [String] = []
            ) -> Project.BuildConfiguration
        {
            return Project
                .BuildConfiguration
                .Defaults
                .release(["general:release"] + profiles)
        }
    }
}
