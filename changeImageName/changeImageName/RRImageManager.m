//
//  RRImageManager.m
//  changeImageName
//
//  Created by Henry on 2019/3/14.
//  Copyright © 2019年 Henry. All rights reserved.
//

#import "RRImageManager.h"

@interface RRImageManager ()

@property (nonatomic, strong)NSFileManager *fileManager;

@end

@implementation RRImageManager

+ (instancetype)shareManager {
    static RRImageManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[RRImageManager alloc] init];
        
        NSFileManager *fileManager = [NSFileManager defaultManager];
        manager.fileManager = fileManager;
    });
    return manager;
}

#pragma mark - 替换指定路径xib中图片名称
- (void)goToWriteXibImageName {
    //查找xib
    NSMutableDictionary *dic = [self localFile:xibFilePath1 suffix:@".xib"];
    NSMutableDictionary *dic2 = [self localFile:xibFilePath2 suffix:@".xib"];
    NSArray *imagesetPathArray = [dic allValues];
    NSArray *imagesetPathArray2 = [dic2 allValues];
    NSMutableArray *arr = [NSMutableArray arrayWithArray:imagesetPathArray];
    [arr addObjectsFromArray:imagesetPathArray2];
    [self writeXibImageNameWithFileArray:arr];
}

- (void)writeXibImageNameWithFileArray:(NSArray *)fileArray {
    NSMutableArray *xibAndImageArray = [NSMutableArray array];
    for (NSString *fileString in fileArray) {
        NSMutableArray *arr = [NSMutableArray array];
        NSMutableArray *imageNameRangeArr = [NSMutableArray array];
        NSError *error = nil;
        NSString *xibString = [[NSString alloc] initWithContentsOfFile:fileString encoding:NSUTF8StringEncoding error:&error];
        if (error != nil) {
            continue;
        }
        NSArray *xibImageRangeArray = [self findAimstrAllRangeWithBaseStr:xibString andAimStr:@"image=\"" andBaseRange:NSMakeRange(0, xibString.length) resultArr:arr];
        if (xibImageRangeArray.count < 1) {
            continue;
        }
        [xibAndImageArray addObject:fileString];
        NSMutableString *xibmutable = [NSMutableString stringWithFormat:@"%@", xibString];
        NSUInteger strLength = 0;
        for (NSString *rangeStr in xibImageRangeArray) {
            NSRange range = NSRangeFromString(rangeStr);
            if (range.location == NSNotFound) {
                //未找到位置
                continue;
            }
            NSUInteger loc = range.location + range.length + strLength;
            NSRange newRange = [xibmutable rangeOfString:imageNewName options:NSLiteralSearch range:NSMakeRange(loc, imageNewName.length)];
            if (newRange.location != NSNotFound) {
                //已经替换过
                continue;
            }
            [xibmutable insertString:imageNewName atIndex:loc];
            strLength += imageNewName.length;
        }
        NSArray *xibImageNameRangeArray = [self findAimstrAllRangeWithBaseStr:xibString andAimStr:@"image name=\"" andBaseRange:NSMakeRange(0, xibString.length) resultArr:imageNameRangeArr];
        for (NSString *xibImageNameRangeRange in xibImageNameRangeArray) {
            NSRange range = NSRangeFromString(xibImageNameRangeRange);
            if (range.location == NSNotFound) {
                continue;
            }
            NSUInteger loc = range.location + range.length + strLength;
            NSRange newRange = [xibmutable rangeOfString:imageNewName options:NSLiteralSearch range:NSMakeRange(loc, imageNewName.length)];
            if (newRange.location != NSNotFound) {
                //已经替换过
                continue;
            }
            [xibmutable insertString:imageNewName atIndex:loc];
            strLength += imageNewName.length;
        }
        NSString *str = [NSString stringWithFormat:@"%@", xibmutable];
        [str writeToFile:fileString atomically:YES encoding:NSUTF8StringEncoding error:&error];
        if (error != nil) {
//            NSLog(@"%@", error);
        }
    }
    NSString *str = [xibAndImageArray componentsJoinedByString:@"\n"];
    [str writeToFile:@"/Users/renrenmeiju/Desktop/666/2.txt" atomically:YES encoding:NSUTF8StringEncoding error:nil];
}

- (NSMutableArray *)findAimstrAllRangeWithBaseStr:(NSString *)baseStr andAimStr:(NSString*)aimStr andBaseRange:(NSRange)baseRange resultArr:(NSMutableArray *)resultArr {
    
    NSRange range = [baseStr rangeOfString:aimStr options:NSLiteralSearch range:baseRange];
    if (range.length > 0) {
        [resultArr addObject:NSStringFromRange(range)];
        NSUInteger nextLocation = range.location + range.length;
        NSRange rangeNew = NSMakeRange(nextLocation, baseStr.length - nextLocation);
        [self findAimstrAllRangeWithBaseStr:baseStr andAimStr:aimStr andBaseRange:rangeNew resultArr:resultArr];
    }
    return resultArr;
}


