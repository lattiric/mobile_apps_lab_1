//
//  MovieModel.m
//  mobile_apps_lab_1_sink_or_swim
//
//  Created by Rick Lattin on 9/18/24.
//

#import "MovieModel.h"

@implementation MovieModel
@synthesize movieNames = _movieNames;
@synthesize movieDescs = _movieDescs;



+(MovieModel*)sharedInstance{
    static MovieModel* _sharedInstance = nil;
    
    static dispatch_once_t predicate;
    
    dispatch_once(&predicate, ^{
        _sharedInstance = [[MovieModel alloc] init];
    } );
    return _sharedInstance;
}

-(NSArray*) movieNames{
    if(!_movieNames)
        _movieNames = @[@"Shawshank Redemption", @"The Godfather", @"The Dark Knight", @"12 Angry Men"];
    return _movieNames;
}

-(NSArray*) movieDescs{
    if(!_movieDescs)
        _movieDescs = @[@"We're all innocent", @"You disrespected me", @"Why so serious", @"Idk any quotes from this fuck"];
    return _movieDescs;
}


-(UIImage*)getMovieImageWithName:(NSString *)name{
    UIImage* image = nil;
    image = [UIImage imageNamed:name];
    
    return image;
}



@end
