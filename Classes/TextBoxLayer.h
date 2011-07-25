//
//  TextBoxLayer.h
//  TextBoxLayerSample
//
//  Created by Fabio Rodella on 1/19/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

#define TEXT_SPEED 60
#define TEXT_FONT_FILE @"arial16.fnt"

@class TextBoxLayer;

@protocol TextBoxDelegate <NSObject>

- (void)textBox:(TextBoxLayer *)tbox 
	didFinishAllTextWithPageCount:(int)pc;

@optional
- (void)textBox:(TextBoxLayer *)tbox didMoveToPage:(int)p;

@end


@interface TextBoxLayer : CCLayerColor {
	
	CCLabelBMFont *textLabel;
	
	NSString *text;
	NSMutableArray *lines;
	
	float progress;
	int linesPerPage;
	int currentPageIndex;
	NSMutableString *currentPage;
	int currentPageCharCount;
	
	int totalPages;
	
	id<TextBoxDelegate> delegate;
	
	BOOL ended;
}

@property (readwrite,assign) id<TextBoxDelegate> delegate;

- (id) initWithColor:(ccColor4B)color 
			   width:(GLfloat)w 
			  height:(GLfloat)h 
			 padding:(GLfloat)padding 
				text:(NSString *)txt;

- (void)update:(float)dt;

- (NSString *)nextPage;

- (int)calculateStringSize:(NSString *)txt;

@end
