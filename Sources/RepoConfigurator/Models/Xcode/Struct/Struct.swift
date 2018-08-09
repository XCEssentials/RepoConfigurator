/**
 Generate Xcode project using Struct CLI tool.
 https://github.com/lyptt/struct
 */
public
enum Struct {}

//---

// internal
extension Struct
{
    static
    func generateSpec(
        _ format: Spec,
        for project: Xcode.Project
        ) -> IndentedText
    {
        switch format
        {
        case .v1_2_1:
            return Spec_1_2_1.generate(for: project)
        
        case .v1_3_0:
            return Spec_1_3_0.generate(for: project)
        
        case .v2_0_0:
            return Spec_2_0_0.generate(for: project)
        
        case .v2_1_0:
            return Spec_2_1_0.generate(for: project)
        }
    }
}
