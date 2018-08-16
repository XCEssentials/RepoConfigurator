/*

 MIT License

 Copyright (c) 2018 Maxim Khatskevich

 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:

 The above copyright notice and this permission notice shall be included in all
 copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 SOFTWARE.

 */

//swiftlint:disable identifier_name

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
    func generate(for p: Xcode.Project) -> IndentedTextGetter
    {
        return {

            indentation in

            //---

            var result: IndentedText = []

            //---

            result <<< (indentation, "# https://github.com/lyptt/struct/wiki/Spec-format:-v2.0")

            //---

            // https://github.com/workshop/struct/wiki/Spec-format:-v2.0#version-number

            result <<< (indentation, Struct.Spec.key("version") + " \(Struct.Spec.v2_1_0.rawValue)")

            //---

            result <<< process(&indentation, p.buildSettings)

            //---

            result <<< process(&indentation, p.targets)

            //---

            result <<< process(&indentation, variants: p.variants, of: p)

            //---

            result <<< "".asIndentedText(with: &indentation) // empty line in the EOF

            //---

            return result
        }
    }
    
    //---
    
    static
    func process(
        _ indentation: inout Indentation,
        variants: [Xcode.Project.Variant],
        of baseProject: Xcode.Project
        ) -> IndentedText
    {
        var result: IndentedText = []
        
        //---
        
        result <<< (indentation, Struct.Spec.key("variants"))
        
        indentation++
        
        result <<< (indentation, Struct.Spec.key("$base"))
        
        indentation++
        
        result <<< (indentation, Struct.Spec.key("abstract") + " true")
        
        indentation--
        
        if
            variants.isEmpty
        {
            result <<< (indentation, Struct.Spec.key(baseProject.name))
        }
        else
        {
            result <<< process(&indentation, variants: variants)
        }
        
        indentation--
        
        //---
        
        return result
    }
    
    //---
    
    static
    func process(
        _ indentation: inout Indentation,
        variants: [Xcode.Project.Variant]
        ) -> IndentedText
    {
        // https://github.com/workshop/struct/wiki/Spec-format:-v2.0#variants
        
        //---
        
        var result: IndentedText = []
        
        //---
        
        for v in variants
        {
            result <<< (indentation, Struct.Spec.key(v.name))
            
            indentation++
            
            for t in v.targets
            {
                result <<< process(&indentation, t)
                
                //---
                
                for tst in t.tests
                {
                    result <<< process(&indentation, tst)
                }
            }
            
            indentation--
        }
        
        //---
        
        return result
    }
    
    //---
    
    static
    func process(
        _ indentation: inout Indentation,
        _ t: Xcode.Project.Variant.Target
        ) -> IndentedText
    {
        var result: IndentedText = []
        
        //---
        
        result <<< (indentation, Struct.Spec.key(t.name))
        
        //---
        
        indentation++
        
        //---
        
        result <<< process(&indentation, t.dependencies)
        
        //---
        
        // https://github.com/lyptt/struct/wiki/Spec-format:-v2.0#sources
        
        if
            !t.includes.isEmpty
        {
            result <<< (indentation, "sources:")
            
            for path in t.includes
            {
                result <<< (indentation, "-" + Struct.Spec.value(path))
            }
        }
        
        //---
        
        // https://github.com/lyptt/struct/wiki/Spec-format:-v2.0#excludes
        
        if
            !t.excludes.isEmpty
        {
            result <<< (indentation, Struct.Spec.key("excludes"))
            indentation++
            result <<< (indentation, Struct.Spec.key("files"))
            
            for path in t.excludes
            {
                result <<< (indentation, "-" + Struct.Spec.value(path))
            }
            
            indentation--
        }
        
        //---
        
        // https://github.com/workshop/struct/wiki/Spec-format:-v2.0#options
        
        if
            !t.sourceOptions.isEmpty
        {
            result <<< (indentation, "source_options:")
            indentation++
            
            for (path, opt) in t.sourceOptions
            {
                result <<< (indentation, Struct.Spec.key(path) + Struct.Spec.value(opt))
            }
            
            indentation--
        }
        
        //---
        
        // https://github.com/lyptt/struct/wiki/Spec-format:-v2.0#i18n-resources
        
        if
            !t.i18nResources.isEmpty
        {
            result <<< (indentation, Struct.Spec.key("i18n-resources"))
            
            for path in t.i18nResources
            {
                result <<< (indentation, "-" + Struct.Spec.value(path))
            }
        }
        
        //---
        
        result <<< t.buildSettings.asIndentedText(with: &indentation)
        
        //---
        
        result <<< process(&indentation, scripts: t.scripts)
        
        //---
        
        // https://github.com/lyptt/struct/wiki/Spec-format:-v2.0#cocoapods
        
        if
            t.includeCocoapods
        {
            result <<<
                (indentation,
                 Struct.Spec.key("includes_cocoapods") + Struct.Spec.value(t.includeCocoapods))
        }
        
        //---
        
        indentation--
        
        //---
        
        return result
    }

    //---
    
    static
    func process(
        _ indentation: inout Indentation,
        _ set: Xcode.Project.BuildSettings
        ) -> IndentedText
    {
        // https://github.com/lyptt/struct/wiki/Spec-format:-v1.2#configurations
        
        //---
        
        var result: IndentedText = []
        
        //---
        
        result <<< (indentation, Struct.Spec.key("configurations"))
        
        //---
        
        indentation++
        
        //---
        
        result <<< process(
            &indentation,
            set.base,
            config: .debug,
            set[.debug],
            externalConfig: set.externalConfig[.debug]
        )

        result <<< process(
            &indentation,
            set.base,
            config: .release,
            set[.release],
            externalConfig: set.externalConfig[.release]
        )
        
        //---
        
        indentation--
        
        //---
        
        return result
    }
    
    //---
    
    static
    func process(
        _ indentation: inout Indentation,
        _ base: Xcode.RawBuildSettings,
        config: Xcode.BuildConfiguration,
        _ overrides: Xcode.RawBuildSettings,
        externalConfig: String?
        ) -> IndentedText
    {
        // https://github.com/lyptt/struct/wiki/Spec-format:-v2.0#configurations
        
        //---
        
        var result: IndentedText = []
        
        //---
        
        result <<< (indentation, Struct.Spec.key(config.name))
        
        //---
        
        indentation++
        
        //---
        
        result <<< (indentation, Struct.Spec.key("type") + Struct.Spec.value(config))
        
        //---
        
        if
            let externalConfig = externalConfig
        {
            // https://github.com/lyptt/struct/wiki/Spec-format:-v2.0#xcconfig-references
            
            // NOTE: when using xcconfig files,
            // any overrides will be ignored.
            
            result <<< (indentation, Struct.Spec.key("source") + Struct.Spec.value(externalConfig) )
        }
        else
        {
            // NO source/xcconfig provided
            
            //---
            
            // NO profiles anymore
            // https://github.com/workshop/struct/wiki/Migrating-from-Spec-1.3.1-to-Spec-2.0.0
            
            //---
            
            // https://github.com/lyptt/struct/wiki/Spec-format:-v2.0#overrides
            
            result <<< (indentation, Struct.Spec.key("overrides"))
            indentation++
            
            for o in base.overriding(with: overrides)
            {
                result <<< (indentation, Struct.Spec.key(o.key) + Struct.Spec.value(o.value))
            }
            
            indentation--
        }
        
        //---
        
        indentation--
        
        //---
        
        return result
    }
    
    //---
    
    static
    func process(
        _ indentation: inout Indentation,
        _ targets: [Xcode.Target]
        ) -> IndentedText
    {
        // https://github.com/lyptt/struct/wiki/Spec-format:-v2.0#targets
        
        //---
        
        var result: IndentedText = []
        
        //---
        
        result <<< (indentation, Struct.Spec.key("targets"))
        
        //---
        
        indentation++
        
        //---
        
        for t in targets
        {
            result <<< process(&indentation, t)
            
            //---
            
            for tst in t.tests
            {
                result <<< process(&indentation, tst)
            }
        }
        
        //---
        
        indentation--
        
        //---
        
        return result
    }
    
    //---

    //swiftlint:disable:next cyclomatic_complexity
    static
    func process(
        _ indentation: inout Indentation,
        _ t: Xcode.Target
        ) -> IndentedText
    {
        // https://github.com/lyptt/struct/wiki/Spec-format:-v2.0#targets
        
        //---
        
        var result: IndentedText = []
        
        //---
        
        result <<< (indentation, Struct.Spec.key(t.name))
        
        //---
        
        indentation++
        
        //---
        
        // https://github.com/lyptt/struct/wiki/Spec-format:-v2.0#platform

        let platformId: String

        switch t.platform
        {
        case .iOS:
            platformId = "ios"

        case .watchOS:
            platformId = "watch"

        case .tvOS:
            platformId = "tv"

        case .macOS:
            platformId = "mac"
        }

        result <<< (indentation, Struct.Spec.key("platform") + " " + platformId)

        //---
        
        // https://github.com/lyptt/struct/wiki/Spec-format:-v2.0#type
        
        result <<< (indentation, Struct.Spec.key("type") + Struct.Spec.value(t.type.rawValue))
        
        //---
        
        result <<< process(&indentation, t.dependencies)
        
        //---
        
        // https://github.com/lyptt/struct/wiki/Spec-format:-v2.0#sources
        
        if
            !t.includes.isEmpty
        {
            result <<< (indentation, "sources:")
            
            for path in t.includes
            {
                result <<< (indentation, "-" + Struct.Spec.value(path))
            }
        }
        
        //---
        
        // https://github.com/lyptt/struct/wiki/Spec-format:-v2.0#excludes
        
        if
            !t.excludes.isEmpty
        {
            result <<< (indentation, Struct.Spec.key("excludes"))
            indentation++
            result <<< (indentation, Struct.Spec.key("files"))
            
            for path in t.excludes
            {
                result <<< (indentation, "-" + Struct.Spec.value(path))
            }
            
            indentation--
        }
        
        //---
        
        // https://github.com/workshop/struct/wiki/Spec-format:-v2.0#options
        
        if
            !t.sourceOptions.isEmpty
        {
            result <<< (indentation, "source_options:")
            indentation++
            
            for (path, opt) in t.sourceOptions
            {
                result <<< (indentation, Struct.Spec.key(path) + Struct.Spec.value(opt))
            }
            
            indentation--
        }
        
        //---
        
        // https://github.com/lyptt/struct/wiki/Spec-format:-v2.0#i18n-resources
        
        if
            !t.i18nResources.isEmpty
        {
            result <<< (indentation, Struct.Spec.key("i18n-resources"))
            
            for path in t.i18nResources
            {
                result <<< (indentation, "-" + Struct.Spec.value(path))
            }
        }
        
        //---
        
        result <<< t.buildSettings.asIndentedText(with: &indentation)
        
        //---
        
        result <<< process(&indentation, scripts: t.scripts)
        
        //---
        
        // https://github.com/lyptt/struct/wiki/Spec-format:-v2.0#cocoapods
        
        if
            t.includeCocoapods
        {
            result <<<
                (indentation,
                 Struct.Spec.key("includes_cocoapods") + Struct.Spec.value(t.includeCocoapods))
        }
        
        //---
        
        indentation--
        
        //---
        
        return result
    }
    
    //---
    
    static
    func process(
        _ indentation: inout Indentation,
        _ deps: Xcode.Target.Dependencies
        ) -> IndentedText
    {
        // https://github.com/lyptt/struct/wiki/Spec-format:-v2.0#references
        
        //---
        
        var result: IndentedText = []
        
        //---
        
        if
            !deps.fromSDKs.isEmpty ||
            !deps.otherTargets.isEmpty ||
            !deps.binaries.isEmpty ||
            !deps.projects.isEmpty
        {
            result <<< (indentation, Struct.Spec.key("references"))
            
            //---
            
            result <<< processDependencies(&indentation, fromSDK: deps.fromSDKs)
            result <<< processDependencies(&indentation, targets: deps.otherTargets)
            result <<< processDependencies(&indentation, binaries: deps.binaries)
            result <<< processDependencies(&indentation, projects: deps.projects)
        }
        
        //---
        
        return result
    }
    
    //---
    
    static
    func processDependencies(
        _ indentation: inout Indentation,
        fromSDK: [String]
        ) -> IndentedText
    {
        // https://github.com/lyptt/struct/wiki/Spec-format:-v2.0#references
        
        //---
        
        var result: IndentedText = []
        
        //---
        
        for dep in fromSDK
        {
            result <<< (indentation, "-" + Struct.Spec.value("sdkroot:\(dep)"))
        }
        
        //---
        
        return result
    }
    
    //---
    
    static
    func processDependencies(
        _ indentation: inout Indentation,
        targets: [String]
        ) -> IndentedText
    {
        // https://github.com/lyptt/struct/wiki/Spec-format:-v2.0#references
        
        //---
        
        var result: IndentedText = []
        
        //---
        
        for t in targets
        {
            result <<< (indentation, "-" + Struct.Spec.value(t))
        }
        
        //---
        
        return result
    }
    
    //---
    
    static
    func processDependencies(
        _ indentation: inout Indentation,
        binaries: [Xcode.Target.BinaryDependency]
        ) -> IndentedText
    {
        // https://github.com/lyptt/struct/wiki/Spec-format:-v2.0#references
        
        //---
        
        var result: IndentedText = []
        
        //---
        
        for b in binaries
        {
            result <<< (indentation, Struct.Spec.key("- location") + Struct.Spec.value(b.location))
            result <<< (indentation, Struct.Spec.key("  codeSignOnCopy") + Struct.Spec.value(b.codeSignOnCopy))
        }
        
        //---
        
        return result
    }
    
    //---
    
    static
    func processDependencies(
        _ indentation: inout Indentation,
        projects: [Xcode.Target.ProjectDependencies]
        ) -> IndentedText
    {
        // https://github.com/lyptt/struct/wiki/Spec-format:-v2.0#references
        
        //---
        
        var result: IndentedText = []
        
        //---
        
        for p in projects
        {
            result <<< (indentation, Struct.Spec.key("- location") + Struct.Spec.value(p.location))
            result <<< (indentation, Struct.Spec.key("  frameworks"))
            
            for f in p.frameworks
            {
                result <<< (indentation, Struct.Spec.key("  - name") + Struct.Spec.value(f.name))
                result <<< (indentation, Struct.Spec.key("    copy") + Struct.Spec.value(f.copy))
                result <<< (indentation, Struct.Spec.key("    codeSignOnCopy") + Struct.Spec.value(f.codeSignOnCopy))
            }
        }
        
        //---
        
        return result
    }

    //---
    
    static
    func process(
        _ indentation: inout Indentation,
        scripts: Xcode.Target.Scripts
        ) -> IndentedText
    {
        // https://github.com/lyptt/struct/wiki/Spec-format:-v2.0#scripts
        
        //---
        
        var result: IndentedText = []
        
        //---
        
        if
            !scripts.regulars.isEmpty ||
            !scripts.beforeBuilds.isEmpty ||
            !scripts.afterBuilds.isEmpty
        {
            result <<< (indentation, Struct.Spec.key("scripts"))
            
            //---
            
            indentation++
            
            //---
            
            if
                !scripts.regulars.isEmpty
            {
                result <<< processScripts(&indentation, regulars: scripts.regulars)
            }
            
            if
                !scripts.beforeBuilds.isEmpty
            {
                result <<< processScripts(&indentation, beforeBuild: scripts.beforeBuilds)
            }
            
            if
                !scripts.afterBuilds.isEmpty
            {
                result <<< processScripts(&indentation, afterBuild: scripts.afterBuilds)
            }
            
            //---
            
            indentation--
        }
        
        //---
        
        return result
    }
    
    //---
    
    static
    func processScripts(
        _ indentation: inout Indentation,
        regulars: [String]
        ) -> IndentedText
    {
        // https://github.com/lyptt/struct/wiki/Spec-format:-v2.0#scripts
        
        //---
        
        var result: IndentedText = []
        
        //---
        
        for s in regulars
        {
            result <<< (indentation, "-" + Struct.Spec.value(s))
        }
        
        //---
        
        return result
    }
    
    //---
    
    static
    func processScripts(
        _ indentation: inout Indentation,
        beforeBuild: [String]
        ) -> IndentedText
    {
        // https://github.com/lyptt/struct/wiki/Spec-format:-v2.0#scripts
        
        //---
        
        var result: IndentedText = []
        
        //---
        
        result <<< (indentation, Struct.Spec.key("prebuild"))
        
        for s in beforeBuild
        {
            result <<< (indentation, "-" + Struct.Spec.value(s))
        }
        
        //---
        
        return result
    }
    
    //---
    
    static
    func processScripts(
        _ indentation: inout Indentation,
        afterBuild: [String]
        ) -> IndentedText
    {
        // https://github.com/lyptt/struct/wiki/Spec-format:-v2.0#scripts
        
        //---
        
        var result: IndentedText = []
        
        //---
        
        result <<< (indentation, Struct.Spec.key("postbuild"))
        
        for s in afterBuild
        {
            result <<< (indentation, "-" + Struct.Spec.value(s))
        }
        
        //---
        
        return result
    }
}
