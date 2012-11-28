//
//  ExtremeGeocoder.m
//  GWV2
//
//  Created by yangzexin on 12-10-11.
//
//

#import "ExtremeGeocoder.h"

@interface ExtremeGeocoder () <GeocoderDelegate>

@property(nonatomic, retain)NSArray *geocoderList;
@property(nonatomic, retain)NSMutableDictionary *geocoderStatusDict;

@end

@implementation ExtremeGeocoder

@synthesize delegate;
@synthesize geocoderList;
@synthesize geocoderStatusDict;

- (void)dealloc
{
    self.geocoderList = nil;
    self.geocoderStatusDict = nil;
    [super dealloc];
}

- (id)initWithGeocoderList:(NSArray *)pGeocoderList
{
    self = [super init];
    
    self.geocoderList = pGeocoderList;
    
    return self;
}

- (void)geocodeWithLatitude:(double)latitude longitude:(double)longitude
{
    [self cancelAllGeocoder];
    if(self.geocoderList.count == 0){
        [self notifyFail:[NSError errorWithDomain:@"ExtremeGeocoder"
                                             code:0
                                         userInfo:[NSDictionary dictionaryWithObject:@"Empty geocoder list" forKey:NSLocalizedDescriptionKey]]];
    }else{
        self.geocoderStatusDict = [NSMutableDictionary dictionary];
        for(id<Geocoder> tmpGeocoder in self.geocoderList){
            [self.geocoderStatusDict setObject:[NSNumber numberWithBool:NO] forKey:[self identifierForGeocoder:tmpGeocoder]];
        }
        for(id<Geocoder> tmpGeocoder in self.geocoderList){
            tmpGeocoder.delegate = self;
            [tmpGeocoder geocodeWithLatitude:latitude longitude:longitude];
        }
    }
}

- (void)cancel
{
    [self cancelAllGeocoder];
    self.delegate = nil;
}

- (void)cancelAllGeocoder
{
    for(id<Geocoder> tmpGeocoder in self.geocoderList){
        [tmpGeocoder cancel];
    }
}

- (NSString *)identifierForGeocoder:(id<Geocoder>)geocoder
{
    return [NSString stringWithFormat:@"%@", geocoder];
}

- (void)notifySuccess:(LocationDescription *)locationDesc
{
    if([self.delegate respondsToSelector:@selector(geocoder:didRecieveLocality:)]){
        [self.delegate geocoder:self didRecieveLocality:locationDesc];
    }
}

- (void)notifyFail:(NSError *)error
{
    if([self.delegate respondsToSelector:@selector(geocoder:didError:)]){
        [self.delegate geocoder:self didError:error];
    }
}

#pragma mark - GeocoderDelegate
- (void)geocoder:(id)geocoder didRecieveLocality:(LocationDescription *)info
{
    NSLog(@"ExtremeGeocoder:%@, %@", geocoder, info);
    @synchronized(self){
        [self notifySuccess:info];
        [self cancelAllGeocoder];
    }
}

- (void)geocoder:(id)geocoder didError:(NSError *)error
{
    @synchronized(self){
        [self.geocoderStatusDict setObject:[NSNumber numberWithBool:YES] forKey:[self identifierForGeocoder:geocoder]];
        
        NSArray *allKeys = [self.geocoderStatusDict allKeys];
        BOOL allFinished = YES;
        for(NSString *key in allKeys){
            NSNumber *status = [self.geocoderStatusDict objectForKey:key];
            if(!status.boolValue){
                allFinished = NO;
                break;
            }
        }
        if(allFinished){
            [self notifyFail:[NSError errorWithDomain:@"ExtremeGeocoder"
                                                 code:-1
                                             userInfo:[NSDictionary dictionaryWithObject:@"Geocode failed" forKey:NSLocalizedDescriptionKey]]];
        }
    }
}

@end
