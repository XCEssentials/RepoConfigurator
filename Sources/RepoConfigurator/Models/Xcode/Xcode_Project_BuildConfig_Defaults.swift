extension Xcode.Project.BuildConfiguration
{
    enum Defaults
    {
        static
        func debug(
            _ profiles: [String] = []
            ) -> Xcode.Project.BuildConfiguration
        {
            return Xcode
                .Project
                .BuildConfiguration(
                    "Debug",
                    .debug,
                    profiles
                )
        }
        
        static
        func release(
            _ profiles: [String] = []
            ) -> Xcode.Project.BuildConfiguration
        {
            return Xcode
                .Project
                .BuildConfiguration(
                    "Release",
                    .release,
                    profiles
                )
        }
    }
}
