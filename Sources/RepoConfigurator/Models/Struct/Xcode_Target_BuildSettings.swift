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
extension Xcode.Target
{
    public
    final
    class BuildSettings: Xcode.BuildSettings {}
}

// MARK: - Presets

//internal
extension Xcode.Target.BuildSettings
{
    func iOSApp()
    {
        base.overrideWithXcodeBuildSettings(

            """
            ALWAYS_SEARCH_USER_PATHS = NO
            ASSETCATALOG_COMPILER_APPICON_NAME = AppIcon
            CLANG_ANALYZER_NONNULL = YES
            CLANG_ANALYZER_NUMBER_OBJECT_CONVERSION = YES_AGGRESSIVE
            CLANG_CXX_LANGUAGE_STANDARD = gnu++14
            CLANG_CXX_LIBRARY = libc++
            CLANG_ENABLE_MODULES = YES
            CLANG_ENABLE_OBJC_ARC = YES
            CLANG_ENABLE_OBJC_WEAK = YES
            CLANG_WARN__DUPLICATE_METHOD_MATCH = YES
            CLANG_WARN_BLOCK_CAPTURE_AUTORELEASING = YES
            CLANG_WARN_BOOL_CONVERSION = YES
            CLANG_WARN_COMMA = YES
            CLANG_WARN_CONSTANT_CONVERSION = YES
            CLANG_WARN_DEPRECATED_OBJC_IMPLEMENTATIONS = YES
            CLANG_WARN_DIRECT_OBJC_ISA_USAGE = YES_ERROR
            CLANG_WARN_DOCUMENTATION_COMMENTS = YES
            CLANG_WARN_EMPTY_BODY = YES
            CLANG_WARN_ENUM_CONVERSION = YES
            CLANG_WARN_INFINITE_RECURSION = YES
            CLANG_WARN_INT_CONVERSION = YES
            CLANG_WARN_NON_LITERAL_NULL_CONVERSION = YES
            CLANG_WARN_OBJC_IMPLICIT_RETAIN_SELF = YES
            CLANG_WARN_OBJC_LITERAL_CONVERSION = YES
            CLANG_WARN_OBJC_ROOT_CLASS = YES_ERROR
            CLANG_WARN_RANGE_LOOP_ANALYSIS = YES
            CLANG_WARN_STRICT_PROTOTYPES = YES
            CLANG_WARN_SUSPICIOUS_MOVE = YES
            CLANG_WARN_UNGUARDED_AVAILABILITY = YES_AGGRESSIVE
            CLANG_WARN_UNREACHABLE_CODE = YES
            CODE_SIGN_IDENTITY = iPhone Developer
            CODE_SIGN_STYLE = Automatic
            COPY_PHASE_STRIP = NO
            ENABLE_STRICT_OBJC_MSGSEND = YES
            GCC_C_LANGUAGE_STANDARD = gnu11
            GCC_NO_COMMON_BLOCKS = YES
            GCC_WARN_64_TO_32_BIT_CONVERSION = YES
            GCC_WARN_ABOUT_RETURN_TYPE = YES_ERROR
            GCC_WARN_UNDECLARED_SELECTOR = YES
            GCC_WARN_UNINITIALIZED_AUTOS = YES_AGGRESSIVE
            GCC_WARN_UNUSED_FUNCTION = YES
            GCC_WARN_UNUSED_VARIABLE = YES
            IPHONEOS_DEPLOYMENT_TARGET = 12.0
            LD_RUNPATH_SEARCH_PATHS = $(inherited) @executable_path/Frameworks
            MTL_FAST_MATH = YES
            PRODUCT_NAME = $(TARGET_NAME)
            SDKROOT = iphoneos
            SWIFT_VERSION = $(inherited)
            TARGETED_DEVICE_FAMILY = 1,2
            """
        )

        self[.debug].overrideWithXcodeBuildSettings(

            """
            DEBUG_INFORMATION_FORMAT = dwarf
            ENABLE_TESTABILITY = YES
            GCC_DYNAMIC_NO_PIC = NO
            GCC_OPTIMIZATION_LEVEL = 0
            GCC_PREPROCESSOR_DEFINITIONS = DEBUG=1 $(inherited)
            MTL_ENABLE_DEBUG_INFO = INCLUDE_SOURCE
            ONLY_ACTIVE_ARCH = YES
            SWIFT_ACTIVE_COMPILATION_CONDITIONS = DEBUG
            SWIFT_OPTIMIZATION_LEVEL = -Onone
            """
        )

        self[.release].overrideWithXcodeBuildSettings(

            """
            DEBUG_INFORMATION_FORMAT = dwarf-with-dsym
            ENABLE_NS_ASSERTIONS = NO
            MTL_ENABLE_DEBUG_INFO = NO
            SWIFT_COMPILATION_MODE = wholemodule
            SWIFT_OPTIMIZATION_LEVEL = -O
            VALIDATE_PRODUCT = YES
            """
        )
    }

    func iOSAppTests()
    {
        base.overrideWithXcodeBuildSettings(

            """
            ALWAYS_EMBED_SWIFT_STANDARD_LIBRARIES = YES
            ALWAYS_SEARCH_USER_PATHS = NO
            BUNDLE_LOADER = $(TEST_HOST)
            CLANG_ANALYZER_NONNULL = YES
            CLANG_ANALYZER_NUMBER_OBJECT_CONVERSION = YES_AGGRESSIVE
            CLANG_CXX_LANGUAGE_STANDARD = gnu++14
            CLANG_CXX_LIBRARY = libc++
            CLANG_ENABLE_MODULES = YES
            CLANG_ENABLE_OBJC_ARC = YES
            CLANG_ENABLE_OBJC_WEAK = YES
            CLANG_WARN__DUPLICATE_METHOD_MATCH = YES
            CLANG_WARN_BLOCK_CAPTURE_AUTORELEASING = YES
            CLANG_WARN_BOOL_CONVERSION = YES
            CLANG_WARN_COMMA = YES
            CLANG_WARN_CONSTANT_CONVERSION = YES
            CLANG_WARN_DEPRECATED_OBJC_IMPLEMENTATIONS = YES
            CLANG_WARN_DIRECT_OBJC_ISA_USAGE = YES_ERROR
            CLANG_WARN_DOCUMENTATION_COMMENTS = YES
            CLANG_WARN_EMPTY_BODY = YES
            CLANG_WARN_ENUM_CONVERSION = YES
            CLANG_WARN_INFINITE_RECURSION = YES
            CLANG_WARN_INT_CONVERSION = YES
            CLANG_WARN_NON_LITERAL_NULL_CONVERSION = YES
            CLANG_WARN_OBJC_IMPLICIT_RETAIN_SELF = YES
            CLANG_WARN_OBJC_LITERAL_CONVERSION = YES
            CLANG_WARN_OBJC_ROOT_CLASS = YES_ERROR
            CLANG_WARN_RANGE_LOOP_ANALYSIS = YES
            CLANG_WARN_STRICT_PROTOTYPES = YES
            CLANG_WARN_SUSPICIOUS_MOVE = YES
            CLANG_WARN_UNGUARDED_AVAILABILITY = YES_AGGRESSIVE
            CLANG_WARN_UNREACHABLE_CODE = YES
            CODE_SIGN_IDENTITY = iPhone Developer
            CODE_SIGN_STYLE = Automatic
            COPY_PHASE_STRIP = NO
            ENABLE_STRICT_OBJC_MSGSEND = YES
            GCC_C_LANGUAGE_STANDARD = gnu11
            GCC_NO_COMMON_BLOCKS = YES
            GCC_WARN_64_TO_32_BIT_CONVERSION = YES
            GCC_WARN_ABOUT_RETURN_TYPE = YES_ERROR
            GCC_WARN_UNDECLARED_SELECTOR = YES
            GCC_WARN_UNINITIALIZED_AUTOS = YES_AGGRESSIVE
            GCC_WARN_UNUSED_FUNCTION = YES
            GCC_WARN_UNUSED_VARIABLE = YES
            IPHONEOS_DEPLOYMENT_TARGET = 12.0
            LD_RUNPATH_SEARCH_PATHS = $(inherited) @executable_path/Frameworks @loader_path/Frameworks
            MTL_FAST_MATH = YES
            PRODUCT_NAME = $(TARGET_NAME)
            SDKROOT = iphoneos
            SWIFT_VERSION = $(inherited)
            TARGETED_DEVICE_FAMILY = 1,2
            """
        )

        self[.debug].overrideWithXcodeBuildSettings(

            """
            DEBUG_INFORMATION_FORMAT = dwarf
            ENABLE_TESTABILITY = YES
            GCC_DYNAMIC_NO_PIC = NO
            GCC_OPTIMIZATION_LEVEL = 0
            GCC_PREPROCESSOR_DEFINITIONS = DEBUG=1 $(inherited)
            MTL_ENABLE_DEBUG_INFO = INCLUDE_SOURCE
            ONLY_ACTIVE_ARCH = YES
            SWIFT_ACTIVE_COMPILATION_CONDITIONS = DEBUG
            SWIFT_OPTIMIZATION_LEVEL = -Onone
            """
        )

        self[.release].overrideWithXcodeBuildSettings(

            """
            DEBUG_INFORMATION_FORMAT = dwarf-with-dsym
            ENABLE_NS_ASSERTIONS = NO
            MTL_ENABLE_DEBUG_INFO = NO
            SWIFT_COMPILATION_MODE = wholemodule
            SWIFT_OPTIMIZATION_LEVEL = -O
            VALIDATE_PRODUCT = YES
            """
        )
    }

