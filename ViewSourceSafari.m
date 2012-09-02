/*
 * ViewSourceSafari.m
 * View Source for MobileSafari
 *
 * Created by Árpád Goretity on 01/09/2012.
 * Licensed under the 3-clause BSD license
 */


#import <substrate.h>
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "UIAlertView+ViewSource.h"
#import "SourceViewController.h"

static IMP _orig1;

static SourceViewController *sourceViewCtrl = nil;

// toolchain bug workarounds
Class _UIPrintInteractionController, _UISimpleTextPrintFormatter;

// This is called when the user selects an option from our hook (UIAlertView)
void alertViewHandler(NSInteger index)
{
	id bController = [objc_getClass("BrowserController") sharedBrowserController];
	Ivar iv = object_getInstanceVariable(bController, "_rootViewController", NULL);
	void *ivPtr = (char *)bController + ivar_getOffset(iv);
	UIViewController *mainVc = *(UIViewController **)ivPtr;
	[mainVc retain];

	if (index == 0) {
		// view source
		id webBrowserView = [bController activeWebView];
		NSString *srcJs = @"document.documentElement.innerHTML.toString();";
		NSString *titleJs = @"document.title.toString();"; // page title
		NSString *html = [[webBrowserView webView] stringByEvaluatingJavaScriptFromString:srcJs]; // actuall almost-full source
		html = [NSString stringWithFormat:@"<html>\n%@\n</html>\n", html]; // the JS doesn't have access to the root node
		NSString *title = [[webBrowserView webView] stringByEvaluatingJavaScriptFromString:titleJs];

		[sourceViewCtrl release];
		sourceViewCtrl = [[SourceViewController alloc] init];
		[sourceViewCtrl setSource:html];
		[sourceViewCtrl setTitle:title];
		[sourceViewCtrl showInViewController:mainVc];
	} else {
		// Call original (show action list)
		_orig1(
			bController,
			@selector(showActionPanelFromButtonBar)
		);
	}
}

// This is called when the user taps on the action button
void _mod1(id __self, SEL __cmd)
{
	[UIAlertView showViewSourceAlert];
}

__attribute__((constructor))
void init()
{
	// Tweak the 'Show more' button on the top bar
	MSHookMessageEx(
	       objc_getClass("BrowserController"),
	       @selector(showActionPanelFromButtonBar),
	       (IMP)_mod1,
		&_orig1
	);

	_UIPrintInteractionController = objc_getClass("UIPrintInteractionController");
	_UISimpleTextPrintFormatter = objc_getClass("UISimpleTextPrintFormatter");
}

