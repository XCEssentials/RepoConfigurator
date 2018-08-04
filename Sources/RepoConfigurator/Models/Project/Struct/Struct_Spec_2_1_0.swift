// internal
extension Struct
{
    enum Spec_2_1_0 {}
}

//---

// internal
extension Struct.Spec_2_1_0
{
    static
    func generate(for p: Project) -> Struct.RawSpec
    {
        var result: Struct.RawSpec = []
        var idention: Int = 0
        
        //---
        
        result <<< (idention, "# generated with XCEProjectGenerator")
        result <<< (idention, "# https://github.com/XCEssentials/ProjectGenerator")
        result <<< (idention, "# https://github.com/workshop/struct/wiki/Spec-format:-v2.0")
        
        //---
        
        // https://github.com/workshop/struct/wiki/Spec-format:-v2.0#version-number
        
        result <<< (idention, Struct.Spec.key("version") + " \(Struct.Spec.v2_1_0.rawValue)")
        
        //---
        
        result <<< process(&idention, p.configurations)
        
        //---
        
        result <<< process(&idention, p.targets)
        
        //---
        
        result <<< process(&idention, variants: p.variants, of: p)
        
        //---
        
        result <<< (0, "") // empty line in the EOF
        
        //---
        
        return result
    }
    
    //---
    
    static
    func process(
        _ idention: inout Int,
        variants: [Project.Variant],
        of baseProject: Project
        ) -> Struct.RawSpec
    {
        var result: Struct.RawSpec = []
        
        //---
        
        result <<< (idention, Struct.Spec.key("variants"))
        
        idention += 1
        
        result <<< (idention, Struct.Spec.key("$base"))
        
        idention += 1
        
        result <<< (idention, Struct.Spec.key("abstract") + " true")
        
        idention -= 1
        
        if
            variants.isEmpty
        {
            result <<< (idention, Struct.Spec.key(baseProject.name))
        }
        else
        {
            result <<< process(&idention, variants: variants)
        }
        
        idention -= 1
        
        //---
        
        return result
    }
    
    //---
    
    static
    func process(
        _ idention: inout Int,
        variants: [Project.Variant]
        ) -> Struct.RawSpec
    {
        // https://github.com/workshop/struct/wiki/Spec-format:-v2.0#variants
        
        //---
        
        var result: Struct.RawSpec = []
        
        //---
        
        for v in variants
        {
            result <<< (idention, Struct.Spec.key(v.name))
            
            idention += 1
            
            for t in v.targets
            {
                result <<< process(&idention, t)
                
                //---
                
                for tst in t.tests
                {
                    result <<< process(&idention, tst)
                }
            }
            
            idention -= 1
        }
        
        //---
        
        return result
    }
    
    //---
    
    static
    func process(
        _ idention: inout Int,
        _ t: Project.Variant.Target
        ) -> Struct.RawSpec
    {
        var result: Struct.RawSpec = []
        
        //---
        
        result <<< (idention, Struct.Spec.key(t.name))
        
        //---
        
        idention += 1
        
        //---
        
        result <<< process(&idention, t.dependencies)
        
        //---
        
        // https://github.com/lyptt/struct/wiki/Spec-format:-v2.0#sources
        
        if
            !t.includes.isEmpty
        {
            result <<< (idention, "sources:")
            
            for path in t.includes
            {
                result <<< (idention, "-" + Struct.Spec.value(path))
            }
        }
        
        //---
        
        // https://github.com/lyptt/struct/wiki/Spec-format:-v2.0#excludes
        
        if
            !t.excludes.isEmpty
        {
            result <<< (idention, Struct.Spec.key("excludes"))
            idention += 1
            result <<< (idention, Struct.Spec.key("files"))
            
            for path in t.excludes
            {
                result <<< (idention, "-" + Struct.Spec.value(path))
            }
            
            idention -= 1
        }
        
        //---
        
        // https://github.com/workshop/struct/wiki/Spec-format:-v2.0#options
        
        if
            !t.sourceOptions.isEmpty
        {
            result <<< (idention, "source_options:")
            idention += 1
            
            for (path, opt) in t.sourceOptions
            {
                result <<< (idention, Struct.Spec.key(path) + Struct.Spec.value(opt))
            }
            
            idention -= 1
        }
        
        //---
        
        // https://github.com/lyptt/struct/wiki/Spec-format:-v2.0#i18n-resources
        
        if
            !t.i18nResources.isEmpty
        {
            result <<< (idention, Struct.Spec.key("i18n-resources"))
            
            for path in t.i18nResources
            {
                result <<< (idention, "-" + Struct.Spec.value(path))
            }
        }
        
        //---
        
        result <<< process(&idention, t.configurations)
        
        //---
        
        result <<< process(&idention, scripts: t.scripts)
        
        //---
        
        // https://github.com/lyptt/struct/wiki/Spec-format:-v2.0#cocoapods
        
        if
            t.includeCocoapods
        {
            result <<<
                (idention,
                 Struct.Spec.key("includes_cocoapods") + Struct.Spec.value(t.includeCocoapods))
        }
        
        //---
        
        idention -= 1
        
        //---
        
        return result
    }
    