    func iOSAppUITests()
    {
        base.overrideWithXcodeBuildSettings(

            """
            ALWAYS_EMBED_SWIFT_STANDARD_LIBRARIES = YES
            ALWAYS_SEARCH_USER_PATHS = NO
            CLANG_ANALYZER_NONNULL = YES
            CLANG_ANALYZER_NUMBER_OBJECT_CONVERSION = YES_AGGRESSIVE
            CLANG_CXX_LANGUAGE_STANDARD = gnu++14
            CLANG_CXX_LIBRARY = libc++
            CLANG_ENABLE_MODULES = YES
            CLANG_ENABLE_OBJC_ARC = YES
            CLANG_ENABLE_OBJC_WEAK = YES
            CLANG_WARN__DUPLICATE_METHOD_MATCH = YES
            CLANG_WARN_BLOCK_CAPTURE_AUTORELEASING = YES
            CLANG_WARN_BOOL_CONVERSION = YES
            CLANG_WARN_COMMA = YES
            CLANG_WARN_CONSTANT_CONVERSION = YES
            CLANG_WARN_DEPRECATED_OBJC_IMPLEMENTATIONS = YES
            CLANG_WARN_DIRECT_OBJC_ISA_USAGE = YES_ERROR
            CLANG_WARN_DOCUMENTATION_COMMENTS = YES
            CLANG_WARN_EMPTY_BODY = YES
            CLANG_WARN_ENUM_CONVERSION = YES
            CLANG_WARN_INFINITE_RECURSION = YES
            CLANG_WARN_INT_CONVERSION = YES
            CLANG_WARN_NON_LITERAL_NULL_CONVERSION = YES
            CLANG_WARN_OBJC_IMPLICIT_RETAIN_SELF = YES
            CLANG_WARN_OBJC_LITERAL_CONVERSION = YES
            CLANG_WARN_OBJC_ROOT_CLASS = YES_ERROR
            CLANG_WARN_RANGE_LOOP_ANALYSIS = YES
            CLANG_WARN_STRICT_PROTOTYPES = YES
            CLANG_WARN_SUSPICIOUS_MOVE = YES
            CLANG_WARN_UNGUARDED_AVAILABILITY = YES_AGGRESSIVE
            CLANG_WARN_UNREACHABLE_CODE = YES
            CODE_SIGN_IDENTITY = iPhone Developer
            CODE_SIGN_STYLE = Automatic
            COPY_PHASE_STRIP = NO
            ENABLE_STRICT_OBJC_MSGSEND = YES
            GCC_C_LANGUAGE_STANDARD = gnu11
            GCC_NO_COMMON_BLOCKS = YES
            GCC_WARN_64_TO_32_BIT_CONVERSION = YES
            GCC_WARN_ABOUT_RETURN_TYPE = YES_ERROR
            GCC_WARN_UNDECLARED_SELECTOR = YES
            GCC_WARN_UNINITIALIZED_AUTOS = YES_AGGRESSIVE
            GCC_WARN_UNUSED_FUNCTION = YES
            GCC_WARN_UNUSED_VARIABLE = YES
            IPHONEOS_DEPLOYMENT_TARGET = 12.0
            LD_RUNPATH_SEARCH_PATHS = $(inherited) @executable_path/Frameworks @loader_path/Frameworks
            MTL_FAST_MATH = YES
            PRODUCT_NAME = $(TARGET_NAME)
            SDKROOT = iphoneos
            SWIFT_VERSION = $(inherited)
            TARGETED_DEVICE_FAMILY = 1,2
            """
        )

        self[.debug].overrideWithXcodeBuildSettings(

            """
            DEBUG_INFORMATION_FORMAT = dwarf
            ENABLE_TESTABILITY = YES
            GCC_DYNAMIC_NO_PIC = NO
            GCC_OPTIMIZATION_LEVEL = 0
            GCC_PREPROCESSOR_DEFINITIONS = DEBUG=1 $(inherited)
            MTL_ENABLE_DEBUG_INFO = INCLUDE_SOURCE
            ONLY_ACTIVE_ARCH = YES
            SWIFT_ACTIVE_COMPILATION_CONDITIONS = DEBUG
            SWIFT_OPTIMIZATION_LEVEL = -Onone
            """
        )

        self[.release].overrideWithXcodeBuildSettings(

            """
            DEBUG_INFORMATION_FORMAT = dwarf-with-dsym
            ENABLE_NS_ASSERTIONS = NO
            MTL_ENABLE_DEBUG_INFO = NO
            SWIFT_COMPILATION_MODE = wholemodule
            SWIFT_OPTIMIZATION_LEVEL = -O
            VALIDATE_PRODUCT = YES
            """
        )
    }

    func macOSApp()
    {
        base.overrideWithXcodeBuildSettings(

            """
            ALWAYS_SEARCH_USER_PATHS = NO
            ASSETCATALOG_COMPILER_APPICON_NAME = AppIcon
            CLANG_ANALYZER_NONNULL = YES
            CLANG_ANALYZER_NUMBER_OBJECT_CONVERSION = YES_AGGRESSIVE
            CLANG_CXX_LANGUAGE_STANDARD = gnu++14
            CLANG_CXX_LIBRARY = libc++
            CLANG_ENABLE_MODULES = YES
            CLANG_ENABLE_OBJC_ARC = YES
            CLANG_ENABLE_OBJC_WEAK = YES
            CLANG_WARN__DUPLICATE_METHOD_MATCH = YES
            CLANG_WARN_BLOCK_CAPTURE_AUTORELEASING = YES
            CLANG_WARN_BOOL_CONVERSION = YES
            CLANG_WARN_COMMA = YES
            CLANG_WARN_CONSTANT_CONVERSION = YES
            CLANG_WARN_DEPRECATED_OBJC_IMPLEMENTATIONS = YES
            CLANG_WARN_DIRECT_OBJC_ISA_USAGE = YES_ERROR
            CLANG_WARN_DOCUMENTATION_COMMENTS = YES
            CLANG_WARN_EMPTY_BODY = YES
            CLANG_WARN_ENUM_CONVERSION = YES
            CLANG_WARN_INFINITE_RECURSION = YES
            CLANG_WARN_INT_CONVERSION = YES
            CLANG_WARN_NON_LITERAL_NULL_CONVERSION = YES
            CLANG_WARN_OBJC_IMPLICIT_RETAIN_SELF = YES
            CLANG_WARN_OBJC_LITERAL_CONVERSION = YES
            CLANG_WARN_OBJC_ROOT_CLASS = YES_ERROR
            CLANG_WARN_RANGE_LOOP_ANALYSIS = YES
            CLANG_WARN_STRICT_PROTOTYPES = YES
            CLANG_WARN_SUSPICIOUS_MOVE = YES
            CLANG_WARN_UNGUARDED_AVAILABILITY = YES_AGGRESSIVE
            CLANG_WARN_UNREACHABLE_CODE = YES
            CODE_SIGN_ENTITLEMENTS = macOS/macOS.entitlements
            CODE_SIGN_IDENTITY = Mac Developer
            CODE_SIGN_STYLE = Automatic
            COMBINE_HIDPI_IMAGES = YES
            COPY_PHASE_STRIP = NO
            ENABLE_STRICT_OBJC_MSGSEND = YES
            GCC_C_LANGUAGE_STANDARD = gnu11
            GCC_NO_COMMON_BLOCKS = YES
            GCC_WARN_64_TO_32_BIT_CONVERSION = YES
            GCC_WARN_ABOUT_RETURN_TYPE = YES_ERROR
            GCC_WARN_UNDECLARED_SELECTOR = YES
            GCC_WARN_UNINITIALIZED_AUTOS = YES_AGGRESSIVE
            GCC_WARN_UNUSED_FUNCTION = YES
            GCC_WARN_UNUSED_VARIABLE = YES
            LD_RUNPATH_SEARCH_PATHS = $(inherited) @executable_path/../Frameworks
            MACOSX_DEPLOYMENT_TARGET = 10.13
            MTL_FAST_MATH = YES
            PRODUCT_NAME = $(TARGET_NAME)
            SDKROOT = macosx
            SWIFT_VERSION = $(inherited)
            """
        )

        self[.debug].overrideWithXcodeBuildSettings(

            """
            DEBUG_INFORMATION_FORMAT = dwarf
            ENABLE_TESTABILITY = YES
            GCC_DYNAMIC_NO_PIC = NO
            GCC_OPTIMIZATION_LEVEL = 0
            GCC_PREPROCESSOR_DEFINITIONS = DEBUG=1 $(inherited)
            MTL_ENABLE_DEBUG_INFO = INCLUDE_SOURCE
            ONLY_ACTIVE_ARCH = YES
            SWIFT_ACTIVE_COMPILATION_CONDITIONS = DEBUG
            SWIFT_OPTIMIZATION_LEVEL = -Onone
            """
        )

        self[.release].overrideWithXcodeBuildSettings(

            """
            DEBUG_INFORMATION_FORMAT = dwarf-with-dsym
            ENABLE_NS_ASSERTIONS = NO
            MTL_ENABLE_DEBUG_INFO = NO
            SWIFT_COMPILATION_MODE = wholemodule
            SWIFT_OPTIMIZATION_LEVEL = -O
            """
        )
    }

