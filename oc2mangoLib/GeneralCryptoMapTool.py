
import os
import re
import json
if __name__ == "__main__":
    current_path = os.path.abspath(__file__)
    father_path = os.path.abspath(os.path.dirname(current_path) + os.path.sep + ".")
    with open(father_path + "/RunnerClasses.h") as file:
        content = file.read()
    pattern = re.compile(r'@interface .*:[.\n\s\S]*?@end',re.M)
    results = pattern.findall(content)
    encryptData = {}
    decryptData = {}
    for classContent in  results:
        className = re.search(r'@interface[ ]*(.*?):', classContent).group(1)
        pattern = re.compile(r'@property[.\s\S]*?([A-Za-z_$][A-Za-z_$0-9]*);',re.M)
        properties = pattern.findall(classContent)
        encryptPropertyMap = {}
        decryptPropertyMap = {}
        encryptProperties = []
        decryptProperties = []
        for (i, name) in enumerate(properties):
            key = str(i)
            encryptProperties.append(name)
            decryptProperties.append(key)
            encryptPropertyMap[name] = key
            decryptPropertyMap[key] = name

        nodeName = className
        encryptData[className] = {'fieldEncryptMap': encryptPropertyMap, 'nodeName': nodeName, 'fieldNames': encryptProperties}
        decryptData[nodeName] = {'fieldDecryptMap': decryptPropertyMap, 'className': className, 'fieldNames': decryptProperties}


    with open(father_path + "/ClassEncryptMap.json", 'w+') as encryptFile:
        json.dump(encryptData, encryptFile)

    with open(father_path + "/ClassDecryptMap.json", 'w+') as decryptFile:
        json.dump(decryptData, decryptFile)
    print("success !!!")
