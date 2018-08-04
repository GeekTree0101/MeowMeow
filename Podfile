use_frameworks!

target 'MeuwMeuw' do
pod 'Texture'
pod 'RxSwift'
pod 'RxCocoa'
pod 'RxAlamofire'
pod 'RxCocoa-Texture', :git => 'https://github.com/GeekTree0101/RxCocoa-Texture.git', :branch => 'Texture-2.7'
pod 'RxOptional'
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['CONFIGURATION_BUILD_DIR'] = '$PODS_CONFIGURATION_BUILD_DIR'
    end
  end
end
