//
//  JTiCloudService.m
//  iCloud
//
//  Created by YS-160408B on 17/1/13.
//  Copyright © 2017年 shunke. All rights reserved.
//

#import "JTiCloudService.h"
#import "JTDocument.h"

#define JTiCloudUbiquityURLNULLErrorDomain NSURLErrorDomain
#define JTiCloudUbiquityURLNULLErrorCode -1
#define JTiCloudUbiquityURLNULLErrorDesc @{@"desc":@"ubiquityURL is nil"}

@interface JTiCloudService ()

@property (nonatomic,strong)JTDocument *document;

@end

@implementation JTiCloudService

- (instancetype)initWithUbiquityURL:(NSURL *)ubiquityURL {
    if (self = [super init]) {
        _ubiquityURL = ubiquityURL;
        _operation = CYDocumentSaveForOverwriting;
    }
    return self;
}

- (instancetype)init {
    return [self initWithUbiquityURL:[self ubiquityPath]];
}

- (void)save:(NSData *)data {
    [self save:data forSaveOperation:_operation completionHandler:nil];
}

- (void)save:(NSData *)data completionHandler:(void (^)(BOOL success, NSError *error))completionHandler {
    [self save:data forSaveOperation:_operation completionHandler:completionHandler];
}

- (void)save:(NSData *)data toURL:(NSURL *)url completionHandler:(void (^)(BOOL success, NSError *error))completionHandler {
    [self save:data toURL:url forSaveOperation:_operation completionHandler:completionHandler];
}

- (void)save:(NSData *)data forSaveOperation:(CYDocumentSaveOperation)saveOperation completionHandler:(void (^)(BOOL success, NSError *error))completionHandler {
    [self save:data toURL:self.ubiquityURL forSaveOperation:saveOperation completionHandler:completionHandler];
}

- (void)save:(NSData *)data toURL:(NSURL *)url forSaveOperation:(CYDocumentSaveOperation)saveOperation completionHandler:(void (^)(BOOL success, NSError *error))completionHandler {
    NSURL *ubiquityURL = self.ubiquityURL;
    
    if (ubiquityURL == nil) {
        NSError *error = [[NSError alloc] initWithDomain:JTiCloudUbiquityURLNULLErrorDomain
                                                    code:JTiCloudUbiquityURLNULLErrorCode
                                                userInfo:JTiCloudUbiquityURLNULLErrorDesc];
        if (completionHandler) {
            completionHandler(NO, error);
        }
        return;
    }
    
    self.document = [[JTDocument alloc] initWithFileURL:ubiquityURL];
    self.document.data = data;
    
    UIDocumentSaveOperation operation = (saveOperation == CYDocumentSaveForCreating) ? UIDocumentSaveForCreating : UIDocumentSaveForOverwriting;
    
    [self.document saveToURL:ubiquityURL forSaveOperation:operation completionHandler:^(BOOL success) {
        if (success) {
            if (completionHandler) {
                completionHandler(success, nil);
            }
        }else{
            if (completionHandler) {
                NSError *error = [[NSError alloc] initWithDomain:NSCocoaErrorDomain code:-2 userInfo:@{@"desc":@"save to icloud error"}];
                completionHandler(success, error);
            }
        }
    }];
}

- (NSData *)readFromICloud {
    return [self readFromURL:self.ubiquityURL error:nil];
}

- (NSData *)readFromICloudWithError:(NSError **)outError {
    return [self readFromURL:self.ubiquityURL error:outError];
}

- (NSData *)readFromURL:(NSURL *)url error:(NSError **)outError {
    NSURL *ubiquityURL = self.ubiquityURL;
    
    if (ubiquityURL == nil) {
        *outError = [[NSError alloc] initWithDomain:JTiCloudUbiquityURLNULLErrorDomain
                                               code:JTiCloudUbiquityURLNULLErrorCode
                                           userInfo:JTiCloudUbiquityURLNULLErrorDesc];
        return nil;
    }
    
    self.document = [[JTDocument alloc]initWithFileURL:ubiquityURL];
    if ([self.document readFromURL:ubiquityURL error:outError]){
        return self.document.data;
    }
    return nil;
}

#pragma mark - private func
- (NSURL *)ubiquityPath{
    NSURL *ubiquityURL = [[NSFileManager defaultManager]URLForUbiquityContainerIdentifier:nil];
    
    if (ubiquityURL == nil) {
        return nil;
    }
    
    ubiquityURL = [ubiquityURL URLByAppendingPathComponent:@"Document"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:[ubiquityURL path]] == false) {
        [fileManager createDirectoryAtURL:ubiquityURL withIntermediateDirectories:YES attributes:nil error:nil];
    }
    ubiquityURL = [ubiquityURL URLByAppendingPathComponent:@"Document_file"];
    
    return ubiquityURL;
}

@end
