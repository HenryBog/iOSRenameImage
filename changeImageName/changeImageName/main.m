//
//  main.m
//  changeImageName
//
//  Created by Henry on 2019/3/14.
//  Copyright © 2019年 Henry. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RRImageManager.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // insert code here...
        
        [[RRImageManager shareManager] goToChangeImageName];
        [[RRImageManager shareManager] goToWriteXibImageName];
        
    }
    return 0;
}
