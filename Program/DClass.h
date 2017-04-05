//
//  DClass.h
//  Program
//
//  Created by LY on 17/4/1.
//  Copyright © 2017年 LY. All rights reserved.
//

#import <Foundation/Foundation.h>
#include <objc/runtime.h>

@interface DClass : NSObject

@property(copy,atomic) NSString *frameworkPath;
@property(copy,atomic) NSString *descriptionPath;
@property(copy,atomic) NSString *className;
@property(strong, atomic) NSMutableDictionary *descriptionDict;
@property(strong,nonatomic,readonly) NSBundle *bundle;
- (instancetype) init:(NSString*)clsPath DescriptionPath:(NSString*) desPath;
- (Class) getClass:(NSString*) clsName;
- (id) performTarget:(id)target Method:(Method)method withArray:(NSArray*)anArgument;
- (void) dealloc;

@end
