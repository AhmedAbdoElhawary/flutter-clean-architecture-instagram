#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#
Pod::Spec.new do |s|
  s.name             = 'blurhash'
  s.version          = '0.1.2'
  s.summary          = 'Flutter plugin for BlurHash.'
  s.description      = <<-DESC
Flutter plugin for BlurHash.
                       DESC
  s.homepage         = 'https://github.com/Raincal/blurhash'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Raincal' => 'cyj94228@gmail.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.public_header_files = 'Classes/**/*.h'
  s.dependency 'Flutter'

  s.ios.deployment_target = '9.0'
end

