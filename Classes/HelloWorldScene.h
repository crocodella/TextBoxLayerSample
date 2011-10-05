//
//  HelloWorldLayer.h
//  TextBoxLayerSample
//
//  Created by Fabio Rodella on 1/19/11.
//  Copyright __MyCompanyName__ 2011. All rights reserved.
//


// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"
#import "TextBoxLayer.h"
#import "TextBoxView.h"

// HelloWorld Layer
@interface HelloWorld : CCLayer <TextBoxDelegate>
{
	TextBoxLayer *textBox;
    TextBoxView *textBoxView;
    
    CCMenu *menu;
    
    BOOL isLayer;
    BOOL isView;
}

// returns a Scene that contains the HelloWorld as the only child
+(id) scene;

- (void)gameLoop:(ccTime) dT;

- (void)onLayer:(id)sender;

- (void)onView:(id)sender;

@end
