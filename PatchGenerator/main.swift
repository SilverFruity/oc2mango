//
//  main.swift
//  PatchGenerator
//
//  Created by Jiang on 2020/9/1.
//  Copyright © 2020 SilverFruity. All rights reserved.
//

import Foundation
func recursiveSanFiles(path: String) -> [String]{
    var files = [String]()
    var isDir = ObjCBool.init(false)
    if (FileManager.default.fileExists(atPath: path, isDirectory: &isDir)){
        if isDir.boolValue || path.hasSuffix("bundle") {
            if let pathes = try? FileManager.default.subpathsOfDirectory(atPath: path) {
                for subfilename in pathes{
                    // 忽略隐藏文件
                    if subfilename.hasPrefix(".") {
                        continue
                    }
                    let filepath = path + "/" + subfilename
                    if subfilename.hasSuffix("bundle") {
                        files.append(contentsOf: recursiveSanFiles(path: filepath))
                    }else{
                        files.append(contentsOf: recursiveSanFiles(path: filepath))
                    }
                }
            }
        }else{
            files.append(path);
        }
    }
    return files
}
enum PatchType: String{
    case json = "json"
    case binary = "binary"
}
enum Options: String{
    case files = "-files"
    case refs = "-refs"
    case output = "-output"
    case type = "-type"
    case h = "-h"
    case help = "-help"
    case osVersion = "-osVersion"
    case appVersion = "-appVersion"
}
class CheckArgs{
    var inputFilePaths = [String]()
    var refrencePaths = [String]()
    var osVersion = "*"
    var appVersion = "*"
    var output = ""
    var type: PatchType = .binary
    var isHelp = false
    init(args:[String]) {
        var curOption: Options? = .files
        for arg in args{
            if arg.hasPrefix("-") {
                curOption = Options.init(rawValue: arg)
                if curOption == .help || curOption == .h{
                    self.isHelp = true
                    self.showHelp()
                }
            }
            switch curOption {
            case .files:
                self.inputFilePaths.append(arg)
                break
            case .refs:
                self.refrencePaths.append(arg)
                break
            case .output:
                self.output = arg
            case .type:
                if let type = PatchType.init(rawValue: arg){
                    self.type = type
                }
                break
            case .appVersion:
                self.appVersion = arg
                break
            case .osVersion:
                self.osVersion = arg
                print("Not Support Argument: \(osVersion)")
                break
            default:
                break
            }
        }
    }
    func showHelp(){
        print(
        """
        PatchGenerator: 1.1.0

        required:
        -files: Objective-C source files.
        -refs: same as header files, include C function declare, struct, enum, inline function etc..
        -output: output patch file path.
        optional:
        -type: json or binary. default is binary.
        -osVersion: ORPatchFile 1.1.0 Not Support
        -appVersion: patch for application version

        For example:

        1. Binary Patch
        ./PatchGenerator -files /user/mac/filesDir -refs /user/mac/headersDir -output /usr/mac/binarypatch

        2. Json Patch
        ./PatchGenerator -type json -files /user/mac/filesDir -refs /user/mac/headersDir -output /usr/mac/jsonpatch

        """)
    }
}
func main(){
    let result = CheckArgs.init(args: Array.init(CommandLine.arguments[1...]))
    if result.isHelp {
        return
    }
    var inputSourceFiles = [String]()
    var inputRefrenceFiles = [String]()
    for path in result.inputFilePaths{
        inputSourceFiles.append(contentsOf: recursiveSanFiles(path: path))
    }
    for path in result.refrencePaths{
        inputRefrenceFiles.append(contentsOf: recursiveSanFiles(path: path))
    }
    let parser = Parser()
    print("References:\(inputRefrenceFiles.reduce("   ", { $0 + "\n   " + $1}))")
    let refsNodes = NSMutableArray.init()
    var sourceFiles = [CodeSource]()
    
    // for refs:
    for path in inputRefrenceFiles{
        let source = CodeSource(filePath: path)
        sourceFiles.append(source)
        refsNodes.addObjects(from: parser.parseCodeSource(source).nodes as! [Any])
    }
    print("InputFiles:\(inputSourceFiles.reduce("   ", { $0 + "\n   " + $1}))")
    let inputAst = AST.init()
    for path in inputSourceFiles{
        let source = CodeSource(filePath: path);
        sourceFiles.append(source)
        inputAst.merge(parser.parseCodeSource(source).nodes as! [Any])
    }
    let nodes = NSMutableArray.init()
    nodes.addObjects(from: refsNodes as! [Any])
    nodes.addObjects(from: inputAst.nodes as! [Any])
    let patchFile = ORPatchFile.init(nodes: nodes as! [Any])
    patchFile.appVersion = result.appVersion
    switch result.type {
    case .binary:
        let dst = patchFile.dump(asBinaryPatch: result.output)
        print("Save Binary File: \(dst)")
        break
    case .json:
        let dst = patchFile.dump(asJsonPatch: result.output)
        print("Save Json File: \(dst)")
        break
    }

    for source in sourceFiles{
        if let error = source.error {
            exit(-1);
        }
    }
    
}
main()


