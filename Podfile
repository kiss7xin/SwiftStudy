# Uncomment the next line to define a global platform for your project
platform :ios, '12.0'

target 'SwiftStudy' do
  use_frameworks!

pod 'RxSwift'
pod 'RxCocoa'
#pod 'RxDataSources'
pod 'SnapKit'
pod 'SwifterSwift'
pod 'lottie-ios', '~> 3.2.3'
pod 'Popover'
pod 'AMPopTip', '~> 4.6.1'
pod 'RxGesture'

pod 'ProgressHUD'

post_install do |installer|
      installer.pods_project.targets.each do |target|
          if target.name == 'RxSwift'
              target.build_configurations.each do |config|
                  if config.name == 'Debug'
                      config.build_settings['OTHER_SWIFT_FLAGS'] ||= ['-D', 'TRACE_RESOURCES']
                  end
              end
          end
      end
  end

end
