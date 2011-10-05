//
//  TextBoxLayer.h
//  TextBoxLayerSample
//
//  Created by Fabio Rodella on 1/19/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "TextBox.h"

@interface TextBoxLayer : CCLayerColor <TextBox> {
	
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

- (NSString *)nextPage;

- (int)calculateStringSize:(NSString *)txt;

@end
