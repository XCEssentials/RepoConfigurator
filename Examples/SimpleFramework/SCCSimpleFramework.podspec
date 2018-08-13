Pod::Spec.new do |s|

    s.name          = 'SCCSimpleFramework'
    s.summary       = 'A simple framework.'
    s.version       = '0.1.0'
    s.homepage      = 'https://SomeCoolCompany.github.io/SimpleFramework'

    s.source        = { :git => 'https://github.com/SomeCoolCompany/SimpleFramework.git', :tag => s.version }

    s.requires_arc  = true

    s.license       = { :type => 'MIT', :file => 'LICENSE' }

    s.authors = {
        'John Appleseed' => 'john@example.com'
    }

    s.swift_version = '4.2'

    s.cocoapods_version = '>= 0.36'

    # === iOS

    s.ios.deployment_target = '9.0'

    s.ios.source_files = 'Sources/SimpleFramework/**/*.swift'

end