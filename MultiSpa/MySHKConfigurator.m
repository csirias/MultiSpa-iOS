//
//  MySHKConfigurator.m
//  MultiSpa
//
//  Created by MacUser on 9/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MySHKConfigurator.h"

@implementation MySHKConfigurator
/* 
 App Description 
 ---------------
 These values are used by any service that shows 'shared from XYZ'
 */
- (NSString*)appName {
	return @"MultiSpa";
}

- (NSString*)appURL {
	return @"http://www.grupomultispa.com/";
}

/*
 API Keys
 --------
 This is the longest step to getting set up, it involves filling in API keys for the supported services.
 It should be pretty painless though and should hopefully take no more than a few minutes.
 
 Each key below as a link to a page where you can generate an api key.  Fill in the key for each service below.
 
 A note on services you don't need:
 If, for example, your app only shares URLs then you probably won't need image services like Flickr.
 In these cases it is safe to leave an API key blank.
 
 However, it is STRONGLY recommended that you do your best to support all services for the types of sharing you support.
 The core principle behind ShareKit is to leave the service choices up to the user.  Thus, you should not remove any services,
 leaving that decision up to the user.
 */

// Facebook - https://developers.facebook.com/apps
// SHKFacebookAppID is the Application ID provided by Facebook
// SHKFacebookLocalAppID is used if you need to differentiate between several iOS apps running against a single Facebook app. Useful, if you have full and lite versions of the same app,
// and wish sharing from both will appear on facebook as sharing from one main app. You have to add different suffix to each version. Do not forget to fill both suffixes on facebook developer ("URL Scheme Suffix"). Leave it blank unless you are sure of what you are doing. 
// The CFBundleURLSchemes in your App-Info.plist should be "fb" + the concatenation of these two IDs.
// Example: 
//    SHKFacebookAppID = 555
//    SHKFacebookLocalAppID = lite
// 
//    Your CFBundleURLSchemes entry: fb555lite
- (NSString*)facebookAppId {
	return @"430657380303048";
}

- (NSString*)facebookLocalAppId {
	return @"";
}


// Twitter - http://dev.twitter.com/apps/new
/*
 Important Twitter settings to get right:
 
 Differences between OAuth and xAuth
 --
 There are two types of authentication provided for Twitter, OAuth and xAuth.  OAuth is the default and will
 present a web view to log the user in.  xAuth presents a native entry form but requires Twitter to add xAuth to your app (you have to request it from them).
 If your app has been approved for xAuth, set SHKTwitterUseXAuth to 1.
 
 Callback URL (important to get right for OAuth users)
 --
 1. Open your application settings at http://dev.twitter.com/apps/
 2. 'Application Type' should be set to BROWSER (not client)
 3. 'Callback URL' should match whatever you enter in SHKTwitterCallbackUrl.  The callback url doesn't have to be an actual existing url.  The user will never get to it because ShareKit intercepts it before the user is redirected.  It just needs to match.
 */

/*
 If you want to force use of old-style, pre-IOS5 twitter framework, for example to ensure
 twitter accounts don't end up in the devices account store, set this to true.
 */
- (NSNumber*)forcePreIOS5TwitterAccess {
	return [NSNumber numberWithBool:false];
}

- (NSString*)twitterConsumerKey {
	return @"YWZiltA5P7mqUOnbJYCstw";
}

- (NSString*)twitterSecret {
	return @"AmixxrFcafCvWOloMkx5AArz1gD19gZbwRkfp5k";
}

// To use xAuth, set to 1
- (NSNumber*)twitterUseXAuth {
	return [NSNumber numberWithInt:1];
}
// Enter your app's twitter account if you'd like to ask the user to follow it when logging in. (Only for xAuth)
- (NSString*)twitterUsername {
	return @"GrupoMultispa";
}


/*
 UI Configuration : Basic
 ------------------------
 These provide controls for basic UI settings.  For more advanced configuration see below.
 */

// Toolbars
- (NSString*)barStyle {
	return @"UIBarStyleDefault";// See: http://developer.apple.com/iphone/library/documentation/UIKit/Reference/UIKitDataTypesReference/Reference/reference.html#//apple_ref/c/econst/UIBarStyleDefault
}

- (UIColor*)barTintForView:(UIViewController*)vc {
    return nil;
}

// Forms
- (UIColor *)formFontColor {
    return nil;
}

- (UIColor*)formBackgroundColor {
    return nil;
}

// iPad views
- (NSString*)modalPresentationStyle {
	return @"UIModalPresentationFormSheet";// See: http://developer.apple.com/iphone/library/documentation/UIKit/Reference/UIViewController_Class/Reference/Reference.html#//apple_ref/occ/instp/UIViewController/modalPresentationStyle
}

- (NSString*)modalTransitionStyle {
	return @"UIModalTransitionStyleCoverVertical";// See: http://developer.apple.com/iphone/library/documentation/UIKit/Reference/UIViewController_Class/Reference/Reference.html#//apple_ref/occ/instp/UIViewController/modalTransitionStyle
}
// ShareMenu Ordering
- (NSNumber*)shareMenuAlphabeticalOrder {
	return [NSNumber numberWithInt:0];// Setting this to 1 will show list in Alphabetical Order, setting to 0 will follow the order in SHKShares.plist
}

