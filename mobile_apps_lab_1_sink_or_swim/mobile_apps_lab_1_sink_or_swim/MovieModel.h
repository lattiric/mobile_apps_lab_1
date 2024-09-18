//
//  MovieModel.h
//  mobile_apps_lab_1_sink_or_swim
//
//  Created by Rick Lattin on 9/18/24.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MovieModel : NSObject

+(MovieModel*)sharedInstance;

-(UIImage*)getMovieImageWithName:(NSString*)name;

@property(strong, nonatomic) NSArray* movieNames;
@property(strong, nonatomic) NSArray* movieDescs;



@end

NS_ASSUME_NONNULL_END
