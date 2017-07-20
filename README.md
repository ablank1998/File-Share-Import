-(BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {    
    if (url != nil && [url isFileURL]) {
	[[NSNotificationCenter defaultCenter] postNotificationName: @"FileShareImportCall" object:url];
    }    
    return YES;
}
