//
//  TestSource.swift
//  oc2mangoLibTests
//
//  Created by Jiang on 2019/4/30.
//  Copyright © 2019年 SilverFruity. All rights reserved.
//

import Cocoa

class TestSource{
    static let methodSource =
    """
    [[self.x method].y method];
    [[object setValue:self forKey:@"name"] test:@"string"];
    [[object valueForKey:@"key"] object];
    """
    static let blockDeclareSource =
    """
    void (^block)(NSString *name) = ^(NSstring *name){
        
    }
    """
    
    static let declareSource =
    """
    int x = 0;
    NSString *str = @"123";
    NSObject *object = [NSObject new];
    // NSArray
    // NSDictionary
    // NSNumber
    """
    

}