    func macOSAppTests()
    {
        base.overrideWithXcodeBuildSettings(

            """
            ALWAYS_EMBED_SWIFT_STANDARD_LIBRARIES = YES
            ALWAYS_SEARCH_USER_PATHS = NO
            BUNDLE_LOADER = $(TEST_HOST)
            CLANG_ANALYZER_NONNULL = YES
            CLANG_ANALYZER_NUMBER_OBJECT_CONVERSION = YES_AGGRESSIVE
            CLANG_CXX_LANGUAGE_STANDARD = gnu++14
            CLANG_CXX_LIBRARY = libc++
            CLANG_ENABLE_MODULES = YES
            CLANG_ENABLE_OBJC_ARC = YES
            CLANG_ENABLE_OBJC_WEAK = YES
            CLANG_WARN__DUPLICATE_METHOD_MATCH = YES
            CLANG_WARN_BLOCK_CAPTURE_AUTORELEASING = YES
            CLANG_WARN_BOOL_CONVERSION = YES
            CLANG_WARN_COMMA = YES
            CLANG_WARN_CONSTANT_CONVERSION = YES
            CLANG_WARN_DEPRECATED_OBJC_IMPLEMENTATIONS = YES
            CLANG_WARN_DIRECT_OBJC_ISA_USAGE = YES_ERROR
            CLANG_WARN_DOCUMENTATION_COMMENTS = YES
            CLANG_WARN_EMPTY_BODY = YES
            CLANG_WARN_ENUM_CONVERSION = YES
            CLANG_WARN_INFINITE_RECURSION = YES
            CLANG_WARN_INT_CONVERSION = YES
            CLANG_WARN_NON_LITERAL_NULL_CONVERSION = YES
            CLANG_WARN_OBJC_IMPLICIT_RETAIN_SELF = YES
            CLANG_WARN_OBJC_LITERAL_CONVERSION = YES
            CLANG_WARN_OBJC_ROOT_CLASS = YES_ERROR
            CLANG_WARN_RANGE_LOOP_ANALYSIS = YES
            CLANG_WARN_STRICT_PROTOTYPES = YES
            CLANG_WARN_SUSPICIOUS_MOVE = YES
            CLANG_WARN_UNGUARDED_AVAILABILITY = YES_AGGRESSIVE
            CLANG_WARN_UNREACHABLE_CODE = YES
            CODE_SIGN_IDENTITY = Mac Developer
            CODE_SIGN_STYLE = Automatic
            COMBINE_HIDPI_IMAGES = YES
            COPY_PHASE_STRIP = NO
            ENABLE_STRICT_OBJC_MSGSEND = YES
            GCC_C_LANGUAGE_STANDARD = gnu11
            GCC_NO_COMMON_BLOCKS = YES
            GCC_WARN_64_TO_32_BIT_CONVERSION = YES
            GCC_WARN_ABOUT_RETURN_TYPE = YES_ERROR
            GCC_WARN_UNDECLARED_SELECTOR = YES
            GCC_WARN_UNINITIALIZED_AUTOS = YES_AGGRESSIVE
            GCC_WARN_UNUSED_FUNCTION = YES
            GCC_WARN_UNUSED_VARIABLE = YES
            LD_RUNPATH_SEARCH_PATHS = $(inherited) @executable_path/../Frameworks @loader_path/../Frameworks
            MACOSX_DEPLOYMENT_TARGET = 10.13
            MTL_FAST_MATH = YES
            PRODUCT_NAME = $(TARGET_NAME)
            SDKROOT = macosx
            SWIFT_VERSION = $(inherited)
            """
        )

        self[.debug].overrideWithXcodeBuildSettings(

            """
            DEBUG_INFORMATION_FORMAT = dwarf
            ENABLE_TESTABILITY = YES
            GCC_DYNAMIC_NO_PIC = NO
            GCC_OPTIMIZATION_LEVEL = 0
            GCC_PREPROCESSOR_DEFINITIONS = DEBUG=1 $(inherited)
            MTL_ENABLE_DEBUG_INFO = INCLUDE_SOURCE
            ONLY_ACTIVE_ARCH = YES
            SWIFT_ACTIVE_COMPILATION_CONDITIONS = DEBUG
            SWIFT_OPTIMIZATION_LEVEL = -Onone
            """
        )

        self[.release].overrideWithXcodeBuildSettings(

            """
            DEBUG_INFORMATION_FORMAT = dwarf-with-dsym
            ENABLE_NS_ASSERTIONS = NO
            MTL_ENABLE_DEBUG_INFO = NO
            SWIFT_COMPILATION_MODE = wholemodule
            SWIFT_OPTIMIZATION_LEVEL = -O
            """
        )
    }

    func macOSAppUITests()
    {
        base.overrideWithXcodeBuildSettings(

            """
            ALWAYS_EMBED_SWIFT_STANDARD_LIBRARIES = YES
            ALWAYS_SEARCH_USER_PATHS = NO
            CLANG_ANALYZER_NONNULL = YES
            CLANG_ANALYZER_NUMBER_OBJECT_CONVERSION = YES_AGGRESSIVE
            CLANG_CXX_LANGUAGE_STANDARD = gnu++14
            CLANG_CXX_LIBRARY = libc++
            CLANG_ENABLE_MODULES = YES
            CLANG_ENABLE_OBJC_ARC = YES
            CLANG_ENABLE_OBJC_WEAK = YES
            CLANG_WARN__DUPLICATE_METHOD_MATCH = YES
            CLANG_WARN_BLOCK_CAPTURE_AUTORELEASING = YES
            CLANG_WARN_BOOL_CONVERSION = YES
            CLANG_WARN_COMMA = YES
            CLANG_WARN_CONSTANT_CONVERSION = YES
            CLANG_WARN_DEPRECATED_OBJC_IMPLEMENTATIONS = YES
            CLANG_WARN_DIRECT_OBJC_ISA_USAGE = YES_ERROR
            CLANG_WARN_DOCUMENTATION_COMMENTS = YES
            CLANG_WARN_EMPTY_BODY = YES
            CLANG_WARN_ENUM_CONVERSION = YES
            CLANG_WARN_INFINITE_RECURSION = YES
            CLANG_WARN_INT_CONVERSION = YES
            CLANG_WARN_NON_LITERAL_NULL_CONVERSION = YES
            CLANG_WARN_OBJC_IMPLICIT_RETAIN_SELF = YES
            CLANG_WARN_OBJC_LITERAL_CONVERSION = YES
            CLANG_WARN_OBJC_ROOT_CLASS = YES_ERROR
            CLANG_WARN_RANGE_LOOP_ANALYSIS = YES
            CLANG_WARN_STRICT_PROTOTYPES = YES
            CLANG_WARN_SUSPICIOUS_MOVE = YES
            CLANG_WARN_UNGUARDED_AVAILABILITY = YES_AGGRESSIVE
            CLANG_WARN_UNREACHABLE_CODE = YES
            CODE_SIGN_IDENTITY = Mac Developer
            CODE_SIGN_STYLE = Automatic
            COMBINE_HIDPI_IMAGES = YES
            COPY_PHASE_STRIP = NO
            ENABLE_STRICT_OBJC_MSGSEND = YES
            GCC_C_LANGUAGE_STANDARD = gnu11
            GCC_NO_COMMON_BLOCKS = YES
            GCC_WARN_64_TO_32_BIT_CONVERSION = YES
            GCC_WARN_ABOUT_RETURN_TYPE = YES_ERROR
            GCC_WARN_UNDECLARED_SELECTOR = YES
            GCC_WARN_UNINITIALIZED_AUTOS = YES_AGGRESSIVE
            GCC_WARN_UNUSED_FUNCTION = YES
            GCC_WARN_UNUSED_VARIABLE = YES
            LD_RUNPATH_SEARCH_PATHS = $(inherited) @executable_path/../Frameworks @loader_path/../Frameworks
            MACOSX_DEPLOYMENT_TARGET = 10.13
            MTL_FAST_MATH = YES
            PRODUCT_NAME = $(TARGET_NAME)
            SDKROOT = macosx
            SWIFT_VERSION = $(inherited)
            """
        )

        self[.debug].overrideWithXcodeBuildSettings(

            """
            DEBUG_INFORMATION_FORMAT = dwarf
            ENABLE_TESTABILITY = YES
            GCC_DYNAMIC_NO_PIC = NO
            GCC_OPTIMIZATION_LEVEL = 0
            GCC_PREPROCESSOR_DEFINITIONS = DEBUG=1 $(inherited)
            MTL_ENABLE_DEBUG_INFO = INCLUDE_SOURCE
            ONLY_ACTIVE_ARCH = YES
            SWIFT_ACTIVE_COMPILATION_CONDITIONS = DEBUG
            SWIFT_OPTIMIZATION_LEVEL = -Onone
            """
        )

        self[.release].overrideWithXcodeBuildSettings(

            """
            DEBUG_INFORMATION_FORMAT = dwarf-with-dsym
            ENABLE_NS_ASSERTIONS = NO
            MTL_ENABLE_DEBUG_INFO = NO
            SWIFT_COMPILATION_MODE = wholemodule
            SWIFT_OPTIMIZATION_LEVEL = -O
            """
        )
    }

    func tvOSApp()
    {
        base.overrideWithXcodeBuildSettings(

            """
            ALWAYS_SEARCH_USER_PATHS = NO
            ASSETCATALOG_COMPILER_APPICON_NAME = App Icon & Top Shelf Image
            ASSETCATALOG_COMPILER_LAUNCHIMAGE_NAME = LaunchImage
            CLANG_ANALYZER_NONNULL = YES
            CLANG_ANALYZER_NUMBER_OBJECT_CONVERSION = YES_AGGRESSIVE
            CLANG_CXX_LANGUAGE_STANDARD = gnu++14
            CLANG_CXX_LIBRARY = libc++
            CLANG_ENABLE_MODULES = YES
            CLANG_ENABLE_OBJC_ARC = YES
            CLANG_ENABLE_OBJC_WEAK = YES
            CLANG_WARN__DUPLICATE_METHOD_MATCH = YES
            CLANG_WARN_BLOCK_CAPTURE_AUTORELEASING = YES
            CLANG_WARN_BOOL_CONVERSION = YES
            CLANG_WARN_COMMA = YES
            CLANG_WARN_CONSTANT_CONVERSION = YES
            CLANG_WARN_DEPRECATED_OBJC_IMPLEMENTATIONS = YES
            CLANG_WARN_DIRECT_OBJC_ISA_USAGE = YES_ERROR
            CLANG_WARN_DOCUMENTATION_COMMENTS = YES
            CLANG_WARN_EMPTY_BODY = YES
            CLANG_WARN_ENUM_CONVERSION = YES
            CLANG_WARN_INFINITE_RECURSION = YES
            CLANG_WARN_INT_CONVERSION = YES
            CLANG_WARN_NON_LITERAL_NULL_CONVERSION = YES
            CLANG_WARN_OBJC_IMPLICIT_RETAIN_SELF = YES
            CLANG_WARN_OBJC_LITERAL_CONVERSION = YES
            CLANG_WARN_OBJC_ROOT_CLASS = YES_ERROR
            CLANG_WARN_RANGE_LOOP_ANALYSIS = YES
            CLANG_WARN_STRICT_PROTOTYPES = YES
            CLANG_WARN_SUSPICIOUS_MOVE = YES
            CLANG_WARN_UNGUARDED_AVAILABILITY = YES_AGGRESSIVE
            CLANG_WARN_UNREACHABLE_CODE = YES
            CODE_SIGN_STYLE = Automatic
            COPY_PHASE_STRIP = NO
            ENABLE_STRICT_OBJC_MSGSEND = YES
            GCC_C_LANGUAGE_STANDARD = gnu11
            GCC_NO_COMMON_BLOCKS = YES
            GCC_WARN_64_TO_32_BIT_CONVERSION = YES
            GCC_WARN_ABOUT_RETURN_TYPE = YES_ERROR
            GCC_WARN_UNDECLARED_SELECTOR = YES
            GCC_WARN_UNINITIALIZED_AUTOS = YES_AGGRESSIVE
            GCC_WARN_UNUSED_FUNCTION = YES
            GCC_WARN_UNUSED_VARIABLE = YES
            LD_RUNPATH_SEARCH_PATHS = $(inherited) @executable_path/Frameworks
            MTL_FAST_MATH = YES
            PRODUCT_NAME = $(TARGET_NAME)
            SDKROOT = appletvos
            SWIFT_VERSION = $(inherited)
            TARGETED_DEVICE_FAMILY = 3
            TVOS_DEPLOYMENT_TARGET = 12.0
            """
        )

        self[.debug].overrideWithXcodeBuildSettings(

            """
            DEBUG_INFORMATION_FORMAT = dwarf
            ENABLE_TESTABILITY = YES
            GCC_DYNAMIC_NO_PIC = NO
            GCC_OPTIMIZATION_LEVEL = 0
            GCC_PREPROCESSOR_DEFINITIONS = DEBUG=1 $(inherited)
            MTL_ENABLE_DEBUG_INFO = INCLUDE_SOURCE
            ONLY_ACTIVE_ARCH = YES
            SWIFT_ACTIVE_COMPILATION_CONDITIONS = DEBUG
            SWIFT_OPTIMIZATION_LEVEL = -Onone
            """
        )

        self[.release].overrideWithXcodeBuildSettings(

            """
            DEBUG_INFORMATION_FORMAT = dwarf-with-dsym
            ENABLE_NS_ASSERTIONS = NO
            MTL_ENABLE_DEBUG_INFO = NO
            SWIFT_COMPILATION_MODE = wholemodule
            SWIFT_OPTIMIZATION_LEVEL = -O
            VALIDATE_PRODUCT = YES
            """
        )
    }

