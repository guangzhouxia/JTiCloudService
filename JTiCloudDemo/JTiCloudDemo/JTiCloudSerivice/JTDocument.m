//
//  JTDocument.m
//  iCloud
//
//  Created by YS-160408B on 17/1/13.
//  Copyright © 2017年 shunke. All rights reserved.
//

#import "JTDocument.h"

@implementation JTDocument

- (id)contentsForType:(NSString *)typeName error:(NSError * _Nullable __autoreleasing *)outError{
    if (self.data) {
        return [self.data copy];
    }
    return [NSData data];
}

- (BOOL)loadFromContents:(id)contents ofType:(NSString *)typeName error:(NSError * _Nullable __autoreleasing *)outError{
    self.data = [contents copy];
    return true;
}

@end
