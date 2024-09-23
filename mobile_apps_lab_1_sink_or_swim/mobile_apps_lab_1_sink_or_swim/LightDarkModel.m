//
//  LightDarkModel.m
//  mobile_apps_lab_1_sink_or_swim
//
//  Created by Rick Lattin on 9/22/24.
//

#import "LightDarkModel.h"

@implementation LightDarkModel
@synthesize lightOrDark = _lightOrDark;

+(LightDarkModel*)sharedInstance{
    static LightDarkModel* _sharedInstance = nil;
    
    static dispatch_once_t predicate;
    
    dispatch_once(&predicate, ^{
        _sharedInstance = [[LightDarkModel alloc] init];
    } );
    return _sharedInstance;
}

-(NSInteger*) lightOrDark{
    if(!_lightOrDark)
        _lightOrDark = 0;
    return _lightOrDark;
}

-(NSInteger)getLightOrDark{
    return _lightOrDark;
}

-(void)setLightOrDark:(NSInteger)num{
    _lightOrDark = num;
}



@end
