//
//  RRImageManager.h
//  changeImageName
//
//  Created by Henry on 2019/3/14.
//  Copyright © 2019年 Henry. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString *imageFilePath = @"/Users/renrenmeiju/Documents/work/PUClient/PUClient/PUClient/Images.xcassets";
static NSString *imageNewName = @"rrsp_";
static NSString *xibFilePath1 = @"/Users/renrenmeiju/Documents/work/PUClient/PUClient/PUClient/Class3.2.0";
static NSString *xibFilePath2 = @"/Users/renrenmeiju/Documents/work/PUClient/PUClient/PUClient/Class3.2.0";


NS_ASSUME_NONNULL_BEGIN

@interface RRImageManager : NSObject

+ (instancetype)shareManager;

- (void)goToChangeImageName;

- (void)goToWriteXibImageName;

@end

NS_ASSUME_NONNULL_END
