//
//  LMTokenAttachmentCell.m
//  LMTextView
//
//  Created by Micha Mazaheri on 4/6/13.
//  Copyright (c) 2013 Lucky Marmot. All rights reserved.
//

#import "LMTokenAttachmentCell.h"
#import "NSView+CocoaExtensions.h"

@interface LMTokenAttachmentCell ()

@property (nonatomic) BOOL _highlighted;

@end

@implementation LMTokenAttachmentCell

- (NSString *)stringValue
{
	return [[NSString alloc] initWithData:self.attachment.fileWrapper.regularFileContents encoding:NSUTF8StringEncoding];
}

+ (NSTextAttachment *)tokenAttachmentWithString:(NSString *)string
{
	LMTokenAttachmentCell* tokenCell = [[LMTokenAttachmentCell alloc] init];
	
	NSTextAttachment* textAttachment = [[NSTextAttachment alloc] init];
	textAttachment.attachmentCell = tokenCell;
	NSFileWrapper* wrapper = [[NSFileWrapper alloc] initRegularFileWithContents:[string dataUsingEncoding:NSUTF8StringEncoding]];
	wrapper.preferredFilename = @"Token.ftc";
	textAttachment.fileWrapper = wrapper;

	return textAttachment;
}

#pragma mark - LMTextAttachmentCell Protocol

+ (id)textAttachmentCellWithTextAttachment:(NSTextAttachment *)textAttachment
{
	if ([textAttachment.fileWrapper.preferredFilename isEqualToString:@"Token.ftc"]) {
		return [[self alloc] init];
	}
	
	return nil;
}

#pragma mark - NSTextAttachmentCell Overrides

- (NSSize)cellSize
{
	return NSMakeSize([[self stringValue] sizeWithAttributes:@{NSFontAttributeName:[NSFont fontWithName:@"Menlo" size:11.f]}].width + 13.f, 13.f);
}

- (NSPoint)cellBaselineOffset
{
	return NSMakePoint(-1.f, -3.f);
}

- (void)drawWithFrame:(NSRect)cellFrame inView:(NSView *)controlView
{
	[self drawWithFrame:cellFrame inView:controlView characterIndex:NSNotFound layoutManager:nil];
}

- (void)drawWithFrame:(NSRect)cellFrame inView:(NSView *)controlView characterIndex:(NSUInteger)charIndex
{
	[self drawWithFrame:cellFrame inView:controlView characterIndex:charIndex layoutManager:nil];
}

- (void)drawWithFrame:(NSRect)cellFrame inView:(NSView *)controlView characterIndex:(NSUInteger)charIndex layoutManager:(NSLayoutManager *)layoutManager
{
	NSColor* bgColor = [NSColor colorWithCalibratedRed:173.f/255.f green:179.f/255.f blue:182.f/255.f alpha:1.f];
	NSColor* borderColor = [NSColor colorWithCalibratedRed:110.f/255.f green:116.f/255.f blue:114.f/255.f alpha:1.f];
	
	NSRect frame = cellFrame;
	CGFloat radius = ceilf([self cellSize].height / 2.f);
	NSBezierPath* roundedRectanglePath = [NSBezierPath bezierPathWithRoundedRect: NSMakeRect(NSMinX(frame) + 0.5, NSMinY(frame) + 0.5, NSWidth(frame) - 1, NSHeight(frame) - 1) xRadius: radius yRadius: radius];
	[(__highlighted ? [NSColor purpleColor] : bgColor) setFill];
	[roundedRectanglePath fill];
	[borderColor setStroke];
	[roundedRectanglePath setLineWidth: 1];
	[roundedRectanglePath stroke];
	
	CGSize size = [[self stringValue] sizeWithAttributes:@{NSFontAttributeName:[NSFont fontWithName:@"Menlo" size:11.f]}];
	CGRect textFrame = CGRectMake(cellFrame.origin.x + (cellFrame.size.width - size.width)/2,
								  cellFrame.origin.y-4.f,
								  size.width,
								  size.height);
	[[self stringValue] drawInRect:textFrame withAttributes:@{NSFontAttributeName:[NSFont fontWithName:@"Menlo" size:11.f]}];
}

- (void)highlight:(BOOL)flag withFrame:(NSRect)cellFrame inView:(NSView *)controlView
{
	self.highlighted = flag;
	[controlView setNeedsDisplayInRect:cellFrame];
}

//- (BOOL)wantsToTrackMouse
//{
//	return YES;
//}
//
//- (BOOL)wantsToTrackMouseForEvent:(NSEvent *)theEvent inRect:(NSRect)cellFrame ofView:(NSView *)controlView atCharacterIndex:(NSUInteger)charIndex
//{
//	return YES;
//}

//- (BOOL)trackMouse:(NSEvent *)theEvent inRect:(NSRect)cellFrame ofView:(NSView *)controlView untilMouseUp:(BOOL)flag
//{
//	return [self trackMouse:theEvent inRect:cellFrame ofView:controlView atCharacterIndex:NSNotFound untilMouseUp:flag];
//}
//
//- (BOOL)trackMouse:(NSEvent *)theEvent inRect:(NSRect)cellFrame ofView:(NSView *)controlView atCharacterIndex:(NSUInteger)charIndex untilMouseUp:(BOOL)flag
//{
//	NSLog(@"Mouse Pressed on Text Attachment");
//	return YES;
//}

@end
