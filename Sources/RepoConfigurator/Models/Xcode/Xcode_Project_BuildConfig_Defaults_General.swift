extension Xcode.Project.BuildConfiguration.Defaults
{
    enum General
    {
        static
        func debug(
            _ profiles: [String] = []
            ) -> Xcode.Project.BuildConfiguration
        {
            return Xcode
                .Project
                .BuildConfiguration
                .Defaults
                .debug(["general:debug"] + profiles)
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
                .release(["general:release"] + profiles)
        }
    }
}
