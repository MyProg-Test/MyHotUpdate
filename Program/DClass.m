//
//  DClass.m
//  Program
//
//  Created by LY on 17/4/1.
//  Copyright © 2017年 LY. All rights reserved.
//

#import "DClass.h"

@implementation DClass

- (instancetype) init:(NSString*)clsPath DescriptionPath:(NSString*) desPath
{
    self = [super init];
    if (self) {
        _frameworkPath = clsPath;
        _descriptionPath = desPath;
        _descriptionDict = [[NSMutableDictionary alloc] initWithContentsOfFile:_descriptionPath];
        if([[NSFileManager defaultManager] fileExistsAtPath:_frameworkPath]){
            printf("framework exist\n");
        }else{
            printf("framework doesn't exist\n");
        }
        _bundle = [NSBundle bundleWithPath:_frameworkPath];
        if(_bundle == NULL){
            return nil;
        }
        if(![_bundle isLoaded]){
            [_bundle load];
        }
    }
    return self;
}

- (Class) getClass:(NSString*) clsName{
    NSArray* array = [_descriptionDict objectForKey:@"ClassName"];
    if(![array containsObject:clsName]){
        return nil;
    }
    Class rtn = [_bundle classNamed:clsName];
    return rtn;
}

- (id) performTarget:(id)target Method:(Method)method withArray:(NSArray*)anArgument{
    SEL aSelector = method_getName(method);
    NSMethodSignature *sig = [[target class] instanceMethodSignatureForSelector:aSelector];
    NSInvocation *invo = [NSInvocation invocationWithMethodSignature:sig];
    invo.target = target;
    invo.selector = aSelector;
    unsigned int paraNum = method_getNumberOfArguments(method);
    for (int i = 0; i < paraNum - 2; ++i) {
        char* paraType = method_copyArgumentType(method, i+2);
        if(strcmp(paraType, "@") == 0){
            id para = [anArgument objectAtIndex:i];
            [invo setArgument:&para atIndex:i+2];
        }else if(strcmp(paraType, "i") == 0){
            int para = [((NSNumber*)[anArgument objectAtIndex:i]) intValue];
            [invo setArgument:&para atIndex:i+2];
        }
    }
    [invo invoke];
    if(sig.methodReturnLength){
        char* rtnType = method_copyReturnType(method);
        if(strcmp(rtnType, "@") == 0){
            id rtn;
            [invo getReturnValue:&rtn];
            return rtn;
        }else if(strcmp(rtnType, "i") == 0){
            int rtn;
            [invo getReturnValue:&rtn];
            return [NSNumber numberWithInt:rtn];
        }
    }
    return nil;
}

- (void) dealloc{
    if([_bundle isLoaded]){
        [_bundle unload];
    }
    _bundle = nil;
    _frameworkPath = nil;
    _descriptionDict = nil;
    _descriptionPath = nil;
    
    
}


@end
