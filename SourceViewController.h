/*
 * SourceView.h
 * View Source for MobileSafari
 *
 * Created by Árpád Goretity on 01/09/2012.
 * Licensed under the 3-clause BSD license
 */

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface SourceViewController: UIViewController {
        UITextView *textView;
}

- (void)setSource:(NSString *)source;

- (void)showInViewController:(UIViewController *)vc;
- (void)hide;

@end