    func tvOSAppTests()
    {
        base.overrideWithXcodeBuildSettings(

            """
            ALWAYS_EMBED_SWIFT_STANDARD_LIBRARIES = YES
            ALWAYS_SEARCH_USER_PATHS = NO
            BUNDLE_LOADER = $(TEST_HOST)
            CLANG_ANALYZER_NONNULL = YES
            CLANG_ANALYZER_NUMBER_OBJECT_CONVERSION = YES_AGGRESSIVE
            CLANG_CXX_LANGUAGE_STANDARD = gnu++14
            CLANG_CXX_LIBRARY = libc++
            CLANG_ENABLE_MODULES = YES
            CLANG_ENABLE_OBJC_ARC = YES
            CLANG_ENABLE_OBJC_WEAK = YES
            CLANG_WARN__DUPLICATE_METHOD_MATCH = YES
            CLANG_WARN_BLOCK_CAPTURE_AUTORELEASING = YES
            CLANG_WARN_BOOL_CONVERSION = YES
            CLANG_WARN_COMMA = YES
            CLANG_WARN_CONSTANT_CONVERSION = YES
            CLANG_WARN_DEPRECATED_OBJC_IMPLEMENTATIONS = YES
            CLANG_WARN_DIRECT_OBJC_ISA_USAGE = YES_ERROR
            CLANG_WARN_DOCUMENTATION_COMMENTS = YES
            CLANG_WARN_EMPTY_BODY = YES
            CLANG_WARN_ENUM_CONVERSION = YES
            CLANG_WARN_INFINITE_RECURSION = YES
            CLANG_WARN_INT_CONVERSION = YES
            CLANG_WARN_NON_LITERAL_NULL_CONVERSION = YES
            CLANG_WARN_OBJC_IMPLICIT_RETAIN_SELF = YES
            CLANG_WARN_OBJC_LITERAL_CONVERSION = YES
            CLANG_WARN_OBJC_ROOT_CLASS = YES_ERROR
            CLANG_WARN_RANGE_LOOP_ANALYSIS = YES
            CLANG_WARN_STRICT_PROTOTYPES = YES
            CLANG_WARN_SUSPICIOUS_MOVE = YES
            CLANG_WARN_UNGUARDED_AVAILABILITY = YES_AGGRESSIVE
            CLANG_WARN_UNREACHABLE_CODE = YES
            CODE_SIGN_STYLE = Automatic
            COPY_PHASE_STRIP = NO
            ENABLE_STRICT_OBJC_MSGSEND = YES
            GCC_C_LANGUAGE_STANDARD = gnu11
            GCC_NO_COMMON_BLOCKS = YES
            GCC_WARN_64_TO_32_BIT_CONVERSION = YES
            GCC_WARN_ABOUT_RETURN_TYPE = YES_ERROR
            GCC_WARN_UNDECLARED_SELECTOR = YES
            GCC_WARN_UNINITIALIZED_AUTOS = YES_AGGRESSIVE
            GCC_WARN_UNUSED_FUNCTION = YES
            GCC_WARN_UNUSED_VARIABLE = YES
            LD_RUNPATH_SEARCH_PATHS = $(inherited) @executable_path/Frameworks @loader_path/Frameworks
            MTL_FAST_MATH = YES
            PRODUCT_NAME = $(TARGET_NAME)
            SDKROOT = appletvos
            SWIFT_VERSION = $(inherited)
            TARGETED_DEVICE_FAMILY = 3
            TVOS_DEPLOYMENT_TARGET = 12.0
            """
        )

        self[.debug].overrideWithXcodeBuildSettings(

            """
            DEBUG_INFORMATION_FORMAT = dwarf
            ENABLE_TESTABILITY = YES
            GCC_DYNAMIC_NO_PIC = NO
            GCC_OPTIMIZATION_LEVEL = 0
            GCC_PREPROCESSOR_DEFINITIONS = DEBUG=1 $(inherited)
            MTL_ENABLE_DEBUG_INFO = INCLUDE_SOURCE
            ONLY_ACTIVE_ARCH = YES
            SWIFT_ACTIVE_COMPILATION_CONDITIONS = DEBUG
            SWIFT_OPTIMIZATION_LEVEL = -Onone
            """
        )

        self[.release].overrideWithXcodeBuildSettings(

            """
            DEBUG_INFORMATION_FORMAT = dwarf-with-dsym
            ENABLE_NS_ASSERTIONS = NO
            MTL_ENABLE_DEBUG_INFO = NO
            SWIFT_COMPILATION_MODE = wholemodule
            SWIFT_OPTIMIZATION_LEVEL = -O
            VALIDATE_PRODUCT = YES
            """
        )
    }

    func tvOSAppUITests()
    {
        base.overrideWithXcodeBuildSettings(

            """
            ALWAYS_EMBED_SWIFT_STANDARD_LIBRARIES = YES
            ALWAYS_SEARCH_USER_PATHS = NO
            CLANG_ANALYZER_NONNULL = YES
            CLANG_ANALYZER_NUMBER_OBJECT_CONVERSION = YES_AGGRESSIVE
            CLANG_CXX_LANGUAGE_STANDARD = gnu++14
            CLANG_CXX_LIBRARY = libc++
            CLANG_ENABLE_MODULES = YES
            CLANG_ENABLE_OBJC_ARC = YES
            CLANG_ENABLE_OBJC_WEAK = YES
            CLANG_WARN__DUPLICATE_METHOD_MATCH = YES
            CLANG_WARN_BLOCK_CAPTURE_AUTORELEASING = YES
            CLANG_WARN_BOOL_CONVERSION = YES
            CLANG_WARN_COMMA = YES
            CLANG_WARN_CONSTANT_CONVERSION = YES
            CLANG_WARN_DEPRECATED_OBJC_IMPLEMENTATIONS = YES
            CLANG_WARN_DIRECT_OBJC_ISA_USAGE = YES_ERROR
            CLANG_WARN_DOCUMENTATION_COMMENTS = YES
            CLANG_WARN_EMPTY_BODY = YES
            CLANG_WARN_ENUM_CONVERSION = YES
            CLANG_WARN_INFINITE_RECURSION = YES
            CLANG_WARN_INT_CONVERSION = YES
            CLANG_WARN_NON_LITERAL_NULL_CONVERSION = YES
            CLANG_WARN_OBJC_IMPLICIT_RETAIN_SELF = YES
            CLANG_WARN_OBJC_LITERAL_CONVERSION = YES
            CLANG_WARN_OBJC_ROOT_CLASS = YES_ERROR
            CLANG_WARN_RANGE_LOOP_ANALYSIS = YES
            CLANG_WARN_STRICT_PROTOTYPES = YES
            CLANG_WARN_SUSPICIOUS_MOVE = YES
            CLANG_WARN_UNGUARDED_AVAILABILITY = YES_AGGRESSIVE
            CLANG_WARN_UNREACHABLE_CODE = YES
            CODE_SIGN_STYLE = Automatic
            COPY_PHASE_STRIP = NO
            ENABLE_STRICT_OBJC_MSGSEND = YES
            GCC_C_LANGUAGE_STANDARD = gnu11
            GCC_NO_COMMON_BLOCKS = YES
            GCC_WARN_64_TO_32_BIT_CONVERSION = YES
            GCC_WARN_ABOUT_RETURN_TYPE = YES_ERROR
            GCC_WARN_UNDECLARED_SELECTOR = YES
            GCC_WARN_UNINITIALIZED_AUTOS = YES_AGGRESSIVE
            GCC_WARN_UNUSED_FUNCTION = YES
            GCC_WARN_UNUSED_VARIABLE = YES
            LD_RUNPATH_SEARCH_PATHS = $(inherited) @executable_path/Frameworks @loader_path/Frameworks
            MTL_FAST_MATH = YES
            PRODUCT_NAME = $(TARGET_NAME)
            SDKROOT = appletvos
            SWIFT_VERSION = $(inherited)
            TARGETED_DEVICE_FAMILY = 3
            TVOS_DEPLOYMENT_TARGET = 12.0
            """
        )

        self[.debug].overrideWithXcodeBuildSettings(

            """
            DEBUG_INFORMATION_FORMAT = dwarf
            ENABLE_TESTABILITY = YES
            GCC_DYNAMIC_NO_PIC = NO
            GCC_OPTIMIZATION_LEVEL = 0
            GCC_PREPROCESSOR_DEFINITIONS = DEBUG=1 $(inherited)
            MTL_ENABLE_DEBUG_INFO = INCLUDE_SOURCE
            ONLY_ACTIVE_ARCH = YES
            SWIFT_ACTIVE_COMPILATION_CONDITIONS = DEBUG
            SWIFT_OPTIMIZATION_LEVEL = -Onone
            """
        )

        self[.release].overrideWithXcodeBuildSettings(

            """
            DEBUG_INFORMATION_FORMAT = dwarf-with-dsym
            ENABLE_NS_ASSERTIONS = NO
            MTL_ENABLE_DEBUG_INFO = NO
            SWIFT_COMPILATION_MODE = wholemodule
            SWIFT_OPTIMIZATION_LEVEL = -O
            VALIDATE_PRODUCT = YES
            """
        )
    }

