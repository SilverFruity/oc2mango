import os
import re
import json
import hashlib
if __name__ == "__main__":
    current_path = os.path.abspath(__file__)
    father_path = os.path.abspath(os.path.dirname(current_path) + os.path.sep + ".")
    with open(father_path + "/RunnerClasses.h") as file:
        content = file.read()
    pattern = re.compile(r'@interface .*:[.\n\s\S]*?@end',re.M)
    results = pattern.findall(content)
    forUnitTest = False
    encryptData = {}
    decryptData = {}
    for (classIndex, classContent) in enumerate(results):
        className = re.search(r'@interface[ ]*(.*?):', classContent).group(1)
        pattern = re.compile(r'@property[.\s\S]*?([A-Za-z_$][A-Za-z_$0-9]*);',re.M)
        fieldNames = pattern.findall(classContent)
        pattern = re.compile(r'@property[ ]*\((.*)?\)[.\s\S]*?;')
        properties = pattern.findall(classContent)
        superClassName = re.search(r'@interface[.\s\S]*?:[ ]*(.*)', classContent).group(1)
        if superClassName != 'NSObject':
            if forUnitTest or superClassName != 'ORNode':
                fieldNames += encryptData[superClassName]["f"]
        encryptPropertyMap = {}
        decryptPropertyMap = {}
        encryptProperties = []
        decryptProperties = []
        for (i, name) in enumerate(fieldNames):
            filedProperty: str = properties[i] if i < len(properties) else ''
            if 'readonly' in filedProperty:
                continue
            key = str(i)
            encryptProperties.append(name)
            decryptProperties.append(key)
            encryptPropertyMap[name] = key
            decryptPropertyMap[key] = name

        nodeName = str(classIndex)
        # encryptData[className] = {'fieldEncryptMap': encryptPropertyMap, 'nodeName': nodeName, 'fieldNames': encryptProperties}
        # decryptData[nodeName] = {'fieldDecryptMap': decryptPropertyMap, 'className': className, 'fieldNames': decryptProperties}
        encryptData[className] = {'m': encryptPropertyMap, 'n': nodeName, 'f': encryptProperties}
        decryptData[nodeName] = {'m': decryptPropertyMap, 'c': className, 'f': decryptProperties}
    

encrypt_header = "static NSString * jsonEncryptString = @"
encrypt_end = """;
"""
encryptString = encrypt_header + json.dumps(json.dumps(encryptData)) + encrypt_end
    

decrypt_header = "static NSString * jsonDecryptString = @"
decrypt_end = """;
"""
decryptString = decrypt_header + json.dumps(json.dumps(decryptData)) + decrypt_end
    
#.h文件中的内容
classSecretKey = """
#import <Foundation/Foundation.h>

"""
    
classKey = classSecretKey + encryptString + decryptString

with open(father_path + "/ClassSecretKeyMap.h", 'w+') as classSecretKeyFile:
     classSecretKeyFile.write(classKey)
     classSecretKeyFile.close()
print("success !!!")
