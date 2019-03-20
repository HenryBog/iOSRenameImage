////
////  UIImage+RRImageNameChange.m
////  PUClient
////
////  Created by Henry on 2019/3/20.
////  Copyright © 2019年 RRMJ. All rights reserved.
////
//
//#import "UIImage+RRImageNameChange.h"
//#import <objc/runtime.h>
//
//@implementation UIImage (RRImageNameChange)
//
//+ (void)load {
//    //虽然load只执行一次，但是为了保险起见，我们还是给加个dispatch_once吧，良好的编程习惯，从这里开始
//    static dispatch_once_t token;
//    dispatch_once(&token, ^{
//        
//        SEL orginSel = @selector(imageNamed:);
//        SEL overrideSel = @selector(rr_imageNamed:);
//        
//        Method originMethod = class_getClassMethod([self class], orginSel);
//        Method overrideMethod = class_getClassMethod([self class], overrideSel);
//            //交换实现
//        method_exchangeImplementations(originMethod, overrideMethod);
//    });
//}
//
//+ (nullable UIImage *)rr_imageNamed:(NSString *)name {
//        // 图片
//    UIImage *image = [UIImage rr_imageNamed:name];
//    if (image) {
//        return image;
//    } else {
//        UIImage *img = [UIImage rr_imageNamed:[NSString stringWithFormat:@"%@%@", imageNewName, name]];
//        return img;
//    }
//}
//
//
//@end
