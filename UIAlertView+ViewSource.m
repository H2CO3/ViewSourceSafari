/*
 * UIAlertView+ViewSource.m
 * View Source for MobileSafari
 *
 * Created by Árpád Goretity on 01/09/2012.
 * Licensed under the 3-clause BSD license
 */

#import "UIAlertView+ViewSource.h"

extern void alertViewHandler(NSInteger index);

@implementation UIAlertView (ViewSource)

static UIAlertView *av = nil;

+ (void)showViewSourceAlert
{
	[av release];
	av = [[self alloc] init];
	av.title = @"Choose action";
	av.delegate = self;
	[av addButtonWithTitle:@"View source"];
	[av addButtonWithTitle:@"Details"];
	[av show];
}

+ (void)alertView:(UIAlertView *)av didDismissWithButtonIndex:(NSInteger)index
{
	alertViewHandler(index);
}

@end