    func watchOSApp()
    {
        base.overrideWithXcodeBuildSettings(

            """
            ALWAYS_EMBED_SWIFT_STANDARD_LIBRARIES = YES
            ALWAYS_SEARCH_USER_PATHS = NO
            ASSETCATALOG_COMPILER_APPICON_NAME = AppIcon
            CLANG_ANALYZER_NONNULL = YES
            CLANG_ANALYZER_NUMBER_OBJECT_CONVERSION = YES_AGGRESSIVE
            CLANG_CXX_LANGUAGE_STANDARD = gnu++14
            CLANG_CXX_LIBRARY = libc++
            CLANG_ENABLE_MODULES = YES
            CLANG_ENABLE_OBJC_ARC = YES
            CLANG_ENABLE_OBJC_WEAK = YES
            CLANG_WARN__DUPLICATE_METHOD_MATCH = YES
            CLANG_WARN_BLOCK_CAPTURE_AUTORELEASING = YES
            CLANG_WARN_BOOL_CONVERSION = YES
            CLANG_WARN_COMMA = YES
            CLANG_WARN_CONSTANT_CONVERSION = YES
            CLANG_WARN_DEPRECATED_OBJC_IMPLEMENTATIONS = YES
            CLANG_WARN_DIRECT_OBJC_ISA_USAGE = YES_ERROR
            CLANG_WARN_DOCUMENTATION_COMMENTS = YES
            CLANG_WARN_EMPTY_BODY = YES
            CLANG_WARN_ENUM_CONVERSION = YES
            CLANG_WARN_INFINITE_RECURSION = YES
            CLANG_WARN_INT_CONVERSION = YES
            CLANG_WARN_NON_LITERAL_NULL_CONVERSION = YES
            CLANG_WARN_OBJC_IMPLICIT_RETAIN_SELF = YES
            CLANG_WARN_OBJC_LITERAL_CONVERSION = YES
            CLANG_WARN_OBJC_ROOT_CLASS = YES_ERROR
            CLANG_WARN_RANGE_LOOP_ANALYSIS = YES
            CLANG_WARN_STRICT_PROTOTYPES = YES
            CLANG_WARN_SUSPICIOUS_MOVE = YES
            CLANG_WARN_UNGUARDED_AVAILABILITY = YES_AGGRESSIVE
            CLANG_WARN_UNREACHABLE_CODE = YES
            CODE_SIGN_IDENTITY = iPhone Developer
            CODE_SIGN_STYLE = Automatic
            COPY_PHASE_STRIP = NO
            ENABLE_STRICT_OBJC_MSGSEND = YES
            GCC_C_LANGUAGE_STANDARD = gnu11
            GCC_NO_COMMON_BLOCKS = YES
            GCC_WARN_64_TO_32_BIT_CONVERSION = YES
            GCC_WARN_ABOUT_RETURN_TYPE = YES_ERROR
            GCC_WARN_UNDECLARED_SELECTOR = YES
            GCC_WARN_UNINITIALIZED_AUTOS = YES_AGGRESSIVE
            GCC_WARN_UNUSED_FUNCTION = YES
            GCC_WARN_UNUSED_VARIABLE = YES
            IBSC_MODULE = watchOS_YYY_Extension
            MTL_FAST_MATH = YES
            PRODUCT_NAME = $(TARGET_NAME)
            SDKROOT = watchos
            SKIP_INSTALL = YES
            SWIFT_VERSION = $(inherited)
            TARGETED_DEVICE_FAMILY = 4
            WATCHOS_DEPLOYMENT_TARGET = 5.0
            """
        )

        self[.debug].overrideWithXcodeBuildSettings(

            """
            DEBUG_INFORMATION_FORMAT = dwarf
            ENABLE_TESTABILITY = YES
            GCC_DYNAMIC_NO_PIC = NO
            GCC_OPTIMIZATION_LEVEL = 0
            GCC_PREPROCESSOR_DEFINITIONS = DEBUG=1 $(inherited)
            MTL_ENABLE_DEBUG_INFO = INCLUDE_SOURCE
            ONLY_ACTIVE_ARCH = YES
            SWIFT_ACTIVE_COMPILATION_CONDITIONS = DEBUG
            SWIFT_OPTIMIZATION_LEVEL = -Onone
            """
        )

        self[.release].overrideWithXcodeBuildSettings(

            """
            DEBUG_INFORMATION_FORMAT = dwarf-with-dsym
            ENABLE_NS_ASSERTIONS = NO
            MTL_ENABLE_DEBUG_INFO = NO
            SWIFT_COMPILATION_MODE = wholemodule
            SWIFT_OPTIMIZATION_LEVEL = -O
            VALIDATE_PRODUCT = YES
            """
        )
    }

    func iOSFwk()
    {
        base.overrideWithXcodeBuildSettings(

            """
            ALWAYS_SEARCH_USER_PATHS = NO
            CLANG_ANALYZER_NONNULL = YES
            CLANG_ANALYZER_NUMBER_OBJECT_CONVERSION = YES_AGGRESSIVE
            CLANG_CXX_LANGUAGE_STANDARD = gnu++14
            CLANG_CXX_LIBRARY = libc++
            CLANG_ENABLE_MODULES = YES
            CLANG_ENABLE_OBJC_ARC = YES
            CLANG_ENABLE_OBJC_WEAK = YES
            CLANG_WARN__DUPLICATE_METHOD_MATCH = YES
            CLANG_WARN_BLOCK_CAPTURE_AUTORELEASING = YES
            CLANG_WARN_BOOL_CONVERSION = YES
            CLANG_WARN_COMMA = YES
            CLANG_WARN_CONSTANT_CONVERSION = YES
            CLANG_WARN_DEPRECATED_OBJC_IMPLEMENTATIONS = YES
            CLANG_WARN_DIRECT_OBJC_ISA_USAGE = YES_ERROR
            CLANG_WARN_DOCUMENTATION_COMMENTS = YES
            CLANG_WARN_EMPTY_BODY = YES
            CLANG_WARN_ENUM_CONVERSION = YES
            CLANG_WARN_INFINITE_RECURSION = YES
            CLANG_WARN_INT_CONVERSION = YES
            CLANG_WARN_NON_LITERAL_NULL_CONVERSION = YES
            CLANG_WARN_OBJC_IMPLICIT_RETAIN_SELF = YES
            CLANG_WARN_OBJC_LITERAL_CONVERSION = YES
            CLANG_WARN_OBJC_ROOT_CLASS = YES_ERROR
            CLANG_WARN_RANGE_LOOP_ANALYSIS = YES
            CLANG_WARN_STRICT_PROTOTYPES = YES
            CLANG_WARN_SUSPICIOUS_MOVE = YES
            CLANG_WARN_UNGUARDED_AVAILABILITY = YES_AGGRESSIVE
            CLANG_WARN_UNREACHABLE_CODE = YES
            CODE_SIGN_IDENTITY = iPhone Developer
            CODE_SIGN_STYLE = Automatic
            COPY_PHASE_STRIP = NO
            CURRENT_PROJECT_VERSION = \(Defaults.initialBuildNumber)
            DEFINES_MODULE = YES
            DYLIB_COMPATIBILITY_VERSION = 1
            DYLIB_CURRENT_VERSION = 1
            DYLIB_INSTALL_NAME_BASE = @rpath
            ENABLE_STRICT_OBJC_MSGSEND = YES
            GCC_C_LANGUAGE_STANDARD = gnu11
            GCC_NO_COMMON_BLOCKS = YES
            GCC_WARN_64_TO_32_BIT_CONVERSION = YES
            GCC_WARN_ABOUT_RETURN_TYPE = YES_ERROR
            GCC_WARN_UNDECLARED_SELECTOR = YES
            GCC_WARN_UNINITIALIZED_AUTOS = YES_AGGRESSIVE
            GCC_WARN_UNUSED_FUNCTION = YES
            GCC_WARN_UNUSED_VARIABLE = YES
            INSTALL_PATH = $(LOCAL_LIBRARY_DIR)/Frameworks
            IPHONEOS_DEPLOYMENT_TARGET = 12.0
            LD_RUNPATH_SEARCH_PATHS = $(inherited) @executable_path/Frameworks @loader_path/Frameworks
            MTL_FAST_MATH = YES
            SDKROOT = iphoneos
            SKIP_INSTALL = YES
            SWIFT_VERSION = $(inherited)
            TARGETED_DEVICE_FAMILY = 1,2
            VERSION_INFO_PREFIX =
            VERSIONING_SYSTEM = apple-generic
            """
        )

        self[.debug].overrideWithXcodeBuildSettings(

            """
            DEBUG_INFORMATION_FORMAT = dwarf
            ENABLE_TESTABILITY = YES
            GCC_DYNAMIC_NO_PIC = NO
            GCC_OPTIMIZATION_LEVEL = 0
            GCC_PREPROCESSOR_DEFINITIONS = DEBUG=1 $(inherited)
            MTL_ENABLE_DEBUG_INFO = INCLUDE_SOURCE
            ONLY_ACTIVE_ARCH = YES
            SWIFT_ACTIVE_COMPILATION_CONDITIONS = DEBUG
            SWIFT_OPTIMIZATION_LEVEL = -Onone
            """
        )

        self[.release].overrideWithXcodeBuildSettings(

            """
            DEBUG_INFORMATION_FORMAT = dwarf-with-dsym
            ENABLE_NS_ASSERTIONS = NO
            MTL_ENABLE_DEBUG_INFO = NO
            SWIFT_COMPILATION_MODE = wholemodule
            SWIFT_OPTIMIZATION_LEVEL = -O
            VALIDATE_PRODUCT = YES
            """
        )
    }

