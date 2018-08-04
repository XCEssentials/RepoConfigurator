public
struct Project: FixedNameFile
{
    public
    static
    let fileName: String = "project.yml" // Struct SPEC!

    public
    let specFormat: Struct.Spec

    //---

    public
    var fileContent: String
    {
        return Struct
            .prepareSpec(specFormat, for: self)
    }

    //---

    public
    final
    class BuildConfigurations
    {
        public
        var all = BuildConfiguration.Base()
        
        public
        var debug = BuildConfiguration.Defaults.General.debug()
        
        public
        var release = BuildConfiguration.Defaults.General.release()
    }
    
    //---
    
    public
    let name: String
    
    //---
    
    public
    let configurations = BuildConfigurations()
    
    public private(set)
    var targets: [Target] = []
    
    //---
    
    public
    init(
        _ name: String,
        specFormat: Struct.Spec,
        configureProject: (inout Project) -> Void
        )
    {
        self.name = name
        self.specFormat = specFormat
        
        //---
        
        configureProject(&self)
    }
    
    //---
    
    public
    mutating
    func target(
        _ name: String,
        _ platform: OSIdentifier,
        _ type: Target.InternalType,
        _ configureTarget: (inout Target) -> Void
        )
    {
        targets
            .append(Target(platform, name, type, configureTarget))
    }
    
    //---
    
    public
    var variants: [Project.Variant] = []
}
