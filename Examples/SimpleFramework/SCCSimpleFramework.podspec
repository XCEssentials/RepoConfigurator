Pod::Spec.new do |s|

    s.name          = 'SCCSimpleFramework'
    s.summary       = 'A simple framework.'
    s.version       = '0.1.0'
    s.homepage      = 'https://SomeCoolCompany.github.io/SimpleFramework'

    s.source        = { :git => 'https://github.com/SomeCoolCompany/SimpleFramework.git', :tag => s.version }

    s.requires_arc  = true

    s.license       = { :type => 'MIT', :file => 'LICENSE' }
    s.author        = { 'John Appleseed' => 'john@example.com' }

    s.swift_version = '4.2'

    s.ios.deployment_target = '9.0'

    s.source_files = 'Sources/**/*.swift'

end