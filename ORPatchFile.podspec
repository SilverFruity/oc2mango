Pod::Spec.new do |s|
    s.name         = "ORPatchFile"
    s.version      = "2.0"
    s.summary      = "ORPatchFile"
    s.description  = <<-DESC
    ORPatchFile is a framework that serialize and deserialize the abstract syntax tree of oc2mangoLib.
    DESC
    s.homepage     = "https://github.com/SilverFruity/oc2mango"
    s.license      = "MIT"
    s.author             = { "SilverFruity" => "15328044115@163.com" }
    s.ios.deployment_target = "8.0"
    s.source       = { :git => "https://github.com/SilverFruity/oc2mango.git", :tag => "#{s.version}" }
    s.source_files  = "oc2mangoLib/PatchFile/*.{h,m}","oc2mangoLib/RunnerClasses.h","oc2mangoLib/RunnerClasses.m"
    s.resource_bundles = {
        'ORPatchFile' => ['oc2mangoLib/ClassDecryptMap.json', 'oc2mangoLib/ClassEncryptMap.json']
    }
    end
    
    