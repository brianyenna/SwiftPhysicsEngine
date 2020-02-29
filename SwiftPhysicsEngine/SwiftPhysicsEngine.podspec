#
#  Be sure to run `pod spec lint SwiftPhysicsEngine.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see https://guidespec.cocoapodspec.org/syntax/podspec.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |spec|

    # 1
    spec.platform = :ios
    spec.ios.deployment_target = '12.0'
    spec.name = "SwiftPhysicsEngine"
    spec.summary = "A simple Physics Engine implemented in Swift."
    spec.requires_arc = true

    # 2
    spec.version = "0.1.2"

    # 3
    spec.license = { :type => "MIT", :file => "LICENSE" }

    # 4 - Replace with your name and e-mail address
    spec.author = { "Brian Yen" => "brianyen.na@gmail.com" }

    # 5 - Replace this URL with your own GitHub page's URL (from the address bar)
    spec.homepage = "https://github.com/brianyenna/SwiftPhysicsEngine"

    # 6 - Replace this URL with your own Git URL from "Quick Setup"
    spec.source = { :git => "https://github.com/brianyenna/SwiftPhysicsEngine.git",
                 :tag => "#{spec.version}" }

    # 7
    spec.framework = "UIKit"
    # spec.dependency 'Alamofire', '~> 4.7'
    # spec.dependency 'MBProgressHUD', '~> 1.1.0'

    # 8
    # spec.source_files = "SwiftPhysicsEngine/**/*.{swift}"
    spec.source_files = "SwiftPhysicsEngine/SwiftPhysicsEngine/*.{swift}"

    # 9
    # spec.resources = "SwiftPhysicsEngine/**/*.{png,jpeg,jpg,storyboard,xib,xcassets}"

    # 10
    spec.swift_version = "4.2"
end
