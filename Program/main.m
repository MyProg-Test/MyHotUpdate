//
//  main.m
//  Program
//
//  Created by LY on 17/3/30.
//  Copyright © 2017年 LY. All rights reserved.
//

#import <Foundation/Foundation.h>
#include <objc/runtime.h>
#import "DClass.h"
NSString* f(int a, int b){
    return [[NSString alloc] initWithFormat:@"%d,%d",a,b];
}

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        DClass *dc = [[DClass alloc] init:@"/Users/ly/Desktop/Program/Program/testFramework.framework" DescriptionPath:@"/Users/ly/Desktop/Program/Program/example.plist"];
        Class cls = [dc getClass:@"Class2"];
        id c1 = [cls new];
        unsigned int mCount;
        Method* m = class_copyMethodList(cls, &mCount);
        for (int i = 0; i < mCount; ++i) {
            Method  mt = m[i];
            SEL mm = method_getName(mt);
            char* rtt = method_copyReturnType(mt);
            const char* name = sel_getName(mm);
            printf("%s %s ",name,rtt);
            unsigned int aCount = method_getNumberOfArguments(mt);
            for (int ii = 0; ii < aCount; ++ii) {
                char *t = method_copyArgumentType(mt, ii);
                printf(" %s+",t);
            }
            printf("\n");
        }
        NSArray *a = [[NSArray alloc] initWithObjects:[NSNumber numberWithInt:1],[NSNumber numberWithInt:2], nil];
        NSNumber *rtn = [dc performTarget:c1 Method:m[0] withArray:a];
        printf("%d\n",rtn.intValue);
    }
    return 0;
}
