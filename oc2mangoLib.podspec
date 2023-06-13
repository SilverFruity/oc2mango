Pod::Spec.new do |s|
s.name         = "oc2mangoLib"
s.version      = "1.2.3"
s.summary      = "oc2mangoLib"
s.description  = <<-DESC
oc2mangoLib is a framework that parse Objective-C code into abstract syntax tree.
DESC
s.homepage     = "https://github.com/SilverFruity/oc2mango"
s.license      = "MIT"
s.author             = { "SilverFruity" => "15328044115@163.com" }
s.ios.deployment_target = "9.0"
s.source       = { :git => "https://github.com/SilverFruity/oc2mango.git", :tag => "#{s.version}" }
s.pod_target_xcconfig = { 'GCC_INPUT_FILETYPE' => 'sourcecode.c.objc' }
s.source_files  = "oc2mangoLib/*.{h,m,c,y,l}", "oc2mangoLib/Builders/*.{h,m,c,y,l}"
s.dependency "ORPatchFile", "1.2.3"
end