    func iOSFwkTests()
    {
        base.overrideWithXcodeBuildSettings(

            """
            ALWAYS_SEARCH_USER_PATHS = NO
            CLANG_ANALYZER_NONNULL = YES
            CLANG_ANALYZER_NUMBER_OBJECT_CONVERSION = YES_AGGRESSIVE
            CLANG_CXX_LANGUAGE_STANDARD = gnu++14
            CLANG_CXX_LIBRARY = libc++
            CLANG_ENABLE_MODULES = YES
            CLANG_ENABLE_OBJC_ARC = YES
            CLANG_ENABLE_OBJC_WEAK = YES
            CLANG_WARN__DUPLICATE_METHOD_MATCH = YES
            CLANG_WARN_BLOCK_CAPTURE_AUTORELEASING = YES
            CLANG_WARN_BOOL_CONVERSION = YES
            CLANG_WARN_COMMA = YES
            CLANG_WARN_CONSTANT_CONVERSION = YES
            CLANG_WARN_DEPRECATED_OBJC_IMPLEMENTATIONS = YES
            CLANG_WARN_DIRECT_OBJC_ISA_USAGE = YES_ERROR
            CLANG_WARN_DOCUMENTATION_COMMENTS = YES
            CLANG_WARN_EMPTY_BODY = YES
            CLANG_WARN_ENUM_CONVERSION = YES
            CLANG_WARN_INFINITE_RECURSION = YES
            CLANG_WARN_INT_CONVERSION = YES
            CLANG_WARN_NON_LITERAL_NULL_CONVERSION = YES
            CLANG_WARN_OBJC_IMPLICIT_RETAIN_SELF = YES
            CLANG_WARN_OBJC_LITERAL_CONVERSION = YES
            CLANG_WARN_OBJC_ROOT_CLASS = YES_ERROR
            CLANG_WARN_RANGE_LOOP_ANALYSIS = YES
            CLANG_WARN_STRICT_PROTOTYPES = YES
            CLANG_WARN_SUSPICIOUS_MOVE = YES
            CLANG_WARN_UNGUARDED_AVAILABILITY = YES_AGGRESSIVE
            CLANG_WARN_UNREACHABLE_CODE = YES
            CODE_SIGN_IDENTITY = iPhone Developer
            CODE_SIGN_STYLE = Automatic
            COPY_PHASE_STRIP = NO
            ENABLE_STRICT_OBJC_MSGSEND = YES
            GCC_C_LANGUAGE_STANDARD = gnu11
            GCC_NO_COMMON_BLOCKS = YES
            GCC_WARN_64_TO_32_BIT_CONVERSION = YES
            GCC_WARN_ABOUT_RETURN_TYPE = YES_ERROR
            GCC_WARN_UNDECLARED_SELECTOR = YES
            GCC_WARN_UNINITIALIZED_AUTOS = YES_AGGRESSIVE
            GCC_WARN_UNUSED_FUNCTION = YES
            GCC_WARN_UNUSED_VARIABLE = YES
            IPHONEOS_DEPLOYMENT_TARGET = 12.0
            LD_RUNPATH_SEARCH_PATHS = $(inherited) @executable_path/Frameworks @loader_path/Frameworks
            MTL_FAST_MATH = YES
            PRODUCT_NAME = $(TARGET_NAME)
            SDKROOT = iphoneos
            SWIFT_VERSION = $(inherited)
            TARGETED_DEVICE_FAMILY = 1,2
            """
        )

        self[.debug].overrideWithXcodeBuildSettings(

            """
            DEBUG_INFORMATION_FORMAT = dwarf
            ENABLE_TESTABILITY = YES
            GCC_DYNAMIC_NO_PIC = NO
            GCC_OPTIMIZATION_LEVEL = 0
            GCC_PREPROCESSOR_DEFINITIONS = DEBUG=1 $(inherited)
            MTL_ENABLE_DEBUG_INFO = INCLUDE_SOURCE
            ONLY_ACTIVE_ARCH = YES
            SWIFT_ACTIVE_COMPILATION_CONDITIONS = DEBUG
            SWIFT_OPTIMIZATION_LEVEL = -Onone
            """
        )

        self[.release].overrideWithXcodeBuildSettings(

            """
            DEBUG_INFORMATION_FORMAT = dwarf-with-dsym
            ENABLE_NS_ASSERTIONS = NO
            MTL_ENABLE_DEBUG_INFO = NO
            SWIFT_COMPILATION_MODE = wholemodule
            SWIFT_OPTIMIZATION_LEVEL = -O
            VALIDATE_PRODUCT = YES
            """
        )
    }

    func macOSFwk()
    {
        base.overrideWithXcodeBuildSettings(

            """
            ALWAYS_SEARCH_USER_PATHS = NO
            CLANG_ANALYZER_NONNULL = YES
            CLANG_ANALYZER_NUMBER_OBJECT_CONVERSION = YES_AGGRESSIVE
            CLANG_CXX_LANGUAGE_STANDARD = gnu++14
            CLANG_CXX_LIBRARY = libc++
            CLANG_ENABLE_MODULES = YES
            CLANG_ENABLE_OBJC_ARC = YES
            CLANG_ENABLE_OBJC_WEAK = YES
            CLANG_WARN__DUPLICATE_METHOD_MATCH = YES
            CLANG_WARN_BLOCK_CAPTURE_AUTORELEASING = YES
            CLANG_WARN_BOOL_CONVERSION = YES
            CLANG_WARN_COMMA = YES
            CLANG_WARN_CONSTANT_CONVERSION = YES
            CLANG_WARN_DEPRECATED_OBJC_IMPLEMENTATIONS = YES
            CLANG_WARN_DIRECT_OBJC_ISA_USAGE = YES_ERROR
            CLANG_WARN_DOCUMENTATION_COMMENTS = YES
            CLANG_WARN_EMPTY_BODY = YES
            CLANG_WARN_ENUM_CONVERSION = YES
            CLANG_WARN_INFINITE_RECURSION = YES
            CLANG_WARN_INT_CONVERSION = YES
            CLANG_WARN_NON_LITERAL_NULL_CONVERSION = YES
            CLANG_WARN_OBJC_IMPLICIT_RETAIN_SELF = YES
            CLANG_WARN_OBJC_LITERAL_CONVERSION = YES
            CLANG_WARN_OBJC_ROOT_CLASS = YES_ERROR
            CLANG_WARN_RANGE_LOOP_ANALYSIS = YES
            CLANG_WARN_STRICT_PROTOTYPES = YES
            CLANG_WARN_SUSPICIOUS_MOVE = YES
            CLANG_WARN_UNGUARDED_AVAILABILITY = YES_AGGRESSIVE
            CLANG_WARN_UNREACHABLE_CODE = YES
            CODE_SIGN_IDENTITY = Mac Developer
            CODE_SIGN_STYLE = Automatic
            COMBINE_HIDPI_IMAGES = YES
            COPY_PHASE_STRIP = NO
            CURRENT_PROJECT_VERSION = \(Defaults.initialBuildNumber)
            DEFINES_MODULE = YES
            DYLIB_COMPATIBILITY_VERSION = 1
            DYLIB_CURRENT_VERSION = 1
            DYLIB_INSTALL_NAME_BASE = @rpath
            ENABLE_STRICT_OBJC_MSGSEND = YES
            FRAMEWORK_VERSION = A
            GCC_C_LANGUAGE_STANDARD = gnu11
            GCC_NO_COMMON_BLOCKS = YES
            GCC_WARN_64_TO_32_BIT_CONVERSION = YES
            GCC_WARN_ABOUT_RETURN_TYPE = YES_ERROR
            GCC_WARN_UNDECLARED_SELECTOR = YES
            GCC_WARN_UNINITIALIZED_AUTOS = YES_AGGRESSIVE
            GCC_WARN_UNUSED_FUNCTION = YES
            GCC_WARN_UNUSED_VARIABLE = YES
            INSTALL_PATH = $(LOCAL_LIBRARY_DIR)/Frameworks
            LD_RUNPATH_SEARCH_PATHS = $(inherited) @executable_path/../Frameworks @loader_path/Frameworks
            MACOSX_DEPLOYMENT_TARGET = 10.13
            MTL_FAST_MATH = YES
            SDKROOT = macosx
            SKIP_INSTALL = YES
            SWIFT_VERSION = $(inherited)
            VERSION_INFO_PREFIX =
            VERSIONING_SYSTEM = apple-generic
            """
        )

        self[.debug].overrideWithXcodeBuildSettings(

            """
            DEBUG_INFORMATION_FORMAT = dwarf
            ENABLE_TESTABILITY = YES
            GCC_DYNAMIC_NO_PIC = NO
            GCC_OPTIMIZATION_LEVEL = 0
            GCC_PREPROCESSOR_DEFINITIONS = DEBUG=1 $(inherited)
            MTL_ENABLE_DEBUG_INFO = INCLUDE_SOURCE
            ONLY_ACTIVE_ARCH = YES
            SWIFT_ACTIVE_COMPILATION_CONDITIONS = DEBUG
            SWIFT_OPTIMIZATION_LEVEL = -Onone
            """
        )

        self[.release].overrideWithXcodeBuildSettings(

            """
            DEBUG_INFORMATION_FORMAT = dwarf-with-dsym
            ENABLE_NS_ASSERTIONS = NO
            MTL_ENABLE_DEBUG_INFO = NO
            SWIFT_COMPILATION_MODE = wholemodule
            SWIFT_OPTIMIZATION_LEVEL = -O
            """
        )
    }

