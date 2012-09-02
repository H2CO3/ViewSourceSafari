/*
 * SourceView.m
 * View Source for MobileSafari
 *
 * Created by Árpád Goretity on 01/09/2012.
 * Licensed under the 3-clause BSD license
 */

#import "SourceViewController.h"

// Tolchain bug workarounds
extern Class _UIPrintInteractionController, _UISimpleTextPrintFormatter;

@implementation SourceViewController

- (id)init
{
	if ((self = [super init])) {
		UIBarButtonItem *printer = [[[UIBarButtonItem alloc] initWithTitle:@"Print" style:UIBarButtonItemStyleBordered target:self action:@selector(print)] autorelease];
		UIBarButtonItem *btn = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(hide)] autorelease];
		self.navigationItem.leftBarButtonItem = printer;
		self.navigationItem.rightBarButtonItem = btn;

		textView = [[UITextView alloc] initWithFrame:self.view.bounds];
		textView.editable = NO;
		textView.font = [UIFont fontWithName:@"courier" size:15.0f];
		textView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
		[self.view addSubview:textView];
	}
	return self;
}

- (void)dealloc
{
	[textView release];
	[super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)o
{
	return YES;
}

- (void)setSource:(NSString *)source
{
	textView.text = source;
}

- (void)showInViewController:(UIViewController *)vc
{
	UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:self];
	[vc presentModalViewController:nav animated:YES];
	[nav release];
}

- (void)hide
{
	[self dismissModalViewControllerAnimated:YES];
}

// Barebones printing routine
- (void)print
{
	id printer = [_UIPrintInteractionController sharedPrintController];
	
	id formatter = [[_UISimpleTextPrintFormatter alloc] initWithText:textView.text];
	[formatter setColor:textView.textColor];
	[formatter setFont:textView.font];
	[printer setPrintFormatter:formatter];
	[formatter release];

	[printer presentFromBarButtonItem:self.navigationItem.leftBarButtonItem
				 animated:YES
			completionHandler:nil];
}

@end

