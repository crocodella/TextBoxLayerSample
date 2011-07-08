//
//  TextBoxLayerSampleAppDelegate.h
//  TextBoxLayerSample
//
//  Created by Fabio Rodella on 1/19/11.
//  Copyright __MyCompanyName__ 2011. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RootViewController;

@interface TextBoxLayerSampleAppDelegate : NSObject <UIApplicationDelegate> {
	UIWindow			*window;
	RootViewController	*viewController;
}

@property (nonatomic, retain) UIWindow *window;

@end
