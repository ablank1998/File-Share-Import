//
//  cordova-file-share.m
//
//  Created by Alexander Blank on 19.07.17.
//
//

#import "cordova-file-share.h"
#import <Cordova/CDV.h>

@implementation cordova-file-share


- (void)pluginInitialize
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationLaunchedWithImportUrl:) name:@"FileShareImportCall" object:nil];

}


- (void)applicationLaunchedWithImportUrl:(NSNotification*)notification
{
    NSURL* url = [notification object];
    
    self.url = url;
    
    // warm-start handler
    if (self.pageLoaded) {
        [self FileShareOpenUrl:self.url pageLoaded:YES];
        self.url = nil;
    }
}

- (void)applicationPageDidLoad:(NSNotification*)notification
{
    // cold-start handler
    
    self.pageLoaded = YES;
    
    if (self.url) {
        [self FileShareOpenUrl:self.url pageLoaded:YES];
        self.url = nil;
    }
}

- (void)FileShareOpenUrl:(NSURL*)url pageLoaded:(BOOL)pageLoaded
{

    __weak __typeof(self) weakSelf = self;
    
    dispatch_block_t handleOpenUrl = ^(void) {
        // calls into javascript global function 'handleOpenURL'
        NSString* jsString = [NSString stringWithFormat:@"document.addEventListener('deviceready',function(){if (typeof fileShareOpenURL === 'function') { fileShareOpenURL(\"%@\");}});", url.absoluteString];
        
        [weakSelf.webViewEngine evaluateJavaScript:jsString completionHandler:nil];
    };
    
    if (!pageLoaded) {
        NSString* jsString = @"document.readystate";
        [self.webViewEngine evaluateJavaScript:jsString
                             completionHandler:^(id object, NSError* error) {
                                 if ((error == nil) && [object isKindOfClass:[NSString class]]) {
                                     NSString* readyState = (NSString*)object;
                                     BOOL ready = [readyState isEqualToString:@"loaded"] || [readyState isEqualToString:@"complete"];
                                     if (ready) {
                                         fileShareOpenUrl();
                                     } else {
                                         self.url = url;
                                     }
                                 }
                             }];
    } else {
        fileShareOpenUrl();
    }

    
}


@end
