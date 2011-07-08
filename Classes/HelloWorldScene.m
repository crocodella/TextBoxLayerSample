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
		
		textBox = [[TextBoxLayer alloc] initWithColor:ccc4(0, 0, 255, 255) width:200 height:80 padding:10 text:@"This is a purposefully long text so as to test the wrapping functionality of the TextBoxLayer, as well as the multiple pages. That's it! This is the end, my only friend, the end."];

		// ask director the the window size
		CGSize size = [[CCDirector sharedDirector] winSize];
	
		// position the label on the center of the screen
		textBox.position =  ccp( size.width /2 , size.height/2 );
		
		textBox.delegate = self;
		
		// add the label as a child to this Layer
		[self addChild: textBox];
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
	// don't forget to call "super dealloc"
	[super dealloc];
}

- (void)gameLoop: (ccTime) dT {
	[textBox update:dT];
}

-(void) textBox:(TextBoxLayer *)tbox didFinishAllTextWithPageCount:(int)pc {
	[self removeChild:textBox cleanup:YES];
}

@end
