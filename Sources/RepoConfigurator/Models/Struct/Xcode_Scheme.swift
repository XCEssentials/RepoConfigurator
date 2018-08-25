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
    struct Scheme
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

        // MARK: Instance level members

        public
        let name: String

        public
        let contentGetter: (Indentation) -> IndentedText

        // MARK: Initializers

        public
        static
        func scheme(
            named name: String,
            _ sections: TextFileSection<Xcode.Scheme>...
            ) -> Scheme
        {
            return .init(name: name){

                let result = IndentedTextBuffer(with: $0)

                //---

                result <<< """
                    \(name):
                    """

                $0.nest{

                    result <<< sections
                }

                //---

                return result.content
            }
        }
    }
}

// MARK: - Content rendering

public
extension TextFileSection
    where
    Context == Xcode.Scheme
{
    static
    func build(
        parallel: Bool = true,
        buildImplicit: Bool = true,
        targets: [String: Xcode.Scheme.BuildOptions]
        ) -> TextFileSection<Context>
    {
        return .init{

            indentation in

            //---

            let result = IndentedTextBuffer(with: indentation)

            //---

            result <<< """
                build:
                """

            indentation.nest{

                result <<< """
                    parallel: \(parallel)
                    build_implicit: \(buildImplicit)
                    targets:
                    """

                indentation.nest{

                    result <<< targets.map{ """
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

            //---

            return result.content
        }
    }

    static
    func test(
        configuration: Xcode.BuildConfiguration = .debug,
        targets: [String],
        inheritLaunchArguments: Bool = true,
        codeCoverage: Bool = true,
        environment: [String: String] = ["OS_ACTIVITY_MODE": "disable"]
        ) -> TextFileSection<Context>
    {
        return .init{

            indentation in

            //---

            let result = IndentedTextBuffer(with: indentation)

            //---

            result <<< """
                test:
                """

            indentation.nest{

                result <<< """
                    # build_configuration is available from Spec 2.1.0
                    build_configuration: \(configuration)
                    inherit_launch_arguments: \(inheritLaunchArguments)
                    code_coverage_enabled: \(codeCoverage)
                    targets:
                    """

                result <<< targets.map{ """
                    - \($0)
                    """
                }

                result <<< """
                    environment:
                    """

                indentation.nest{

                    result <<< environment.map{ """
                        \($0.key): \($0.value)
                        """
                    }
                }
            }

            //---

            return result.content
        }
    }

    static
    func run(
        configuration: Xcode.BuildConfiguration = .debug,
        simulateLocation: Bool = true,
        target: String,
        arguments: [String] = [],
        environment: [String: String] = ["OS_ACTIVITY_MODE": "disable"]
        ) -> TextFileSection<Context>
    {
        return .init{

            indentation in

            //---

            let result = IndentedTextBuffer(with: indentation)

            //---

            result <<< """
                launch:
                """

            indentation.nest{

                result <<< """
                    # build_configuration is available from Spec 2.1.0
                    build_configuration: \(configuration)
                    simulate_location: \(simulateLocation)
                    target: \(target)
                    arguments: \(arguments.joined(separator: " "))
                    environment:
                    """

                indentation.nest{

                    result <<< environment.map{ """
                        \($0.key): \($0.value)
                        """
                    }
                }
            }

            //---

            return result.content
        }
    }

    static
    func profile(
        target: String,
        inheritEnvironment: Bool = true,
        configuration: Xcode.BuildConfiguration = .debug
        ) -> TextFileSection<Context>
    {
        return .init{

            let result = IndentedTextBuffer(with: $0)

            //---

            result <<< """
                profile:
                """

            $0.nest{

                result <<< """
                    target: iOSTest
                      inherit_environment: \(inheritEnvironment)
                      # build_configuration is available from Spec 2.1.0
                      build_configuration: \(configuration)
                    """
            }

            //---

            return result.content
        }
    }

    static
    func archive(
        name: String,
        reveal: Bool = false,
        configuration: Xcode.BuildConfiguration = .release
        ) -> TextFileSection<Context>
    {
        return .init{

            let result = IndentedTextBuffer(with: $0)

            //---

            result <<< """
                archive:
                """

            $0.nest{

                result <<< """
                    name: \(name).xcarchive
                    reveal: \(reveal)
                    # build_configuration is available from Spec 2.1.0
                    build_configuration: \(configuration)
                    """
            }

            //---

            return result.content
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
