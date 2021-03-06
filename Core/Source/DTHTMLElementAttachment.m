//
//  DTHTMLElementAttachment.m
//  DTCoreText
//
//  Created by Oliver Drobnik on 26.12.12.
//  Copyright (c) 2012 Drobnik.com. All rights reserved.
//

#import "DTHTMLElementAttachment.h"

#import "DTHTMLElement.h"
#import "DTTextAttachment.h"
#import "DTCoreTextParagraphStyle.h"
#import "NSMutableAttributedString+HTML.h"

@implementation DTHTMLElementAttachment

- (id)initWithName:(NSString *)name attributes:(NSDictionary *)attributes options:(NSDictionary *)options
{
	self = [super initWithName:name attributes:attributes];
	
	if (self)
	{
		// hide contents of recognized tag
		_tagContentInvisible = YES;
		
		// make appropriate attachment
		DTTextAttachment *attachment = [DTTextAttachment textAttachmentWithElement:self options:options];
		
		// add it to tag
		_textAttachment = attachment;
		
		// to avoid much too much space before the image
		_paragraphStyle.lineHeightMultiple = 1;
		
		// specifiying line height interfers with correct positioning
		_paragraphStyle.minimumLineHeight = 0;
		_paragraphStyle.maximumLineHeight = 0;
	}
	
	return self;
}

- (NSAttributedString *)attributedString
{
	NSDictionary *attributes = [self attributesDictionary];
	
	// ignore text, use unicode object placeholder
	NSMutableAttributedString *tmpString = [[NSMutableAttributedString alloc] initWithString:UNICODE_OBJECT_PLACEHOLDER attributes:attributes];
	
	// block-level elements get space trimmed and a newline
	if (self.displayStyle != DTHTMLElementDisplayStyleInline)
	{
		[tmpString appendString:@"\n"];
	}
	
	return tmpString;
}

// workaround, because we don't support float yet. float causes the image to be its own block
- (DTHTMLElementDisplayStyle)displayStyle
{
	if ([super floatStyle]==DTHTMLElementFloatStyleNone)
	{
		return [super displayStyle];
	}
	
	return DTHTMLElementDisplayStyleBlock;
}

@end
