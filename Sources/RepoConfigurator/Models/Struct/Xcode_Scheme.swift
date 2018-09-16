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

public
extension Xcode
{
    /**
     https://github.com/lyptt/struct/wiki/Spec-format%3A-v2.0#schemes
     */
    public
    final
    class Scheme
    {
        // MARK: Type level members

        public
        typealias BuildOptions = (
            archiving: Bool,
            running: Bool,
            profiling: Bool,
            testing: Bool,
            analyzing: Bool
        )
        
        public
        struct Sections
        {
            private
            let buffer: IndentedTextBuffer
            
            //internal
            init(
                buffer: IndentedTextBuffer
                )
            {
                self.buffer = buffer
            }
        }

        // MARK: Instance level members

        public
        let contentGetter: (Indentation) -> IndentedText

        // MARK: Initializers

        //internal
        init(
            named name: String,
            _ sections: @escaping (Sections) -> Void
            )
        {
            self.contentGetter = {

                let result = IndentedTextBuffer(with: $0)

                //---

                result <<< """
                    \(name):
                    """

                result.indentation.nest{

                    sections(
                        Sections(
                            buffer: result
                        )
                    )
                }

                //---

                return result.content
            }
        }
    }
}

// MARK: - Content rendering

public
extension Xcode.Scheme.Sections
{
    func build(
        parallel: Bool = true,
        buildImplicit: Bool = true,
        targets: [String: Xcode.Scheme.BuildOptions]
        )
    {
        buffer <<< """
            build:
            """

        buffer.indentation.nest{

            buffer <<< """
                parallel: \(parallel)
                build_implicit: \(buildImplicit)
                targets:
                """

            buffer.indentation.nest{

                buffer <<< targets.map{ """
                    \($0.key):
                      archiving_enabled: \($0.value.archiving)
                      running_enabled: \($0.value.running)
                      profiling_enabled: \($0.value.profiling)
                      testing_enabled: \($0.value.testing)
                      analyzing_enabled: \($0.value.analyzing)
                    """
                }
            }
        }
    }

    func test(
        configuration: Xcode.BuildConfiguration = .debug,
        targets: [String],
        inheritLaunchArguments: Bool = true,
        codeCoverage: Bool = true,
        environment: [String: String] = ["OS_ACTIVITY_MODE": "disable"]
        )
    {
        buffer <<< """
            test:
            """

        buffer.indentation.nest{

            buffer <<< """
                # build_configuration is available from Spec 2.1.0
                build_configuration: \(configuration)
                inherit_launch_arguments: \(inheritLaunchArguments)
                code_coverage_enabled: \(codeCoverage)
                targets:
                """

            buffer <<< targets.map{ """
                - \($0)
                """
            }

            buffer <<< """
                environment:
                """

            buffer.indentation.nest{

                buffer <<< environment.map{ """
                    \($0.key): \($0.value)
                    """
                }
            }
        }
    }

    func run(
        configuration: Xcode.BuildConfiguration = .debug,
        simulateLocation: Bool = true,
        target: String,
        arguments: [String] = [],
        environment: [String: String] = ["OS_ACTIVITY_MODE": "disable"]
        )
    {
        buffer <<< """
            launch:
            """

        buffer.indentation.nest{

            buffer <<< """
                # build_configuration is available from Spec 2.1.0
                build_configuration: \(configuration)
                simulate_location: \(simulateLocation)
                target: \(target)
                arguments: \(arguments.joined(separator: " "))
                environment:
                """

            buffer.indentation.nest{

                buffer <<< environment.map{ """
                    \($0.key): \($0.value)
                    """
                }
            }
        }
    }

    func profile(
        target: String,
        inheritEnvironment: Bool = true,
        configuration: Xcode.BuildConfiguration = .debug
        )
    {
        buffer <<< """
            profile:
            """

        buffer.indentation.nest{

            buffer <<< """
                target: iOSTest
                  inherit_environment: \(inheritEnvironment)
                  # build_configuration is available from Spec 2.1.0
                  build_configuration: \(configuration)
                """
        }
    }

    func archive(
        name: String,
        reveal: Bool = false,
        configuration: Xcode.BuildConfiguration = .release
        )
    {
        buffer <<< """
            archive:
            """

        buffer.indentation.nest{

            buffer <<< """
                name: \(name).xcarchive
                reveal: \(reveal)
                # build_configuration is available from Spec 2.1.0
                build_configuration: \(configuration)
                """
        }
    }
}

/*

 schemes:
  iOSTest:
    build:
      parallel: true
      build_implicit: true
      targets:
        iOSTest:
          archiving_enabled: false
          running_enabled: false
          profiling_enabled: false
          testing_enabled: false
          analyzing_enabled: false
    test:
      build_configuration: debug
      targets:
      - iOSTestTests
      inherit_launch_arguments: true
      code_coverage_enabled: true
      environment:
        OS_ACTIVITY_MODE: disable
    launch:
      # build_configuration is available from Spec 2.1.0
      build_configuration: debug
      simulate_location: true
      target: iOSTest
      arguments: -AppleLanguages (en-GB)
      environment:
        OS_ACTIVITY_MODE: disable
    profile:
      target: iOSTest
      inherit_environment: true
      # build_configuration is available from Spec 2.1.0
      build_configuration: debug
    archive:
      name: iOSTest.xcarchive
      reveal: true
      # build_configuration is available from Spec 2.1.0
      build_configuration: appstore

 */
