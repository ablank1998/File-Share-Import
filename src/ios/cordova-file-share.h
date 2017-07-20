//
//  cordova-file-share.h
//
//  Created by Alexander Blank on 19.07.17.
//  Created by David Silva Rebeaux on 19.07.17.
//
//

#import <Cordova/CDV.h>

@interface cordovaFileShare : CDVPlugin

@property (nonatomic, strong) NSURL* url;
@property (nonatomic, assign) BOOL pageLoaded;

@end

