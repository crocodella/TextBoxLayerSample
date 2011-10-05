//
//  TextBox.h
//  TextBoxLayerSample
//
//  Created by Fabio Rodella on 04/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#define TEXT_SPEED 60
#define TEXT_FONT_FILE @"arial16.fnt"

@protocol TextBox <NSObject>

- (id) initWithColor:(UIColor *)color 
			   width:(CGFloat)w 
			  height:(CGFloat)h 
			 padding:(CGFloat)padding 
				text:(NSString *)txt;

- (void)update:(float)dt;

@end

@protocol TextBoxDelegate <NSObject>

- (void)textBox:(id<TextBox>)tbox didFinishAllTextWithPageCount:(int)pc;

@optional
- (void)textBox:(id<TextBox>)tbox didMoveToPage:(int)p;

@end
