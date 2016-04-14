platform :ios, '9.0'
use_frameworks!

target 'waka' do
    pod 'Chronos-Swift'
    pod 'AudioKit', '~> 2.3'
    pod 'TuningFork', '~> 0.1.1'
    pod 'PermissionScope', '~> 1.0.2'
end

target 'wakaTests' do
    pod 'Chronos-Swift'
    pod 'AudioKit', '~> 2.3'
    pod 'TuningFork', '~> 0.1.1'
    pod 'PermissionScope', '~> 1.0.2'
end

target 'wakaUITests' do
    pod 'Chronos-Swift'
    pod 'AudioKit', '~> 2.3'
    pod 'TuningFork', '~> 0.1.1'
    pod 'PermissionScope', '~> 1.0.2'
end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['ENABLE_BITCODE'] = 'NO'
        end
    end
end

