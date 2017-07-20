//
//  cordova-file-share.m
//
//  Created by Alexander Blank on 19.07.17.
//
//

#import "CordovaFileShare.h"

@implementation CordovaFileShare


- (void)pluginInitialize
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationLaunchedWithImportUrl:) name:@"FileShareImportCall" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationPageDidLoad:) name:CDVPageDidLoadNotification object:nil];

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
    
    dispatch_block_t fileShareOpenUrl = ^(void) {
        // calls into javascript global function 'fileShareOpenURL'
    
        NSString* jsString = [NSString stringWithFormat:@"setTimeout(function() {if (typeof fileShareOpenURL === 'function') { fileShareOpenURL(\"%@\"); } }, 0);", url.absoluteString];
        
        [weakSelf.webViewEngine evaluateJavaScript:jsString completionHandler:nil];
    };
    
        
        NSString* jsString = @"document.readyState";
        [self.webViewEngine evaluateJavaScript:jsString
                             completionHandler:^(id object, NSError* error) {
                                 if ((error == nil) && [object isKindOfClass:[NSString class]]) {
                                     NSString* readyState = (NSString*)object;
                                     BOOL ready = [readyState isEqualToString:@"loaded"] || [readyState isEqualToString:@"complete"];

                                     if (ready) {
                                         fileShareOpenUrl();
                                     } else {
                                         NSString* jsStringTest2 = [NSString stringWithFormat:@"document.onreadystatechange = function () { if (document.readyState == \"complete\") {var breakCnt=0; var intVal = setInterval( function() { breakCnt++; if(breakCnt === 40) { clearInterval(intVal); } if(typeof fileShareOpenURL === \"function\") { fileShareOpenURL(\"%@\"); clearInterval(intVal); }}, 500);}}", url];
                                         
                                             [weakSelf.webViewEngine evaluateJavaScript:jsStringTest2 completionHandler:nil];
                                         
                                     }
                                 }
                             }];

}


@end