    //---
    
    static
    func process(
        _ idention: inout Int,
        _ set: Project.Variant.Target.BuildConfigurations
        ) -> Struct.RawSpec
    {
        // https://github.com/lyptt/struct/issues/77#issuecomment-287573381
        
        //---
        
        var result: Struct.RawSpec = []
        
        //---
        
        if
            !set.all.overrides.isEmpty ||
            !set.debug.overrides.isEmpty ||
            !set.release.overrides.isEmpty
        {
            result <<< (idention, Struct.Spec.key("configurations"))
            
            //---
            
            idention += 1
            
            //---
            
            if
                !set.all.overrides.isEmpty ||
                !set.debug.overrides.isEmpty
            {
                result <<< process(&idention, set.all, set.debug)
            }
            
            if
                !set.all.overrides.isEmpty ||
                !set.release.overrides.isEmpty
            {
                result <<< process(&idention, set.all, set.release)
            }
            
            //---
            
            idention -= 1
        }
        
        //---
        
        return result
    }
    
    //---
    
    static
    func process(
        _ idention: inout Int,
        _ set: Project.BuildConfigurations
        ) -> Struct.RawSpec
    {
        // https://github.com/lyptt/struct/wiki/Spec-format:-v1.2#configurations
        
        //---
        
        var result: Struct.RawSpec = []
        
        //---
        
        result <<< (idention, Struct.Spec.key("configurations"))
        
        //---
        
        idention += 1
        
        //---
        
        result <<< process(&idention, set.all, set.debug)
        result <<< process(&idention, set.all, set.release)
        
        //---
        
        idention -= 1
        
        //---
        
        return result
    }
    
    //---
    
    static
    func process(
        _ idention: inout Int,
        _ b: Project.BuildConfiguration.Base,
        _ c: Project.BuildConfiguration
        ) -> Struct.RawSpec
    {
        // https://github.com/lyptt/struct/wiki/Spec-format:-v2.0#configurations
        
        //---
        
        var result: Struct.RawSpec = []
        
        //---
        
        result <<< (idention, Struct.Spec.key(c.name))
        
        //---
        
        idention += 1
        
        //---
        
        result <<< (idention, Struct.Spec.key("type") + Struct.Spec.value(c.type))
        
        //---
        
        if
            let externalConfig = c.externalConfig
        {
            // https://github.com/lyptt/struct/wiki/Spec-format:-v2.0#xcconfig-references
            
            // NOTE: when using xcconfig files,
            // any overrides or profiles will be ignored.
            
            result <<< (idention, Struct.Spec.key("source") + Struct.Spec.value(externalConfig) )
        }
        else
        {
            // NO source/xcconfig provided
            
            //---
            
            // NO profiles anymore
            // https://github.com/workshop/struct/wiki/Migrating-from-Spec-1.3.1-to-Spec-2.0.0
            
            //---
            
            // https://github.com/lyptt/struct/wiki/Spec-format:-v2.0#overrides
            
            result <<< (idention, Struct.Spec.key("overrides"))
            idention += 1
            
            for o in b.overrides + c.overrides
            {
                result <<< (idention, Struct.Spec.key(o.key) + Struct.Spec.value(o.value))
            }
            
            idention -= 1
        }
        
        //---
        
        idention -= 1
        
        //---
        
        return result
    }
    
