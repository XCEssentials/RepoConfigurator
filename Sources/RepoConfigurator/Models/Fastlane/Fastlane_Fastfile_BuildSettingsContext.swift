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

import FileKit

//---

public
extension Fastlane.Fastfile
{
    struct BuildSettingsContext
    {
        private
        let buffer: IndentedTextBuffer
        
        //internal
        init(
            _ buffer: IndentedTextBuffer
            )
        {
            self.buffer = buffer
        }
    }
}

// MARK: - Content rendering

public
extension Fastlane.Fastfile.BuildSettingsContext
{
    func projectLevel(
        project: Spec.Project,
        shared: Xcode.RawBuildSettings = [:],
        perConfiguration: [Xcode.BuildConfiguration : Xcode.RawBuildSettings] = [:]
        )
    {
        let project = [".", ".."] + project.location
        
        //---
        
        buffer <<< {"""
            
            # === Build Settings | \(project)
            
            begin
            
                project = Xcodeproj::Project.open("\(project)")
            
            rescue => ex
            
                # https://github.com/fastlane/fastlane/issues/7944#issuecomment-274232674
                UI.error ex
                UI.error("Failed to set Build Settings - \(project)")
            
            end
            
            project.build_configurations.each do |config|
            
            """
        }()
        
        buffer.indentation.nest{
            
            buffer <<< shared
                .sortedByKey()
                .map{ "config.build_settings['\($0)'] = '\($1)'" }
            
            perConfiguration.forEach{
                
                (config, settings) in
                
                //---
                
                buffer <<< {"""
                    if config.name == "\(config.title)"
                    
                    """
                }()
                
                buffer.indentation.nest{
                    
                    buffer <<< settings
                        .sortedByKey()
                        .map{ "config.build_settings['\($0)'] = '\($1)'" }
                }
                
                buffer <<< {"""
                    
                    end # config.name == "\(config.title)"
                    """
                }()
            }
        }
        
        buffer <<< {"""
            
            end # project.build_configurations.each

            project.save()
            
            UI.success("Set Build Settings - \(project)")
            """
        }()
    }
    
    func targetLevel(
        project: Spec.Project,
        target: String,
        shared: Xcode.RawBuildSettings = [:],
        perConfiguration: [Xcode.BuildConfiguration : Xcode.RawBuildSettings] = [:]
        )
    {
        let project: Path = [".", ".."] + project.location
        
        //---
        
        buffer <<< {"""
            
            # === Build Settings | \(target) | \(project)
            
            begin
            
                project = Xcodeproj::Project.open("\(project)")
            
            rescue => ex
            
                # https://github.com/fastlane/fastlane/issues/7944#issuecomment-274232674
                UI.error ex
                UI.error("Failed to set Build Settings - \(target) | \(project)")
            
            end
            
            begin
            
                target = project.targets.find { |e| e.name == "\(target)" }
                raise RuntimeError, 'Target \(target) is not found' if target.nil?
            
            rescue => ex
            
                # https://github.com/fastlane/fastlane/issues/7944#issuecomment-274232674
                UI.error ex
                UI.error("Failed to set Build Settings - \(target) | \(project)")
            
            end
            
            target.build_configurations.each do |config|
            
            """
        }()
        
        buffer.indentation.nest{
            
            buffer <<< shared
                .sortedByKey()
                .map{ "config.build_settings['\($0)'] = '\($1)'" }
            
            perConfiguration.forEach{
                
                (config, settings) in
                
                //---
                
                buffer.appendNewLine()
                
                buffer <<< {"""
                    if config.name == "\(config.title)"
                    
                    """
                }()
                
                buffer.indentation.nest{
                    
                    buffer <<< settings
                        .sortedByKey()
                        .map{ "config.build_settings['\($0)'] = '\($1)'" }
                }
                
                buffer <<< {"""
                    
                    end # config.name == "\(config.title)"
                    """
                }()
            }
        }
        
        buffer <<< {"""
            
            end # target.build_configurations.each

            project.save()
            
            UI.success("Set Build Settings - \(target) | \(project)")
            """
        }()
    }
}
