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
                for subpath in pathes{
                    if path.hasSuffix("bundle") {
                        files.append(contentsOf: recursiveSanFiles(path: path + "/" + subpath))
                    }else{
                        files.append(contentsOf: recursiveSanFiles(path: subpath))
                    }
                    
                }
            }
        }else{
            files.append(path);
        }
    }
    return files
}
class CheckArgs{
    var inputFiles = [String]()
    var refrences = [String]()
    var output = ""
    
    var isInputFiels = false
    var isReferences = false
    var isOutput = false
    init(args:[String]) {
        for arg in args {
             switch arg {
             case "-files":
                 isInputFiels = true
                 isReferences = false
                 isOutput = false
                 continue
             case "-refs":
                 isInputFiels = false
                 isReferences = true
                 isOutput = false
                 continue
             case "-output":
                 isInputFiels = false
                 isReferences = false
                 isOutput = true
                 continue
             default:
                 break
             }
             if isInputFiels {
                 inputFiles.append(contentsOf: recursiveSanFiles(path: arg))
             }else if(isReferences){
                 refrences.append(contentsOf: recursiveSanFiles(path: arg))
             }else if (isOutput){
                 output = arg
             }
         }
    }
}
func main(){
    let result = CheckArgs.init(args: Array.init(CommandLine.arguments[1...]))
    var input = ""
    print("InputFiles:\n\(result.inputFiles)")
    for path in result.inputFiles{
        let data = NSData.init(contentsOfFile: path)! as Data
        input += String.init(data: data, encoding: .utf8)!
    }
    var reference = ""
    print("References:\n\(result.refrences)")
    for path in result.refrences{
        let data = NSData.init(contentsOfFile: path)! as Data
        reference += String.init(data: data, encoding: .utf8)!
    }
    
    let parser = Parser()
    
    // for refs:
    let refNodes = parser.parseSource(reference).nodes as! [Any]
    let inputNodes = parser.parseSource(input).nodes as! [Any]
    
    let patchFile = ORPatchFile.init(nodes: refNodes + inputNodes)
    patchFile.dump(asBinaryPatch: result.output)
}
main()


