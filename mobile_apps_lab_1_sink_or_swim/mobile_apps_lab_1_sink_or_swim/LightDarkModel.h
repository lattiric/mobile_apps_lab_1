//
//  LightDarkModel.h
//  mobile_apps_lab_1_sink_or_swim
//
//  Created by Rick Lattin on 9/22/24.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LightDarkModel : NSObject

+(LightDarkModel*)sharedInstance;

@property(strong, nonatomic) NSInteger* lightOrDark;

@end

NS_ASSUME_NONNULL_END