    //---
    
    static
    func process(
        _ idention: inout Int,
        _ targets: [Project.Target]
        ) -> Struct.RawSpec
    {
        // https://github.com/lyptt/struct/wiki/Spec-format:-v2.0#targets
        
        //---
        
        var result: Struct.RawSpec = []
        
        //---
        
        result <<< (idention, Struct.Spec.key("targets"))
        
        //---
        
        idention += 1
        
        //---
        
        for t in targets
        {
            result <<< process(&idention, t)
            
            //---
            
            for tst in t.tests
            {
                result <<< process(&idention, tst)
            }
        }
        
        //---
        
        idention -= 1
        
        //---
        
        return result
    }
    
    //---
    
    static
    func process(
        _ idention: inout Int,
        _ t: Project.Target
        ) -> Struct.RawSpec
    {
        // https://github.com/lyptt/struct/wiki/Spec-format:-v2.0#targets
        
        //---
        
        var result: Struct.RawSpec = []
        
        //---
        
        result <<< (idention, Struct.Spec.key(t.name))
        
        //---
        
        idention += 1
        
        //---
        
        // https://github.com/lyptt/struct/wiki/Spec-format:-v2.0#platform
        
        result <<< (idention, Struct.Spec.key("platform") + Struct.Spec.value(t.platform.rawValue))
        
        //---
        
        // https://github.com/lyptt/struct/wiki/Spec-format:-v2.0#type
        
        result <<< (idention, Struct.Spec.key("type") + Struct.Spec.value(t.type.rawValue))
        
        //---
        
        result <<< process(&idention, t.dependencies)
        
        //---
        
        // https://github.com/lyptt/struct/wiki/Spec-format:-v2.0#sources
        
        if
            !t.includes.isEmpty
        {
            result <<< (idention, "sources:")
            
            for path in t.includes
            {
                result <<< (idention, "-" + Struct.Spec.value(path))
            }
        }
        
        //---
        
        // https://github.com/lyptt/struct/wiki/Spec-format:-v2.0#excludes
        
        if
            !t.excludes.isEmpty
        {
            result <<< (idention, Struct.Spec.key("excludes"))
            idention += 1
            result <<< (idention, Struct.Spec.key("files"))
            
            for path in t.excludes
            {
                result <<< (idention, "-" + Struct.Spec.value(path))
            }
            
            idention -= 1
        }
        
        //---
        
        // https://github.com/workshop/struct/wiki/Spec-format:-v2.0#options
        
        if
            !t.sourceOptions.isEmpty
        {
            result <<< (idention, "source_options:")
            idention += 1
            
            for (path, opt) in t.sourceOptions
            {
                result <<< (idention, Struct.Spec.key(path) + Struct.Spec.value(opt))
            }
            
            idention -= 1
        }
        
        //---
        
        // https://github.com/lyptt/struct/wiki/Spec-format:-v2.0#i18n-resources
        
        if
            !t.i18nResources.isEmpty
        {
            result <<< (idention, Struct.Spec.key("i18n-resources"))
            
            for path in t.i18nResources
            {
                result <<< (idention, "-" + Struct.Spec.value(path))
            }
        }
        
        //---
        
        result <<< process(&idention, t.configurations)
        
        //---
        
        result <<< process(&idention, scripts: t.scripts)
        
        //---
        
        // https://github.com/lyptt/struct/wiki/Spec-format:-v2.0#cocoapods
        
        if
            t.includeCocoapods
        {
            result <<<
                (idention,
                 Struct.Spec.key("includes_cocoapods") + Struct.Spec.value(t.includeCocoapods))
        }
        
        //---
        
        idention -= 1
        
        //---
        
        return result
    }
    
