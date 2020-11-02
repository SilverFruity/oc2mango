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
    case encryptMap = "-encryptMap"
    case h = "-h"
    case help = "-help"
}
class CheckArgs{
    var inputFilePaths = [String]()
    var refrencePaths = [String]()
    var output = ""
    var type: PatchType = .binary
    var encryptMap = ""
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
            case .encryptMap:
                self.encryptMap = arg
                break
            default:
                break
            }
        }
    }
    func showHelp(){
        print(
        """

        required:
        -files: Objective-C source files.
        -refs: same as header files, include C function declare, struct, enum, inline function etc..
        -output: output patch file path.

        optional:
        -type: json or binary. default is binary.
        -encryptMap: only for json patch. if use json patch, it must be exsited.

        For example:

        1. Binary Patch
        ./PatchGenerator -files /user/mac/filesDir -refs /user/mac/headersDir -output /usr/mac/binarypatch

        2. Json Patch
        ./PatchGenerator -type json -encryptMap /user/mac/ClassEncryptMap.json -files /user/mac/filesDir -refs /user/mac/headersDir -output /usr/mac/jsonpatch

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
    
    var input = ""
    print("InputFiles:\n\(inputSourceFiles)")
    for path in inputSourceFiles{
        let data = NSData.init(contentsOfFile: path)! as Data
        input += String.init(data: data, encoding: .utf8)!
    }
    
    var reference = ""
    print("References:\n\(inputRefrenceFiles)")
    for path in inputRefrenceFiles{
        let data = NSData.init(contentsOfFile: path)! as Data
        reference += String.init(data: data, encoding: .utf8)!
    }
    
    let parser = Parser()
    
    // for refs:
    let refNodes = parser.parseSource(reference).nodes as! [Any]
    let inputNodes = parser.parseSource(input).nodes as! [Any]
    let patchFile = ORPatchFile.init(nodes: refNodes + inputNodes)
    switch result.type {
    case .binary:
        patchFile.dump(asBinaryPatch: result.output)
        break
    case .json:
        if result.encryptMap.count == 0{
            print("必须传入encryptMap文件!")
        }
        patchFile.dump(asJsonPatch: result.output, encrptMapPath: result.encryptMap)
        break
    }
    
}
main()


