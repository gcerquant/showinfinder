//
//  main.m
//  showinfinder
//
//  Created by Guillaume Cerquant on 01/02/12.
//  Copyright (c) 2012 MacMation. All rights reserved.
//  http://www.macmation.com
//

#import <Foundation/Foundation.h>
#import <AppKit/AppKit.h>

BOOL isInvisible(NSString *filePath);


int main (int argc, const char * argv[])
{

    @autoreleasepool {

        NSMutableArray *urls = [NSMutableArray arrayWithCapacity:argc];

        for (int i = 1; i < argc; i++) {
            
            NSString *filePath = [[NSString stringWithCString:argv[i] encoding:NSASCIIStringEncoding] stringByExpandingTildeInPath];
            
            if (isInvisible(filePath)) {
                NSLog(@"%@ is invisible. Finder won't show it!", filePath);
            } else {
                [urls addObject:[[NSURL fileURLWithPath:filePath] absoluteURL]];
            }
        }
        
        
        if (! urls.count) {
            NSLog(@"Nothing to do. Bye!");
            exit(1);
        }

        
        [[NSWorkspace sharedWorkspace] activateFileViewerSelectingURLs:urls];
    }
    return 0;
}


BOOL isInvisible(NSString *filePath) {
    BOOL isDirectory;
    
    CFURLRef inURL = CFURLCreateWithFileSystemPath(kCFAllocatorDefault, (__bridge CFStringRef)filePath, kCFURLPOSIXPathStyle, ! ([[NSFileManager defaultManager]
                                                                                                                                  fileExistsAtPath:filePath isDirectory:&isDirectory] && isDirectory));
    LSItemInfoRecord itemInfo;
    LSCopyItemInfoForURL(inURL, kLSRequestAllFlags, &itemInfo);
    
    BOOL isInvisible = itemInfo.flags & kLSItemInfoIsInvisible;
    
    return (isInvisible != 0);
}