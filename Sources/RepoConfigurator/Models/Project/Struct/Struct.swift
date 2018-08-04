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
    func prepareSpec(
        _ format: Spec,
        for project: Project
        ) -> String
    {
        let rawSpec: RawSpec
        
        //---
        
        switch format
        {
            case .v1_2_1:
                rawSpec = Spec_1_2_1.generate(for: project)
            
            case .v1_3_0:
                rawSpec = Spec_1_3_0.generate(for: project)
            
            case .v2_0_0:
                rawSpec = Spec_2_0_0.generate(for: project)
            
            case .v2_1_0:
                rawSpec = Spec_2_1_0.generate(for: project)
        }
        
        //---
        
        return rawSpec
            .map { "\(Spec.ident($0))\($1)" }
            .joined(separator: "\n")
    }
}
