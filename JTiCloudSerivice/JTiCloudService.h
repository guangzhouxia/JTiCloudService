//
//  JTiCloudService.h
//  iCloud
//
//  Created by YS-160408B on 17/1/13.
//  Copyright © 2017年 shunke. All rights reserved.
//

#import <Foundation/Foundation.h>

@class JTDocument;

typedef NS_ENUM(NSInteger, CYDocumentSaveOperation) {
    CYDocumentSaveForCreating,
    CYDocumentSaveForOverwriting
};

@interface JTiCloudService : NSObject

@property (nonatomic,strong)NSURL *ubiquityURL;     //default is ~/Document/Document_file
@property (nonatomic,assign)CYDocumentSaveOperation operation; //default is CYDocumentSaveForOverwriting

- (instancetype)initWithUbiquityURL:(NSURL *)ubiquityURL;

- (void)save:(NSData *)data;
- (void)save:(NSData *)data completionHandler:(void (^)(BOOL success, NSError *error))completionHandler;

- (void)save:(NSData *)data toURL:(NSURL *)url completionHandler:(void (^)(BOOL success, NSError *error))completionHandler;

- (void)save:(NSData *)data forSaveOperation:(CYDocumentSaveOperation)saveOperation completionHandler:(void (^)(BOOL success, NSError *error))completionHandler;

- (void)save:(NSData *)data toURL:(NSURL *)url forSaveOperation:(CYDocumentSaveOperation)saveOperation completionHandler:(void (^)(BOOL success, NSError *error))completionHandler;

- (NSData *)readFromICloud;
- (NSData *)readFromICloudWithError:(NSError **)outError;
- (NSData *)readFromURL:(NSURL *)url error:(NSError **)outError;
@end
