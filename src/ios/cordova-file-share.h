//
//  cordova-file-share.h
//
//  Created by Alexander Blank on 19.07.17.
//  Created by David Silva Rebeaux on 19.07.17.
//
//

#import <Cordova/CDVPlugin.h>

@interface cordova-file-share : CDVPlugin

@property (nonatomic, strong) NSURL* url;
@property (nonatomic, assign) BOOL pageLoaded;

@end

