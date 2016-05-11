//
//  HelloWorldLayer.m
//  TextBoxLayerSample
//
//  Created by Fabio Rodella on 1/19/11.
//  Copyright __MyCompanyName__ 2011. All rights reserved.
//

// Import the interfaces
#import "HelloWorldScene.h"

// HelloWorld implementation
@implementation HelloWorld

+(id) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	HelloWorld *layer = [HelloWorld node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	[layer schedule:@selector(gameLoop:) interval:1/60.0f];
	
	// return the scene
	return scene;
}

// on "init" you need to initialize your instance
-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super" return value
	if( (self=[super init] )) {
		
        isLayer = NO;
        isView = NO;
        
        // ask director the the window size
		CGSize size = [[CCDirector sharedDirector] winSize];
        
        NSString *txt = @"This is a purposefully long text so as to test the wrapping functionality of the TextBoxLayer, as well as the multiple pages. That's it! This is the end, my only friend, the end.";
        
		textBox = [[TextBoxLayer alloc] initWithColor:[UIColor blueColor] width:200 height:80 padding:10 speed:0.01f text:txt];
        textBox.position =  ccp( size.width /2 , size.height/2 );
		textBox.delegate = self;
        
        textBoxView = [[TextBoxView alloc] initWithColor:[UIColor blueColor] width:200 height:80 padding:10 speed:80 text:txt];
        textBoxView.center = ccp( size.width /2 , size.height/2 );
        textBoxView.delegate = self;
        
        CCMenuItemFont *itemLayer = [CCMenuItemFont itemFromString:@"Layer" target:self selector:@selector(onLayer:)];
        CCMenuItemFont *itemView = [CCMenuItemFont itemFromString:@"View" target:self selector:@selector(onView:)];
        
        menu = [CCMenu menuWithItems:itemLayer, itemView, nil];
        [menu alignItemsHorizontallyWithPadding:20];
        menu.position = ccp( size.width /2 , size.height/2 );
        [self addChild:menu];
	}
	return self;
}

// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	// in case you have something to dealloc, do it in this method
	// in this particular example nothing needs to be released.
	// cocos2d will automatically release all the children (Label)
	[textBox release];
    [textBoxView release];
	// don't forget to call "super dealloc"
	[super dealloc];
}

- (void)gameLoop: (ccTime) dT {
    if (isLayer) {
        [textBox update:dT];
    }
	
    if (isView) {
        [textBoxView update:dT];
    }
}

- (void)onLayer:(id)sender {
    [self addChild:textBox];
    isLayer = YES;
    [menu removeFromParentAndCleanup:YES];
}

- (void)onView:(id)sender {
    [[CCDirector sharedDirector].openGLView addSubview:textBoxView];
    isView = YES;
    [menu removeFromParentAndCleanup:YES];
}

-(void) textBox:(id<TextBox>)tbox didFinishAllTextWithPageCount:(int)pc {
	if (isLayer) {
        [self removeChild:textBox cleanup:YES];
        isLayer = NO;
    }
    
    if (isView) {
        [textBoxView removeFromSuperview];
        isView = NO;
    }
}

@end