    func macOSFwkTests()
    {
        base.overrideWithXcodeBuildSettings(

            """
            ALWAYS_SEARCH_USER_PATHS = NO
            CLANG_ANALYZER_NONNULL = YES
            CLANG_ANALYZER_NUMBER_OBJECT_CONVERSION = YES_AGGRESSIVE
            CLANG_CXX_LANGUAGE_STANDARD = gnu++14
            CLANG_CXX_LIBRARY = libc++
            CLANG_ENABLE_MODULES = YES
            CLANG_ENABLE_OBJC_ARC = YES
            CLANG_ENABLE_OBJC_WEAK = YES
            CLANG_WARN__DUPLICATE_METHOD_MATCH = YES
            CLANG_WARN_BLOCK_CAPTURE_AUTORELEASING = YES
            CLANG_WARN_BOOL_CONVERSION = YES
            CLANG_WARN_COMMA = YES
            CLANG_WARN_CONSTANT_CONVERSION = YES
            CLANG_WARN_DEPRECATED_OBJC_IMPLEMENTATIONS = YES
            CLANG_WARN_DIRECT_OBJC_ISA_USAGE = YES_ERROR
            CLANG_WARN_DOCUMENTATION_COMMENTS = YES
            CLANG_WARN_EMPTY_BODY = YES
            CLANG_WARN_ENUM_CONVERSION = YES
            CLANG_WARN_INFINITE_RECURSION = YES
            CLANG_WARN_INT_CONVERSION = YES
            CLANG_WARN_NON_LITERAL_NULL_CONVERSION = YES
            CLANG_WARN_OBJC_IMPLICIT_RETAIN_SELF = YES
            CLANG_WARN_OBJC_LITERAL_CONVERSION = YES
            CLANG_WARN_OBJC_ROOT_CLASS = YES_ERROR
            CLANG_WARN_RANGE_LOOP_ANALYSIS = YES
            CLANG_WARN_STRICT_PROTOTYPES = YES
            CLANG_WARN_SUSPICIOUS_MOVE = YES
            CLANG_WARN_UNGUARDED_AVAILABILITY = YES_AGGRESSIVE
            CLANG_WARN_UNREACHABLE_CODE = YES
            CODE_SIGN_IDENTITY = Mac Developer
            CODE_SIGN_STYLE = Automatic
            COMBINE_HIDPI_IMAGES = YES
            COPY_PHASE_STRIP = NO
            ENABLE_STRICT_OBJC_MSGSEND = YES
            GCC_C_LANGUAGE_STANDARD = gnu11
            GCC_NO_COMMON_BLOCKS = YES
            GCC_WARN_64_TO_32_BIT_CONVERSION = YES
            GCC_WARN_ABOUT_RETURN_TYPE = YES_ERROR
            GCC_WARN_UNDECLARED_SELECTOR = YES
            GCC_WARN_UNINITIALIZED_AUTOS = YES_AGGRESSIVE
            GCC_WARN_UNUSED_FUNCTION = YES
            GCC_WARN_UNUSED_VARIABLE = YES
            LD_RUNPATH_SEARCH_PATHS = $(inherited) @executable_path/../Frameworks @loader_path/../Frameworks
            MACOSX_DEPLOYMENT_TARGET = 10.13
            MTL_FAST_MATH = YES
            PRODUCT_NAME = $(TARGET_NAME)
            SDKROOT = macosx
            SWIFT_VERSION = $(inherited)
            """
        )

        self[.debug].overrideWithXcodeBuildSettings(

            """
            DEBUG_INFORMATION_FORMAT = dwarf
            ENABLE_TESTABILITY = YES
            GCC_DYNAMIC_NO_PIC = NO
            GCC_OPTIMIZATION_LEVEL = 0
            GCC_PREPROCESSOR_DEFINITIONS = DEBUG=1 $(inherited)
            MTL_ENABLE_DEBUG_INFO = INCLUDE_SOURCE
            ONLY_ACTIVE_ARCH = YES
            SWIFT_ACTIVE_COMPILATION_CONDITIONS = DEBUG
            SWIFT_OPTIMIZATION_LEVEL = -Onone
            """
        )

        self[.release].overrideWithXcodeBuildSettings(

            """
            DEBUG_INFORMATION_FORMAT = dwarf-with-dsym
            ENABLE_NS_ASSERTIONS = NO
            MTL_ENABLE_DEBUG_INFO = NO
            SWIFT_COMPILATION_MODE = wholemodule
            SWIFT_OPTIMIZATION_LEVEL = -O
            """
        )
    }

    func tvOSFwk()
    {
        base.overrideWithXcodeBuildSettings(

            """
            ALWAYS_SEARCH_USER_PATHS = NO
            CLANG_ANALYZER_NONNULL = YES
            CLANG_ANALYZER_NUMBER_OBJECT_CONVERSION = YES_AGGRESSIVE
            CLANG_CXX_LANGUAGE_STANDARD = gnu++14
            CLANG_CXX_LIBRARY = libc++
            CLANG_ENABLE_MODULES = YES
            CLANG_ENABLE_OBJC_ARC = YES
            CLANG_ENABLE_OBJC_WEAK = YES
            CLANG_WARN__DUPLICATE_METHOD_MATCH = YES
            CLANG_WARN_BLOCK_CAPTURE_AUTORELEASING = YES
            CLANG_WARN_BOOL_CONVERSION = YES
            CLANG_WARN_COMMA = YES
            CLANG_WARN_CONSTANT_CONVERSION = YES
            CLANG_WARN_DEPRECATED_OBJC_IMPLEMENTATIONS = YES
            CLANG_WARN_DIRECT_OBJC_ISA_USAGE = YES_ERROR
            CLANG_WARN_DOCUMENTATION_COMMENTS = YES
            CLANG_WARN_EMPTY_BODY = YES
            CLANG_WARN_ENUM_CONVERSION = YES
            CLANG_WARN_INFINITE_RECURSION = YES
            CLANG_WARN_INT_CONVERSION = YES
            CLANG_WARN_NON_LITERAL_NULL_CONVERSION = YES
            CLANG_WARN_OBJC_IMPLICIT_RETAIN_SELF = YES
            CLANG_WARN_OBJC_LITERAL_CONVERSION = YES
            CLANG_WARN_OBJC_ROOT_CLASS = YES_ERROR
            CLANG_WARN_RANGE_LOOP_ANALYSIS = YES
            CLANG_WARN_STRICT_PROTOTYPES = YES
            CLANG_WARN_SUSPICIOUS_MOVE = YES
            CLANG_WARN_UNGUARDED_AVAILABILITY = YES_AGGRESSIVE
            CLANG_WARN_UNREACHABLE_CODE = YES
            CODE_SIGN_IDENTITY =
            CODE_SIGN_STYLE = Automatic
            COPY_PHASE_STRIP = NO
            CURRENT_PROJECT_VERSION = \(Defaults.initialBuildNumber)
            DEFINES_MODULE = YES
            DYLIB_COMPATIBILITY_VERSION = 1
            DYLIB_CURRENT_VERSION = 1
            DYLIB_INSTALL_NAME_BASE = @rpath
            ENABLE_STRICT_OBJC_MSGSEND = YES
            GCC_C_LANGUAGE_STANDARD = gnu11
            GCC_NO_COMMON_BLOCKS = YES
            GCC_WARN_64_TO_32_BIT_CONVERSION = YES
            GCC_WARN_ABOUT_RETURN_TYPE = YES_ERROR
            GCC_WARN_UNDECLARED_SELECTOR = YES
            GCC_WARN_UNINITIALIZED_AUTOS = YES_AGGRESSIVE
            GCC_WARN_UNUSED_FUNCTION = YES
            GCC_WARN_UNUSED_VARIABLE = YES
            INSTALL_PATH = $(LOCAL_LIBRARY_DIR)/Frameworks
            LD_RUNPATH_SEARCH_PATHS = $(inherited) @executable_path/Frameworks @loader_path/Frameworks
            MTL_FAST_MATH = YES
            SDKROOT = appletvos
            SKIP_INSTALL = YES
            SWIFT_VERSION = $(inherited)
            TARGETED_DEVICE_FAMILY = 3
            TVOS_DEPLOYMENT_TARGET = 12.0
            VERSION_INFO_PREFIX =
            VERSIONING_SYSTEM = apple-generic
            """
        )

        self[.debug].overrideWithXcodeBuildSettings(

            """
            DEBUG_INFORMATION_FORMAT = dwarf
            ENABLE_TESTABILITY = YES
            GCC_DYNAMIC_NO_PIC = NO
            GCC_OPTIMIZATION_LEVEL = 0
            GCC_PREPROCESSOR_DEFINITIONS = DEBUG=1 $(inherited)
            MTL_ENABLE_DEBUG_INFO = INCLUDE_SOURCE
            ONLY_ACTIVE_ARCH = YES
            SWIFT_ACTIVE_COMPILATION_CONDITIONS = DEBUG
            SWIFT_OPTIMIZATION_LEVEL = -Onone
            """
        )

        self[.release].overrideWithXcodeBuildSettings(

            """
            DEBUG_INFORMATION_FORMAT = dwarf-with-dsym
            ENABLE_NS_ASSERTIONS = NO
            MTL_ENABLE_DEBUG_INFO = NO
            SWIFT_COMPILATION_MODE = wholemodule
            SWIFT_OPTIMIZATION_LEVEL = -O
            VALIDATE_PRODUCT = YES
            """
        )
    }

