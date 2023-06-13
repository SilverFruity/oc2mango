Pod::Spec.new do |s|
    s.name         = "ORPatchFile"
    s.version      = "1.2.3"
    s.summary      = "ORPatchFile"
    s.description  = <<-DESC
    ORPatchFile is a framework that serialize and deserialize the abstract syntax tree of oc2mangoLib.
    DESC
    s.homepage     = "https://github.com/SilverFruity/oc2mango"
    s.license      = "MIT"
    s.author             = { "SilverFruity" => "15328044115@163.com" }
    s.ios.deployment_target = "9.0"
    s.source       = { :git => "https://github.com/SilverFruity/oc2mango.git", :tag => "#{s.version}" }
    s.source_files  = "oc2mangoLib/PatchFile/*.{h,m}"
    end
    
    