    //---
    
    static
    func process(
        _ idention: inout Int,
        _ deps: Project.Target.Dependencies
        ) -> Struct.RawSpec
    {
        // https://github.com/lyptt/struct/wiki/Spec-format:-v2.0#references
        
        //---
        
        var result: Struct.RawSpec = []
        
        //---
        
        if
            !deps.fromSDKs.isEmpty ||
            !deps.otherTargets.isEmpty ||
            !deps.binaries.isEmpty ||
            !deps.projects.isEmpty
        {
            result <<< (idention, Struct.Spec.key("references"))
            
            //---
            
            result <<< processDependencies(&idention, fromSDK: deps.fromSDKs)
            result <<< processDependencies(&idention, targets: deps.otherTargets)
            result <<< processDependencies(&idention, binaries: deps.binaries)
            result <<< processDependencies(&idention, projects: deps.projects)
        }
        
        //---
        
        return result
    }
    
    //---
    
    static
    func processDependencies(
        _ idention: inout Int,
        fromSDK: [String]
        ) -> Struct.RawSpec
    {
        // https://github.com/lyptt/struct/wiki/Spec-format:-v2.0#references
        
        //---
        
        var result: Struct.RawSpec = []
        
        //---
        
        for dep in fromSDK
        {
            result <<< (idention, "-" + Struct.Spec.value("sdkroot:\(dep)"))
        }
        
        //---
        
        return result
    }
    
    //---
    
    static
    func processDependencies(
        _ idention: inout Int,
        targets: [String]
        ) -> Struct.RawSpec
    {
        // https://github.com/lyptt/struct/wiki/Spec-format:-v2.0#references
        
        //---
        
        var result: Struct.RawSpec = []
        
        //---
        
        for t in targets
        {
            result <<< (idention, "-" + Struct.Spec.value(t))
        }
        
        //---
        
        return result
    }
    
    //---
    
    static
    func processDependencies(
        _ idention: inout Int,
        binaries: [Project.Target.BinaryDependency]
        ) -> Struct.RawSpec
    {
        // https://github.com/lyptt/struct/wiki/Spec-format:-v2.0#references
        
        //---
        
        var result: Struct.RawSpec = []
        
        //---
        
        for b in binaries
        {
            result <<< (idention, Struct.Spec.key("- location") + Struct.Spec.value(b.location))
            result <<< (idention, Struct.Spec.key("  codeSignOnCopy") + Struct.Spec.value(b.codeSignOnCopy))
        }
        
        //---
        
        return result
    }
    
    //---
    
    static
    func processDependencies(
        _ idention: inout Int,
        projects: [Project.Target.ProjectDependencies]
        ) -> Struct.RawSpec
    {
        // https://github.com/lyptt/struct/wiki/Spec-format:-v2.0#references
        
        //---
        
        var result: Struct.RawSpec = []
        
        //---
        
        for p in projects
        {
            result <<< (idention, Struct.Spec.key("- location") + Struct.Spec.value(p.location))
            result <<< (idention, Struct.Spec.key("  frameworks"))
            
            for f in p.frameworks
            {
                result <<< (idention, Struct.Spec.key("  - name") + Struct.Spec.value(f.name))
                result <<< (idention, Struct.Spec.key("    copy") + Struct.Spec.value(f.copy))
                result <<< (idention, Struct.Spec.key("    codeSignOnCopy") + Struct.Spec.value(f.codeSignOnCopy))
            }
        }
        
        //---
        
        return result
    }
    
    //---
    
