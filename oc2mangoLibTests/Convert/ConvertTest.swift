//
//  ConvertTest.swift
//  oc2mangoLibTests
//
//  Created by Jiang on 2019/5/18.
//  Copyright © 2019年 SilverFruity. All rights reserved.
//

import XCTest

class ConvertTest: XCTestCase {
    let parser = Parser()
    let convert = Convert()
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        
    }

    func testTypeSpecail(){
        let source =
"""
int x;
NSObject *x;
BOOL x;
"""
        let ast = parser.parseSource(source)
        XCTAssert(parser.isSuccess())
        let result = convert.convert(ast.globalStatements[0] as Any)
        let result1 = convert.convert(ast.globalStatements[1] as Any)
        let result2 = convert.convert(ast.globalStatements[2] as Any)
        XCTAssert(parser.error == nil)
        XCTAssert(result == "int x;",result)
        XCTAssert(result1 == "NSObject *x;",result1)
        XCTAssert(result2 == "BOOL x;",result2)
        
    }
    
    func testAssignExpressoin(){
        let source =
"""
int x = 0, b = 0;
NSNumber *a = @(3);
NSNumber *a = @(self.object.intValue);
NSNumber *a = @([self.object intValue]);
"""
        let ast = parser.parseSource(source)
        XCTAssert(parser.isSuccess())
        
        let result = convert.convert(ast.globalStatements[0] as Any)
        let result1 = convert.convert(ast.globalStatements[1] as Any)
        let result2 = convert.convert(ast.globalStatements[2] as Any)
        let result3 = convert.convert(ast.globalStatements[3] as Any)
        let result4 = convert.convert(ast.globalStatements[4] as Any)

        XCTAssert(result == "int x = 0;",result)
        XCTAssert(result1 == "int b = 0;",result1)
        XCTAssert(result2 == "NSNumber *a = @(3);",result2)
        XCTAssert(result3 == "NSNumber *a = @(self.object.intValue);",result3)
        XCTAssert(result4 == "NSNumber *a = @(self.object.intValue());",result4)
        
    }
    
    func testConvertMethodCall(){
        let source =
"""
[NSObject new].x;
x.get;
[self request:request plugin:plugin completion:completion];
self.block(value,[NSObject new].x);
[self request:^(NSString *name, NSURL *URL){
    [NSObject new];
}];
@"123";
"123";
@protocol(NSObject);
"""
        let ast = parser.parseSource(source)
        XCTAssert(parser.isSuccess())
        let result1 = convert.convert(ast.globalStatements[0] as Any)
        let result2 = convert.convert(ast.globalStatements[1] as Any)
        let result3 = convert.convert(ast.globalStatements[2] as Any)
        let result4 = convert.convert(ast.globalStatements[3] as Any)
        let result5 = convert.convert(ast.globalStatements[4] as Any)
        let result6 = convert.convert(ast.globalStatements[5] as Any)
        let result7 = convert.convert(ast.globalStatements[6] as Any)
        let result8 = convert.convert(ast.globalStatements[7] as Any)
        
        XCTAssert(result1 == "NSObject.new().x;",result1)
        XCTAssert(result2 == "x.get;",result2)
        XCTAssert(result3 == "self.request:plugin:completion:(request,plugin,completion);",result3)
        XCTAssert(result4 == "self.block()(value,NSObject.new().x);",result4)
        XCTAssert(result5 ==
            """
            self.request:(^void (NSString *name,NSURL *URL){
                NSObject.new();
            });
            ""","\n"+result5)
        XCTAssert(result6 == "@\"123\";",result6)
        XCTAssert(result7 == "\"123\";",result7)
        XCTAssert(result8 == "@protocol(NSObject);",result8)
        
    }
    
    func testCollectionValue(){
        let source =
"""
@[self.x,[NSObject new]];
@{@"key":@"value",@"key1":@"value1"};
a[@"key"];
b[0];
"""
        let ast = parser.parseSource(source)
        XCTAssert(parser.isSuccess())
        let result1 = convert.convert(ast.globalStatements[0] as Any)
        let result2 = convert.convert(ast.globalStatements[1] as Any)
        let result3 = convert.convert(ast.globalStatements[2] as Any)
        let result4 = convert.convert(ast.globalStatements[3] as Any)
        XCTAssert(result1 == "@[self.x,NSObject.new()];",result1)
        XCTAssert(result2 ==
            """
            @{@"key":@"value",@"key1":@"value1"};
            """)
        XCTAssert(result3 ==
            """
            a[@"key"];
            """)
        XCTAssert(result4 ==
            """
            b[0];
            """)
        
    }
    
    func testConvertCalculateExp(){
        let source =
"""
x + 1;
x + b + 1;
x++;
++x;
!x;
x == nil ? 1 : 2;
x?:y;
x||y;
x&&y;
"""
        let ast = parser.parseSource(source)
        XCTAssert(parser.isSuccess())
        let result1 = convert.convert(ast.globalStatements[0] as Any)
        let result2 = convert.convert(ast.globalStatements[1] as Any)
        let result3 = convert.convert(ast.globalStatements[2] as Any)
        let result4 = convert.convert(ast.globalStatements[3] as Any)
        let result5 = convert.convert(ast.globalStatements[4] as Any)
        let result6 = convert.convert(ast.globalStatements[5] as Any)
        let result7 = convert.convert(ast.globalStatements[6] as Any)
        let result8 = convert.convert(ast.globalStatements[7] as Any)
        let result9 = convert.convert(ast.globalStatements[8] as Any)
        XCTAssert(result1 == "x + 1;",result1);
        XCTAssert(result2 == "x + b + 1;",result2);
        XCTAssert(result3 == "x++;",result3);
        XCTAssert(result4 == "++x;",result4);
        XCTAssert(result5 == "!x;",result5);
        XCTAssert(result6 == "x == nil ? 1 : 2;",result6);
        XCTAssert(result7 == "x ?: y;",result7);
        XCTAssert(result8 == "x || y;",result8);
        XCTAssert(result9 == "x && y;",result9);
    }
    
    func testConvertStatement(){
        let source =
"""
if([x isSuccess] == 1){

}else if (!value){

}else{

}

do{

}while(x > 0)

switch(x){
    case 0:
        break;
    case 1:
        break;
    default:
        break;
}
for (int x = 0; x < 10; x++){

}
for (UIView *view in subviews){

}
while(x != nil){
}
return self.x;
"""
        let ast = parser.parseSource(source)
        XCTAssert(parser.isSuccess())
        let result1 = convert.convert(ast.globalStatements[0] as Any)
        let result2 = convert.convert(ast.globalStatements[1] as Any)
        let result3 = convert.convert(ast.globalStatements[2] as Any)
        let result4 = convert.convert(ast.globalStatements[3] as Any)
        let result5 = convert.convert(ast.globalStatements[4] as Any)
        let result6 = convert.convert(ast.globalStatements[5] as Any)
        XCTAssert(result1 ==
        """
        if(x.isSuccess() == 1){
        }else if(!value){
        }else{
        }
        """,result1)
        XCTAssert(result2 ==
        """
        do{
        }while(x > 0)
        """,result2)
        XCTAssert(result3 ==
        """
        switch(x){
        case 0:{
            break;
        }
        case 1:{
            break;
        }
        default:{
            break;
        }
        }
        """,result3)
        XCTAssert(result4 ==
        """
        for (int x = 0; x < 10; x++){
        }
        """,result4)
        XCTAssert(result5 ==
        """
        for (UIView *view in subviews){
        }
        """,result5)
        XCTAssert(result6 ==
        """
        while(x != nil){
        }
        """,result6)
        let result7 = convert.convert(ast.globalStatements[6] as Any)
        XCTAssert(result7 ==
        """
        return self.x;
        """,result7)
    }
    
    func testConvertClass(){
let source =
"""
@interface SFHTTPClient: NSObject
@property (nonatomic,readonly) NSURL *baseUrl;
@end
@implementation SFHTTPClient
- (instancetype)initWithBaseUrl:(NSURL *)baseUrl{

}
- (NSURLSessionDataTask *)requestWithMethod:(int)method uri:(NSString *)uri parameters:(NSDictionary *)param plugin:(id)plugin completion:(int)completion{

}
- (NSMutableURLRequest *)createRequestWithMethod:(int)method uri:(NSString *)URLString parameters:(NSDictionary *)param{

}
- (NSMutableURLRequest *)createEncryptedRequestWithMethod:(int)method uri:(NSString *)URLString parameters:(NSDictionary *)param{

}
- (NSURLSessionDataTask *)request:(NSURLRequest *)request plugin:(id)plugin completion:(int)completion{

}
@end
"""
        let ast = parser.parseSource(source)
        XCTAssert(parser.isSuccess())
        let result1 = convert.convert(ast.class(forName: "SFHTTPClient") as Any)
        XCTAssert(result1 ==
            """
            class SFHTTPClient:NSObject{
            @property(nonatomic,readonly)NSURL *baseUrl;

            -(id )initWithBaseUrl:(NSURL *)baseUrl{
            }
            -(NSURLSessionDataTask *)requestWithMethod:(int )method uri:(NSString *)uri parameters:(NSDictionary *)param plugin:(id )plugin completion:(int )completion{
            }
            -(NSMutableURLRequest *)createRequestWithMethod:(int )method uri:(NSString *)URLString parameters:(NSDictionary *)param{
            }
            -(NSMutableURLRequest *)createEncryptedRequestWithMethod:(int )method uri:(NSString *)URLString parameters:(NSDictionary *)param{
            }
            -(NSURLSessionDataTask *)request:(NSURLRequest *)request plugin:(id )plugin completion:(int )completion{
            }
            }

            """,result1)
        
    }
    
    func testConvertFile(){
        let bundle = Bundle.init(for: FileTest.classForCoder())
        let path = bundle.path(forResource: "TestSource", ofType: "imp")
        let data = try? Data.init(contentsOf:URL.init(fileURLWithPath: path!))
        let source = String.init(data: data ?? Data.init(), encoding: .utf8)
        let ast = parser.parseSource(source)
        XCTAssert(parser.isSuccess())
        var result = ""
         for node in ast.nodes {
            result.append(convert.convert(node))
        }
        let resultData = try? Data.init(contentsOf:URL.init(fileURLWithPath: bundle.path(forResource: "ConvertOuput", ofType: "txt")!))
        let resultStr = String.init(data: resultData ?? Data.init(), encoding: .utf8)!
        XCTAssert(result == resultStr,"\n"+result)
    }
    
    func testConvertGloablFunction(){
        let source =
        """
    NSString *queryPramameters(NSDictionary *param){
        NSMutableArray *pairs = [NSMutableArray array];
        [param enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            [pairs addObject:[NSString stringWithFormat:@"%@=%@",key,obj]];
        }];
        return [pairs componentsJoinedByString:@"&"];
    }
    """
        let ast = parser.parseSource(source)
        XCTAssert(parser.isSuccess())
        let result1 = convert.convert(ast.globalStatements[0])
        XCTAssert(result1 ==
            """
            NSString *queryPramameters(NSDictionary *param){
                NSMutableArray *pairs = NSMutableArray.array();
                param.enumerateKeysAndObjectsUsingBlock:(^void (id key,id obj,Point stop){
                    pairs.addObject:(NSString.stringWithFormat:(@"%@=%@",key,obj));
                });
                return pairs.componentsJoinedByString:(@"&");
            }
            ""","\n"+result1)
        
    }
    func testMangoPointerTypeAdapt(){
                let source =
        """
        char *a;
        float *a;
        int *a;
        short *a;
        long *a;
        long long *a;
        NSInteger *a;
        unsigned char *a;
        unsigned int *a;
        unsigned short *a;
        unsigned long *a;
        unsigned long long *a;
        NSUInteger *a;
        BOOL *a;
        double *a;
        float *a;
        CGFloat *a;
        """
                
        let ast = parser.parseSource(source)
        XCTAssert(parser.isSuccess())
        XCTAssert(convert.convert(ast.globalStatements[0]) == "Point a;")
        XCTAssert(convert.convert(ast.globalStatements[1]) == "Point a;")
        XCTAssert(convert.convert(ast.globalStatements[2]) == "Point a;")
        XCTAssert(convert.convert(ast.globalStatements[3]) == "Point a;")
        XCTAssert(convert.convert(ast.globalStatements[4]) == "Point a;")
        XCTAssert(convert.convert(ast.globalStatements[5]) == "Point a;")
        XCTAssert(convert.convert(ast.globalStatements[6]) == "Point a;")
        XCTAssert(convert.convert(ast.globalStatements[7]) == "Point a;")
        XCTAssert(convert.convert(ast.globalStatements[8]) == "Point a;")
        XCTAssert(convert.convert(ast.globalStatements[9]) == "Point a;")
        XCTAssert(convert.convert(ast.globalStatements[10]) == "Point a;")
        XCTAssert(convert.convert(ast.globalStatements[11]) == "Point a;")
        XCTAssert(convert.convert(ast.globalStatements[12]) == "Point a;")
        XCTAssert(convert.convert(ast.globalStatements[13]) == "Point a;")
        XCTAssert(convert.convert(ast.globalStatements[14]) == "Point a;")
        XCTAssert(convert.convert(ast.globalStatements[15]) == "Point a;")
        XCTAssert(convert.convert(ast.globalStatements[16]) == "Point a;")
        
    }
    func testMangoBlockTypeAdapt(){
        let source =
        """
        @interface SFHTTPClient: NSObject
        @property (nonatomic,readonly) void(^a)(NSString *name);
        @end
        @implementation SFHTTPClient
        + (instancetype)imageMakerWithProcessHandler:(UIImage * (^)(UIImage *image))processHandler isEnableHandler:(BOOL (^)(void))isEnableHandler identifierHandler:(NSString *(^)(void))identifierHandler{

        }
        @end
        void(^a)(NSString *name) = nil;
        void(*a)(NSString *name) = nil;
        """
        let ast = parser.parseSource(source)
        XCTAssert(parser.isSuccess())
        
        let result = convert.convert(ast.class(forName: "SFHTTPClient") as Any)
        XCTAssert(result ==
            """
            class SFHTTPClient:NSObject{
            @property(nonatomic,readonly)Block a;

            +(id )imageMakerWithProcessHandler:(Block)processHandler isEnableHandler:(Block)isEnableHandler identifierHandler:(Block)identifierHandler{
            }
            }

            ""","\n"+result)
        
        let result1 = convert.convert(ast.globalStatements[0] as Any)
        XCTAssert(result1 == "Block a = nil;","\n"+result1)
        let result2 = convert.convert(ast.globalStatements[1] as Any)
        XCTAssert(result2 == "Point a = nil;","\n"+result2)
        
    }
    func testMethodDeclare(){
        let source =
        """
        @interface SFHTTPClient: NSObject
        @end
        @implementation SFHTTPClient
        - (void)viewWillAppear:(BOOL)animated{

        }
        @end
        """
        let ast = parser.parseSource(source)
        XCTAssert(parser.isSuccess())
        
        let result = convert.convert(ast.class(forName: "SFHTTPClient") as Any)
        XCTAssert(result ==
            """
            class SFHTTPClient:NSObject{
            
            -(void )viewWillAppear:(BOOL )animated{
            }
            }

            ""","\n"+result)
    }
    func testSimpleChinese(){
        let source =
        """
        NSString * string = @"测试";
        """
        let ast = parser.parseSource(source)
        XCTAssert(parser.isSuccess())
        
        let result = convert.convert(ast.globalStatements[0] as Any)
        XCTAssert(result ==
            """
            NSString *string = @"测试";
            ""","\n"+result)
    }
    func testConvertMasonryBlock(){
        let source =
        """
        [view1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(superview.mas_top).with.offset(padding.top); //with is an optional semantic filler
            make.left.equalTo(superview.mas_left).with.offset(padding.left);
            make.bottom.equalTo(superview.mas_bottom).with.offset(-padding.bottom);
            make.right.equalTo(superview.mas_right).with.offset(-padding.right);
        }];
        self.handler(@"GGGG");
        handler(@"GGGG");
        self.handler = 2;
        """
        let ast = parser.parseSource(source)
        XCTAssert(parser.isSuccess())
        let result1 = convert.convert(ast.globalStatements[0] as Any)
        XCTAssert(result1 ==
            """
            view1.mas_makeConstraints:(^void (MASConstraintMaker *make){
                make.top.equalTo()(superview.mas_top).with.offset()(padding.top);
                make.left.equalTo()(superview.mas_left).with.offset()(padding.left);
                make.bottom.equalTo()(superview.mas_bottom).with.offset()(-padding.bottom);
                make.right.equalTo()(superview.mas_right).with.offset()(-padding.right);
            });
            ""","\n"+result1)
        
        let result2 = convert.convert(ast.globalStatements[1] as Any)
        XCTAssert(result2 ==
            """
            self.handler()(@"GGGG");
            ""","\n"+result2)
        let result3 = convert.convert(ast.globalStatements[2] as Any)
        XCTAssert(result3 ==
            """
            handler(@"GGGG");
            ""","\n"+result3)
        
        let result4 = convert.convert(ast.globalStatements[3] as Any)
        XCTAssert(result4 ==
            """
            self.handler = 2;
            ""","\n"+result4)

    }
    func testTypeConvert(){
        let source =
        """
        NSHTTPURLResponse *httpReponse = (char)response;
        NSHTTPURLResponse *httpReponse = (char *)response;
        NSHTTPURLResponse *httpReponse = (char(*)(void))response;
        NSHTTPURLResponse *httpReponse = (char(^)(void))response;
        NSHTTPURLResponse *httpReponse = (NSHTTPURLResponse *)response;
        // not surpport
        // NSHTTPURLResponse *httpReponse = (NSHTTPURLResponse)response;
        """
        let ast = parser.parseSource(source)
        XCTAssert(parser.isSuccess())
        var result1 = convert.convert(ast.globalStatements[0] as Any)
        XCTAssert(result1 == "NSHTTPURLResponse *httpReponse = response;", result1)
        result1 = convert.convert(ast.globalStatements[1] as Any)
        XCTAssert(result1 == "NSHTTPURLResponse *httpReponse = response;", result1)
        result1 = convert.convert(ast.globalStatements[2] as Any)
        XCTAssert(result1 == "NSHTTPURLResponse *httpReponse = response;", result1)
        result1 = convert.convert(ast.globalStatements[3] as Any)
        XCTAssert(result1 == "NSHTTPURLResponse *httpReponse = response;", result1)
        result1 = convert.convert(ast.globalStatements[4] as Any)
        XCTAssert(result1 == "NSHTTPURLResponse *httpReponse = response;", result1)
        
    }
}
