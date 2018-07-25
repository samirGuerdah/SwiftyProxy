
//  Created by Samir on 23/07/2018.
#import <Foundation/Foundation.h>

#import <SwiftyProxy/SwiftyProxy-Swift.h>


@interface SwiftyJSONURLSessionConfiguration: NSObject @end

@implementation SwiftyJSONURLSessionConfiguration
+ (void)load {
    [NSURLSessionConfiguration swizzleSessionConfigurations];
}
@end