/* Name of the plist file that defines the class names of the sharers to use. Usually should not be changed, but this allows you to subclass a sharer and have the subclass be used. Also helps, if you want to exclude some sharers - you can create your own plist, and add it to your project. This way you do not need to change original SHKSharers.plist, which is a part of subproject - this allows you upgrade easily as you did not change ShareKit itself 
 
 You can specify also your own bundle here, if needed. For example:
 return [[[NSBundle mainBundle] pathForResource:@"Vito" ofType:@"bundle"] stringByAppendingPathComponent:@"VKRSTestSharers.plist"]
 */
- (NSString*)sharersPlistName {
	return @"SHKSharers.plist";
}

// SHKActionSheet settings
- (NSNumber*)showActionSheetMoreButton {
	return [NSNumber numberWithBool:true];// Setting this to true will show More... button in SHKActionSheet, setting to false will leave the button out.
}

/*
 Favorite Sharers
 ----------------
 These values are used to define the default favorite sharers appearing on ShareKit's action sheet.
 */
- (NSArray*)defaultFavoriteURLSharers {
    return [NSArray arrayWithObjects:@"SHKTwitter",@"SHKFacebook", nil];
}
- (NSArray*)defaultFavoriteImageSharers {
    return [NSArray arrayWithObjects:@"SHKMail",@"SHKFacebook", @"SHKCopy", nil];
}
- (NSArray*)defaultFavoriteTextSharers {
    return [NSArray arrayWithObjects:@"SHKMail",@"SHKTwitter",@"SHKFacebook", nil];
}
- (NSArray*)defaultFavoriteFileSharers {
    return [NSArray arrayWithObjects:@"SHKMail",@"SHKEvernote", nil];
}

//by default, user can see last used sharer on top of the SHKActionSheet. You can switch this off here, so that user is always presented the same sharers for each SHKShareType.
- (NSNumber*)autoOrderFavoriteSharers {
    return [NSNumber numberWithBool:false];
}

/*
 UI Configuration : Advanced
 ---------------------------
 If you'd like to do more advanced customization of the ShareKit UI, like background images and more,
 check out http://getsharekit.com/customize. To use a subclass, you can create your own, and let ShareKit know about it in your configurator, overriding one (or more) of these methods.
 */

- (Class)SHKActionSheetSubclass {    
    return NSClassFromString(@"SHKActionSheet");
}

- (Class)SHKShareMenuSubclass {    
    return NSClassFromString(@"SHKShareMenu");
}

- (Class)SHKShareMenuCellSubclass {
    return NSClassFromString(@"UITableViewCell");
}

- (Class)SHKFormControllerSubclass {
    return NSClassFromString(@"SHKFormController");
}

/*
 Advanced Configuration
 ----------------------
 These settings can be left as is.  This only need to be changed for uber custom installs.
 */
- (NSNumber*)maxFavCount {
	return [NSNumber numberWithInt:4];
}

- (NSString*)favsPrefixKey {
	return @"SHK_FAVS_";
}

- (NSString*)authPrefix {
	return @"SHK_AUTH_";
}

- (NSNumber*)allowOffline {
	return [NSNumber numberWithBool:true];
}

- (NSNumber*)allowAutoShare {
	return [NSNumber numberWithBool:true];
}

/* 
 Debugging settings
 ------------------
 see DefaultSHKConfigurator.h
 */

/*
 SHKItem sharer specific values defaults
 -------------------------------------
 These settings can be left as is. SHKItem is what you put your data in and inject to ShareKit to actually share. Some sharers might be instructed to share the item in specific ways, e.g. SHKPrint's print quality, SHKMail's send to specified recipients etc. Sometimes you need to change the default behaviour - you can do it here globally, or per share during share item (SHKItem) composing. Example is in the demo app - ExampleShareLink.m - share method */

/* SHKPrint */

- (NSNumber*)printOutputType {    
    return [NSNumber numberWithInt:UIPrintInfoOutputPhoto];
}

/* SHKMail */

//constructed during runtime from user input in shareForm by default
- (NSString*)mailBody {
    return nil;
}

- (NSNumber*)isMailHTML {
    return [NSNumber numberWithInt:1];
}

//user enters them in MFMailComposeViewController by default. Should be array of NSStrings.
- (NSArray*)mailToRecipients {
    return nil;
}

//used only if you share image. Values from 1.0 to 0.0 (maximum compression).
- (NSNumber*)mailJPGQuality {
    return [NSNumber numberWithFloat:1];
}

// append 'Sent from <appName>' signature to Email
- (NSNumber*)sharedWithSignature {
	return [NSNumber numberWithInt:0];
}

/* SHKFacebook */

//when you share URL on Facebook, FBDialog scans the page and fills picture and description automagically by default. Use these item properties to set your own.
- (NSString *)facebookURLSharePictureURI {
    return nil;
}

- (NSString *)facebookURLShareDescription {
    return nil;
}


@end
