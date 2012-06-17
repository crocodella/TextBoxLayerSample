//
//  TextBoxView.h
//  TextBoxLayerSample
//
//  Created by Fabio Rodella on 04/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TextBox.h"

@interface TextBoxView : UIView <TextBox> {
    
    CGFloat width;
    CGFloat height;
    
    UILabel *label;
    NSString *text;
    float progress;
    
    int currentPage;
    CGFloat textSpeed;
    
    NSMutableArray *pages;
    
    id<TextBoxDelegate> delegate;
}

@property (readwrite,assign) id<TextBoxDelegate> delegate;

@end
