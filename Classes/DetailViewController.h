//
//  DetailViewController.h
//  MailWranglerForiPad
//
//  Created by Angelo DiNardi on 5/9/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "ModalBrowser.h";

@class RootViewController;

@interface DetailViewController : UIViewController <UIPopoverControllerDelegate, UISplitViewControllerDelegate, UIWebViewDelegate, ModalViewControllerDelegate> {
    
    UIPopoverController *popoverController;
    UIToolbar *toolbar;
    
    NSManagedObject *detailItem;
    UILabel *detailDescriptionLabel;
    UIWebView *webView;
    UIBarButtonItem *accountsButton;
    UIBarButtonItem *addButton;

    RootViewController *rootViewController;
    NSString *currentPassword;
    bool hasLoggedIn;
    UIPopoverController *accountsPopover;
    //NSString *content;
    //NSString *fakeUrl;
}

@property (nonatomic, retain) NSString *currentPassword;
@property (nonatomic, retain) IBOutlet UIToolbar *toolbar;

@property (nonatomic, retain) NSManagedObject *detailItem;
@property (nonatomic, retain) IBOutlet UILabel *detailDescriptionLabel;
@property (nonatomic, retain) IBOutlet UIWebView *webView;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *accountsButton;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *addButton;

@property (nonatomic, assign) IBOutlet RootViewController *rootViewController;

- (IBAction)insertNewObject:(id)sender;
- (IBAction)doAddAccount:(id)sender;
- (IBAction)clickAccountsButton:(id)sender;

- (void) hidePopover;

@end