    static
    func process(
        _ idention: inout Int,
        _ set: Project.Target.BuildConfigurations
        ) -> Struct.RawSpec
    {
        // https://github.com/lyptt/struct/issues/77#issuecomment-287573381
        
        //---
        
        var result: Struct.RawSpec = []
        
        //---
        
        result <<< (idention, Struct.Spec.key("configurations"))
        
        //---
        
        idention += 1
        
        //---
        
        result <<< process(&idention, set.all, set.debug)
        result <<< process(&idention, set.all, set.release)
        
        //---
        
        idention -= 1
        
        //---
        
        return result
    }
    
    //---
    
    static
    func process(
        _ idention: inout Int,
        _ b: Project.Target.BuildConfiguration.Base,
        _ c: Project.Target.BuildConfiguration
        ) -> Struct.RawSpec
    {
        // https://github.com/lyptt/struct/issues/77#issuecomment-287573381
        
        //---
        
        var result: Struct.RawSpec = []
        
        //---
        
        result <<< (idention, Struct.Spec.key(c.name))
        
        //---
        
        idention += 1
        
        //---
        
        // https://github.com/lyptt/struct/wiki/Spec-format:-v1.2#overrides
        
        for o in b.overrides + c.overrides
        {
            result <<< (idention, Struct.Spec.key(o.key) + Struct.Spec.value(o.value))
        }
        
        //---
        
        idention -= 1
        
        //---
        
        return result
    }
    
    //---
    
    static
    func process(
        _ idention: inout Int,
        scripts: Project.Target.Scripts
        ) -> Struct.RawSpec
    {
        // https://github.com/lyptt/struct/wiki/Spec-format:-v2.0#scripts
        
        //---
        
        var result: Struct.RawSpec = []
        
        //---
        
        if
            !scripts.regulars.isEmpty ||
            !scripts.beforeBuilds.isEmpty ||
            !scripts.afterBuilds.isEmpty
        {
            result <<< (idention, Struct.Spec.key("scripts"))
            
            //---
            
            idention += 1
            
            //---
            
            if
                !scripts.regulars.isEmpty
            {
                result <<< processScripts(&idention, regulars: scripts.regulars)
            }
            
            if
                !scripts.beforeBuilds.isEmpty
            {
                result <<< processScripts(&idention, beforeBuild: scripts.beforeBuilds)
            }
            
            if
                !scripts.afterBuilds.isEmpty
            {
                result <<< processScripts(&idention, afterBuild: scripts.afterBuilds)
            }
            
            //---
            
            idention -= 1
        }
        
        //---
        
        return result
    }
    
    //---
    
    static
    func processScripts(
        _ idention: inout Int,
        regulars: [String]
        ) -> Struct.RawSpec
    {
        // https://github.com/lyptt/struct/wiki/Spec-format:-v2.0#scripts
        
        //---
        
        var result: Struct.RawSpec = []
        
        //---
        
        for s in regulars
        {
            result <<< (idention, "-" + Struct.Spec.value(s))
        }
        
        //---
        
        return result
    }
    
    //---
    
    static
    func processScripts(
        _ idention: inout Int,
        beforeBuild: [String]
        ) -> Struct.RawSpec
    {
        // https://github.com/lyptt/struct/wiki/Spec-format:-v2.0#scripts
        
        //---
        
        var result: Struct.RawSpec = []
        
        //---
        
        result <<< (idention, Struct.Spec.key("prebuild"))
        
        for s in beforeBuild
        {
            result <<< (idention, "-" + Struct.Spec.value(s))
        }
        
        //---
        
        return result
    }
    
    //---
    
    static
    func processScripts(
        _ idention: inout Int,
        afterBuild: [String]
        ) -> Struct.RawSpec
    {
        // https://github.com/lyptt/struct/wiki/Spec-format:-v2.0#scripts
        
        //---
        
        var result: Struct.RawSpec = []
        
        //---
        
        result <<< (idention, Struct.Spec.key("postbuild"))
        
        for s in afterBuild
        {
            result <<< (idention, "-" + Struct.Spec.value(s))
        }
        
        //---
        
        return result
    }
}
