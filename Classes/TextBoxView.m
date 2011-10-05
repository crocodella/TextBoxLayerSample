//
//  TextBoxView.m
//  TextBoxLayerSample
//
//  Created by Fabio Rodella on 04/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "TextBoxView.h"


@implementation TextBoxView

@synthesize delegate;

- (id) initWithColor:(UIColor *)color width:(CGFloat)w height:(CGFloat)h padding:(CGFloat)padding text:(NSString *)txt {
    
    if ((self = [super initWithFrame:CGRectMake(0, 0, w + (padding * 2), h + (padding * 2))])) {
        self.backgroundColor = color;
        
        width = w;
        height = h;
        
        currentPage = 0;
        text = [txt retain];
        
        label = [[UILabel alloc] initWithFrame:CGRectMake(padding, padding, w, h)];
        label.text = @"";
        label.backgroundColor = [UIColor clearColor];
        label.numberOfLines = 0;
        [self addSubview:label];
        [label release];
        
        NSArray *words = [txt componentsSeparatedByString:@" "];
        
        NSString *curText = [words objectAtIndex:0];
        int i = 1;
        
        pages = [[NSMutableArray alloc] init];
        
        while (i < [words count]) {
            
            NSString *nextText = [curText stringByAppendingFormat:@" %@",[words objectAtIndex:i]];
            CGSize size = [nextText sizeWithFont:label.font constrainedToSize:CGSizeMake(w, 99999) lineBreakMode:UILineBreakModeWordWrap];
            
            if (size.height > h) {
                [pages addObject:curText];
                curText = [words objectAtIndex:i];
            } else {
                curText = nextText;
            }
            i++;
        }
        [pages addObject:curText];
    }
    return self;
}


- (void)dealloc
{
    [pages release];
    [text release];
    [super dealloc];
}

- (void)update:(float)dt {
	
    NSString *page = [pages objectAtIndex:currentPage];
    
	progress += (dt * TEXT_SPEED);
	
	int visible = progress;
    if (visible > [page length]) {
        visible = [page length];
    }
    
    NSString *newTxt = [page substringToIndex:visible];
    
    label.text = newTxt;
    label.frame = CGRectMake(label.frame.origin.x, label.frame.origin.y, width, height);
    [label sizeToFit];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    NSString *page = [pages objectAtIndex:currentPage];
    
    int visible = progress;
    if (visible >= [page length]) {
        
        if (currentPage == [pages count] - 1) {
            if ([delegate respondsToSelector:@selector(textBox:didFinishAllTextWithPageCount:)]) {
                [delegate textBox:(id<TextBox>) self didFinishAllTextWithPageCount:[pages count]];
            }
        } else {
            currentPage++;
            progress = 0;
            
            if ([delegate respondsToSelector:@selector(textBox:didMoveToPage:)]) {
				[delegate textBox:(id<TextBox>) self didMoveToPage:currentPage];
			}
        }
        
    } else {
        progress = [page length];
    }
}

@end