- (void)goToChangeImageName {
    
    NSMutableDictionary *dic = [self localFile:imageFilePath suffix:@".imageset"];
    NSArray *imagesetPathArray = [dic allValues];
    //根据图片文件夹路径更改目录下png格式的图片名称
    [self writeImageNameWithImageFileArray:imagesetPathArray];
    
}

#pragma mark - 替换指定路径imageset下的图片名称和json
- (void)writeImageNameWithImageFileArray:(NSArray *)imagesetArray {
    NSError *error1 = nil;
    for (NSString *imagesetPath in imagesetArray) {
        NSArray *fileList = [self.fileManager contentsOfDirectoryAtPath:imagesetPath error:&error1];
        if (error1 != nil) {
            NSLog(@"ERROR : %@",error1);
            continue;
        }
        //
        NSMutableArray *imageArray = [NSMutableArray array];
        NSString *jsonFile = @"";
        for (NSString *imageOrImageJson in fileList) {
            //已经携带的不再替换
            if ([imageOrImageJson rangeOfString:imageNewName].location != NSNotFound) {
                continue;
            }
            //替换png图片
            if ([imageOrImageJson hasSuffix:@".png"] || [imageOrImageJson hasSuffix:@".jpg"]) {
                NSString *u = [imagesetPath stringByAppendingPathComponent:imageOrImageJson];
                NSString *newImageName = [NSString stringWithFormat:@"%@%@",imageNewName,imageOrImageJson];
                NSString *u1 = [imagesetPath stringByAppendingPathComponent:newImageName];
                [self.fileManager moveItemAtPath:u toPath:u1 error:&error1];
                if (error1 != nil) {
                    NSLog(@"imageName:%@ newImageName:%@, %@", imagesetPath, u1, error1);
                }
                [imageArray addObject:imageOrImageJson];
            } else if ([imageOrImageJson hasSuffix:@".json"]) {
                jsonFile = [imagesetPath stringByAppendingPathComponent:imageOrImageJson];
            } else {
                NSLog(@"%@",imageOrImageJson);
            }
        }
        if (imageArray.count < 1) {
            continue;
        }
        [self writeNewNameArray:imageArray jsonFile:jsonFile];
    }
    [self writeNewImagesetWithImagesetArray:imagesetArray];
    
}

#pragma mark - 更新imageset文件夹名称
- (void)writeNewImagesetWithImagesetArray:(NSArray *)imagesetArray {
    for (NSString *imagesetPath in imagesetArray) {
        NSString *imagesetName = [imagesetPath lastPathComponent];
        if ([imagesetName hasSuffix:@".imageset"]) {
            NSString *newImagesetName = [NSString stringWithFormat:@"%@%@",imageNewName, imagesetName];
            if ([imagesetName rangeOfString:imageNewName].location != NSNotFound) {
                continue;
            }
            NSString *newImagesetPath = [imagesetPath stringByReplacingOccurrencesOfString:imagesetName withString:newImagesetName];
            NSError *error = nil;
            [self.fileManager moveItemAtPath:imagesetPath toPath:newImagesetPath error:&error];
            if (error != nil) {
                NSLog(@"ERROR:%@ File: %@", error, imagesetPath);
            }
        }
    }
}

#pragma mark -更新json中的图片名称
- (void)writeNewNameArray:(NSArray *)imageNameArray jsonFile:(NSString *)jsonFile {
    if (jsonFile.length < 1 ) {
        NSLog(@"ERROR: 路径不存在%@",jsonFile);
        return;
    }
    if (imageNameArray.count < 1) {
        NSLog(@"ERROR: imageNameArray.count%ld",imageNameArray.count);
        return;
    }
    
    for (NSString *imageName in imageNameArray) {
        NSError *error = nil;
        NSString *jsonString = [NSString stringWithContentsOfFile:jsonFile encoding:NSUTF8StringEncoding error:&error];
        if (error != nil || imageName.length < 1) {
            NSLog(@"ERROR : %@ , %@", error, imageName);
            continue;
        }
        if ([jsonString rangeOfString:imageName].location != NSNotFound) {
            NSString *newImageNmae = [NSString stringWithFormat:@"%@%@",imageNewName,imageName];
            if ([jsonString rangeOfString:newImageNmae].location != NSNotFound) {
                continue;
            }
            jsonString = [jsonString stringByReplacingOccurrencesOfString:imageName withString:newImageNmae];
            [jsonString writeToFile:jsonFile atomically:YES encoding:NSUTF8StringEncoding error:&error];
            if (error != nil) {
                NSLog(@"%@", error);
            }
        }
    }
}

#pragma mark 获取路径下所有指定文件
- (NSMutableDictionary *)localFile:(NSString *)path suffix:(NSString *)suffix {
    NSFileManager *fm = [NSFileManager defaultManager];
    NSDirectoryEnumerator *dirEnum = [fm enumeratorAtPath:path];
    NSString *fileName;
    NSMutableDictionary *R = [NSMutableDictionary dictionary];
    while (fileName = [dirEnum nextObject]) {
        NSString *imagesetPath = [path stringByAppendingPathComponent:fileName];
        if ([fileName hasSuffix:suffix]) {
            NSString *key = [fileName lastPathComponent];
            [R setObject:imagesetPath forKey:key];
        }
    }
    return R;
}

@end
