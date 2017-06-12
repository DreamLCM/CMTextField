Pod::Spec.new do |s|
s.name             = 'CMTextField'
s.version          = '1.0.0'
s.summary          = 'Swift3的自定义 UITextField'


s.description      = <<-DESC
Swift3的自定义 UITextField,支持扩展
DESC

s.homepage         = 'https://github.com/DreamLCM/CMTextField'
s.license          = { :type => 'MIT', :file => 'LICENSE' }
s.author           = { 'LCM' => '212763791@qq.com' }
s.source           = { :git => 'https://github.com/DreamLCM/CMTextField.git', :tag => s.version.to_s }

s.ios.deployment_target = '9.0'

s.source_files = 'CMTextField/Class/*'

end


#验证命令：pod lib lint CMTextField.podspec --verbose
#提交命令：pod trunk push CMTextField.podspec
