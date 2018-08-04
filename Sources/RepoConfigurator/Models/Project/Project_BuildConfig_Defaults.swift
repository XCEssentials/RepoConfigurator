extension Project.BuildConfiguration
{
    enum Defaults
    {
        static
        func debug(
            _ profiles: [String] = []
            ) -> Project.BuildConfiguration
        {
            return Project
                .BuildConfiguration(
                    "Debug",
                    .debug,
                    profiles
                )
        }
        
        static
        func release(
            _ profiles: [String] = []
            ) -> Project.BuildConfiguration
        {
            return Project
                .BuildConfiguration(
                    "Release",
                    .release,
                    profiles
                )
        }
    }
}