    func tvOSFwkTests()
    {
        base.overrideWithXcodeBuildSettings(

            """
            ALWAYS_SEARCH_USER_PATHS = NO
            CLANG_ANALYZER_NONNULL = YES
            CLANG_ANALYZER_NUMBER_OBJECT_CONVERSION = YES_AGGRESSIVE
            CLANG_CXX_LANGUAGE_STANDARD = gnu++14
            CLANG_CXX_LIBRARY = libc++
            CLANG_ENABLE_MODULES = YES
            CLANG_ENABLE_OBJC_ARC = YES
            CLANG_ENABLE_OBJC_WEAK = YES
            CLANG_WARN__DUPLICATE_METHOD_MATCH = YES
            CLANG_WARN_BLOCK_CAPTURE_AUTORELEASING = YES
            CLANG_WARN_BOOL_CONVERSION = YES
            CLANG_WARN_COMMA = YES
            CLANG_WARN_CONSTANT_CONVERSION = YES
            CLANG_WARN_DEPRECATED_OBJC_IMPLEMENTATIONS = YES
            CLANG_WARN_DIRECT_OBJC_ISA_USAGE = YES_ERROR
            CLANG_WARN_DOCUMENTATION_COMMENTS = YES
            CLANG_WARN_EMPTY_BODY = YES
            CLANG_WARN_ENUM_CONVERSION = YES
            CLANG_WARN_INFINITE_RECURSION = YES
            CLANG_WARN_INT_CONVERSION = YES
            CLANG_WARN_NON_LITERAL_NULL_CONVERSION = YES
            CLANG_WARN_OBJC_IMPLICIT_RETAIN_SELF = YES
            CLANG_WARN_OBJC_LITERAL_CONVERSION = YES
            CLANG_WARN_OBJC_ROOT_CLASS = YES_ERROR
            CLANG_WARN_RANGE_LOOP_ANALYSIS = YES
            CLANG_WARN_STRICT_PROTOTYPES = YES
            CLANG_WARN_SUSPICIOUS_MOVE = YES
            CLANG_WARN_UNGUARDED_AVAILABILITY = YES_AGGRESSIVE
            CLANG_WARN_UNREACHABLE_CODE = YES
            CODE_SIGN_STYLE = Automatic
            COPY_PHASE_STRIP = NO
            ENABLE_STRICT_OBJC_MSGSEND = YES
            GCC_C_LANGUAGE_STANDARD = gnu11
            GCC_NO_COMMON_BLOCKS = YES
            GCC_WARN_64_TO_32_BIT_CONVERSION = YES
            GCC_WARN_ABOUT_RETURN_TYPE = YES_ERROR
            GCC_WARN_UNDECLARED_SELECTOR = YES
            GCC_WARN_UNINITIALIZED_AUTOS = YES_AGGRESSIVE
            GCC_WARN_UNUSED_FUNCTION = YES
            GCC_WARN_UNUSED_VARIABLE = YES
            LD_RUNPATH_SEARCH_PATHS = $(inherited) @executable_path/Frameworks @loader_path/Frameworks
            MTL_FAST_MATH = YES
            PRODUCT_NAME = $(TARGET_NAME)
            SDKROOT = appletvos
            SWIFT_VERSION = $(inherited)
            TARGETED_DEVICE_FAMILY = 3
            TVOS_DEPLOYMENT_TARGET = 12.0
            """
        )

        self[.debug].overrideWithXcodeBuildSettings(

            """
            DEBUG_INFORMATION_FORMAT = dwarf
            ENABLE_TESTABILITY = YES
            GCC_DYNAMIC_NO_PIC = NO
            GCC_OPTIMIZATION_LEVEL = 0
            GCC_PREPROCESSOR_DEFINITIONS = DEBUG=1 $(inherited)
            MTL_ENABLE_DEBUG_INFO = INCLUDE_SOURCE
            ONLY_ACTIVE_ARCH = YES
            SWIFT_ACTIVE_COMPILATION_CONDITIONS = DEBUG
            SWIFT_OPTIMIZATION_LEVEL = -Onone
            """
        )

        self[.release].overrideWithXcodeBuildSettings(

            """
            DEBUG_INFORMATION_FORMAT = dwarf-with-dsym
            ENABLE_NS_ASSERTIONS = NO
            MTL_ENABLE_DEBUG_INFO = NO
            SWIFT_COMPILATION_MODE = wholemodule
            SWIFT_OPTIMIZATION_LEVEL = -O
            VALIDATE_PRODUCT = YES
            """
        )
    }

    func watchOSFwk()
    {
        base.overrideWithXcodeBuildSettings(

            """
            ALWAYS_SEARCH_USER_PATHS = NO
            APPLICATION_EXTENSION_API_ONLY = YES
            CLANG_ANALYZER_NONNULL = YES
            CLANG_ANALYZER_NUMBER_OBJECT_CONVERSION = YES_AGGRESSIVE
            CLANG_CXX_LANGUAGE_STANDARD = gnu++14
            CLANG_CXX_LIBRARY = libc++
            CLANG_ENABLE_MODULES = YES
            CLANG_ENABLE_OBJC_ARC = YES
            CLANG_ENABLE_OBJC_WEAK = YES
            CLANG_WARN__DUPLICATE_METHOD_MATCH = YES
            CLANG_WARN_BLOCK_CAPTURE_AUTORELEASING = YES
            CLANG_WARN_BOOL_CONVERSION = YES
            CLANG_WARN_COMMA = YES
            CLANG_WARN_CONSTANT_CONVERSION = YES
            CLANG_WARN_DEPRECATED_OBJC_IMPLEMENTATIONS = YES
            CLANG_WARN_DIRECT_OBJC_ISA_USAGE = YES_ERROR
            CLANG_WARN_DOCUMENTATION_COMMENTS = YES
            CLANG_WARN_EMPTY_BODY = YES
            CLANG_WARN_ENUM_CONVERSION = YES
            CLANG_WARN_INFINITE_RECURSION = YES
            CLANG_WARN_INT_CONVERSION = YES
            CLANG_WARN_NON_LITERAL_NULL_CONVERSION = YES
            CLANG_WARN_OBJC_IMPLICIT_RETAIN_SELF = YES
            CLANG_WARN_OBJC_LITERAL_CONVERSION = YES
            CLANG_WARN_OBJC_ROOT_CLASS = YES_ERROR
            CLANG_WARN_RANGE_LOOP_ANALYSIS = YES
            CLANG_WARN_STRICT_PROTOTYPES = YES
            CLANG_WARN_SUSPICIOUS_MOVE = YES
            CLANG_WARN_UNGUARDED_AVAILABILITY = YES_AGGRESSIVE
            CLANG_WARN_UNREACHABLE_CODE = YES
            CODE_SIGN_IDENTITY =
            CODE_SIGN_STYLE = Automatic
            COPY_PHASE_STRIP = NO
            CURRENT_PROJECT_VERSION = \(Defaults.initialBuildNumber)
            DEFINES_MODULE = YES
            DYLIB_COMPATIBILITY_VERSION = 1
            DYLIB_CURRENT_VERSION = 1
            DYLIB_INSTALL_NAME_BASE = @rpath
            ENABLE_STRICT_OBJC_MSGSEND = YES
            GCC_C_LANGUAGE_STANDARD = gnu11
            GCC_NO_COMMON_BLOCKS = YES
            GCC_WARN_64_TO_32_BIT_CONVERSION = YES
            GCC_WARN_ABOUT_RETURN_TYPE = YES_ERROR
            GCC_WARN_UNDECLARED_SELECTOR = YES
            GCC_WARN_UNINITIALIZED_AUTOS = YES_AGGRESSIVE
            GCC_WARN_UNUSED_FUNCTION = YES
            GCC_WARN_UNUSED_VARIABLE = YES
            INSTALL_PATH = $(LOCAL_LIBRARY_DIR)/Frameworks
            LD_RUNPATH_SEARCH_PATHS = $(inherited) @executable_path/Frameworks @loader_path/Frameworks
            MTL_FAST_MATH = YES
            SDKROOT = watchos
            SKIP_INSTALL = YES
            SWIFT_VERSION = $(inherited)
            TARGETED_DEVICE_FAMILY = 4
            VERSION_INFO_PREFIX =
            VERSIONING_SYSTEM = apple-generic
            WATCHOS_DEPLOYMENT_TARGET = 5.0
            """
        )

        self[.debug].overrideWithXcodeBuildSettings(

            """
            DEBUG_INFORMATION_FORMAT = dwarf
            ENABLE_TESTABILITY = YES
            GCC_DYNAMIC_NO_PIC = NO
            GCC_OPTIMIZATION_LEVEL = 0
            GCC_PREPROCESSOR_DEFINITIONS = DEBUG=1 $(inherited)
            MTL_ENABLE_DEBUG_INFO = INCLUDE_SOURCE
            ONLY_ACTIVE_ARCH = YES
            SWIFT_ACTIVE_COMPILATION_CONDITIONS = DEBUG
            SWIFT_OPTIMIZATION_LEVEL = -Onone
            """
        )

        self[.release].overrideWithXcodeBuildSettings(

            """
            DEBUG_INFORMATION_FORMAT = dwarf-with-dsym
            ENABLE_NS_ASSERTIONS = NO
            MTL_ENABLE_DEBUG_INFO = NO
            SWIFT_COMPILATION_MODE = wholemodule
            SWIFT_OPTIMIZATION_LEVEL = -O
            VALIDATE_PRODUCT = YES
            """
        )
    }
}

// MARK: - Content rendering

extension Xcode.Target.BuildSettings: TextFilePiece
{
    public
    func asIndentedText(
        with indentation: Indentation
        ) -> IndentedText
    {
        // NOTE: build settings inside a target follow similar format to
        // ones on project level, EXCEPT they are one level up, nested
        // directly under build configuration name, WITHOUT 'overrides'
        // intermediate key, see more at the URL below.
        // https://github.com/lyptt/struct/issues/77#issuecomment-287573381
        //
        // See also - build settings on PROJECT level docs:
        // https://github.com/lyptt/struct/wiki/Spec-format:-v2.0#overrides

        //---

        guard
            !base.isEmpty ||
            !overrides.isEmpty
        else
        {
            return []
        }

        //---

        let result: IndentedTextBuffer = .init(with: indentation)

        //---

        result <<< """
            configurations:
            """

        indentation.nest{

            result <<< Xcode.BuildConfiguration.allCases.map{

                renderSettings(for: $0, with: indentation)
            }
        }

        //---

        return result.content
    }

    private
    func renderSettings(
        for configuration: Xcode.BuildConfiguration,
        with indentation: Indentation
        ) -> IndentedText
    {
        let result: IndentedTextBuffer = .init(with: indentation)

        //---

        if
            let externalConfig = externalConfig[configuration]
        {
            // https://github.com/lyptt/struct/wiki/Spec-format:-v2.0#target-xcconfig-references

            result <<< """
                \(configuration): \(externalConfig)
                """
        }
        else
        {
            // NO explicit documentation, has similar format to project level
            // build settings, but does not require 'overrides' keyword, see related
            // discussion: https://github.com/lyptt/struct/issues/77#issuecomment-287573381

            let combinedSettings = base.overriding(with: self[configuration])

            result <<< combinedSettings.isEmpty.mapIf(false){ """
                \(configuration):
                """
            }

            indentation.nest{

                result <<< combinedSettings.map{ """
                    \($0.key): "\($0.value)"
                    """
                }
            }
        }

        //---

        return result.content
    }
}
