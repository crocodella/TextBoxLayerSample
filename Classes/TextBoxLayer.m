//
//  TextBoxLayer.m
//  TextBoxLayerSample
//
//  Created by Fabio Rodella on 1/19/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "TextBoxLayer.h"
#import "uthash.h"

@implementation TextBoxLayer

@synthesize delegate;

- (id) initWithColor:(UIColor *)color width:(CGFloat)w height:(CGFloat)h padding:(CGFloat)padding speed:(CGFloat)ts text:(NSString *)txt {
    
    int numComponents = CGColorGetNumberOfComponents(color.CGColor);
    
    CGFloat r = 0, g = 0, b = 0, a = 1;
    
    if (numComponents == 4)
    {
        const CGFloat *components = CGColorGetComponents(color.CGColor);
        r = components[0];
        g = components[1];
        b = components[2];
        a = components[3];
    }    
    
    ccColor4B col = ccc4((GLubyte) r * 255 , (GLubyte) g * 255, (GLubyte) b * 255, (GLubyte) a * 255);
    
	if ((self = [super initWithColor:col width:w + (padding * 2) height:h + (padding * 2)])) {
	
        self.isTouchEnabled = YES;
		
        textSpeed = ts;
        countDownTimer = textSpeed; // Arm the countdown timer.
		ended = NO;
		currentPageIndex = 0;
		
		CCBMFontConfiguration *conf = FNTConfigLoadFile(TEXT_FONT_FILE);
		linesPerPage = h / conf->commonHeight_ * [CCDirector sharedDirector].contentScaleFactor;
		
		NSArray *words = [txt componentsSeparatedByString:@" "];
		
		NSMutableString *wrappedText = [NSMutableString string];
		
		lines = [[NSMutableArray alloc] init];
		
        int wc = 0;
        
		for (NSString *word in words) {
            
            NSString *eval = nil;
            
            if (wc == 0) {
                eval = word;
            } else {
                eval = [wrappedText stringByAppendingFormat:@" %@", word];
            }
            
			int size = [self calculateStringSize:eval];
			
			// See if the text so far plus the new word fits the rect
			if (size > w) {
				
				// If not, closes this line and starts a new one
				[lines addObject:[NSString stringWithString:wrappedText]];
				[wrappedText setString:word];
			} else {
                if (wc > 0) {
                    [wrappedText appendString:@" "];
                }
				[wrappedText appendString:word];
			}
            
            wc++;
		}
        
		[lines addObject:[NSString stringWithString:wrappedText]];
		
		totalPages = ceil((float)[lines count] / linesPerPage);
		
		text = [txt retain];
		
		textLabel = [CCLabelBMFont labelWithString:[self nextPage] fntFile:TEXT_FONT_FILE];
		textLabel.anchorPoint = ccp(0,1);
		textLabel.position = ccp(padding, h + padding);
		
		// Hides all characters in the label
		for (CCNode *node in textLabel.children) {
			CCSprite *charSpr = (CCSprite *)node;
			charSpr.opacity = 0;
		}
		
		[self addChild:textLabel];
	}
	return self;
}

- (void)dealloc {
	[text release];
	[lines release];
	[currentPage release];
	[super dealloc];
}

- (void)update:(ccTime)dt {
    static int newLineOffset = 0;
    if(progress > currentPageCharCount - 1) {
        newLineOffset = 0;
        return;
    }

    countDownTimer = countDownTimer - dt;
    
    if(countDownTimer < 0) {
        if ([currentPage characterAtIndex:progress + newLineOffset] == '\n') {
            newLineOffset++;
        }
        
        CCSprite *charSpr = (CCSprite *) [textLabel getChildByTag:progress + newLineOffset];
        charSpr.opacity = 255;
        
        progress++;
        
        countDownTimer = textSpeed;
    }
    
    if(progress > currentPageCharCount - 1) {
        if ([delegate respondsToSelector:@selector(textBox:didFinishAllTextOnPage:)]) {
            [delegate textBox:(id<TextBox>) self didFinishAllTextOnPage:currentPageIndex];
        }
    }
}

- (NSString *)nextPage {
	progress = 0;
	
	[currentPage release];
	currentPage = [[NSMutableString string] retain];
	
	currentPageCharCount = 0;
	
	int line = currentPageIndex * linesPerPage;
	
	int i = 0;
	while (i < linesPerPage && line < [lines count]) {
		[currentPage appendFormat:@"%@\n", [lines objectAtIndex:line]];
		currentPageCharCount += [[lines objectAtIndex:line] length];
		i++;
		line++;
	}
	currentPageIndex++;
	
	return currentPage;
}

- (int)calculateStringSize:(NSString *)txt {
	
	CCBMFontConfiguration *conf = FNTConfigLoadFile(TEXT_FONT_FILE);
	
	int totalSize = 0;
	
	for (int i = 0; i < [txt length] / [CCDirector sharedDirector].contentScaleFactor; i++) {
		
		int c = [txt characterAtIndex:i];
		ccBMFontDef *def = NULL;
        HASH_FIND_INT(conf->BMFontHash_,&c,def);
		totalSize += def->xAdvance;
	}
	
	return totalSize;
}

-(void) ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	
	if (progress < currentPageCharCount) {
		
		for (CCNode *node in textLabel.children) {
			CCSprite *charSpr = (CCSprite *)node;
			charSpr.opacity = 255;
		}
		progress = currentPageCharCount;
		if(progress > currentPageCharCount - 1) {
			if ([delegate respondsToSelector:@selector(textBox:didFinishAllTextOnPage:)]) {
				[delegate textBox:(id<TextBox>) self didFinishAllTextOnPage:currentPageIndex];
			}
		}
		
	} else {
		 
		if (currentPageIndex < totalPages) {
			[textLabel setString:[self nextPage]];
			
			for (CCNode *node in textLabel.children) {
				CCSprite *charSpr = (CCSprite *)node;
				charSpr.opacity = 0;
			}
			
			if ([delegate respondsToSelector:@selector(textBox:didMoveToPage:)]) {
				[delegate textBox:(id<TextBox>) self didMoveToPage:currentPageIndex];
			}
			
		} else {
			
			if (!ended) {
				ended = YES;

				if ([delegate respondsToSelector:@selector(textBox:didFinishAllTextWithPageCount:)]) {
					[delegate textBox:(id<TextBox>) self didFinishAllTextWithPageCount:totalPages];
				}
			}
		}
	}
}

@end
