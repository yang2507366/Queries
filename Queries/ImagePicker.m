//
//  ImagePicker.m
//  GewaraSport
//
//  Created by yangzexin on 12-9-4.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ImagePicker.h"
#import "AlertDialog.h"

#define kTitleSelectPicture @"选择图片"
#define kTitlePicture       @"照片"
#define kTitleCamera        @"拍照"

@interface ImagePicker () <UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPopoverControllerDelegate>

@property(nonatomic, retain)UIViewController *presentingViewController;
@property(nonatomic, retain)UIPopoverController *popoverController;
@property(nonatomic, copy)ImagePickerCompletion callback;

@end

@implementation ImagePicker

+ (void)presentWithViewController:(UIViewController *)viewController completion:(ImagePickerCompletion)completion
{
    [[[ImagePicker new] autorelease] presentWithViewController:viewController completion:completion];
}

- (void)dealloc
{
    self.presentingViewController = nil;
    self.popoverController = nil;
    self.callback = nil;
    [super dealloc];
}

- (void)presentInViewController:(UIViewController *)viewController completion:(ImagePickerCompletion)completion
{
    [self retain];
    self.presentingViewController = viewController;
    self.callback = completion;
    
    UIActionSheet *tmpActionSheet = nil;
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
        tmpActionSheet = [[UIActionSheet alloc] initWithTitle:kTitleSelectPicture 
                                                     delegate:self 
                                            cancelButtonTitle:@"取消" 
                                       destructiveButtonTitle:nil 
                                            otherButtonTitles:kTitleCamera, kTitlePicture, nil];
    }else{
        tmpActionSheet = [[UIActionSheet alloc] initWithTitle:kTitleSelectPicture 
                                                     delegate:self 
                                            cancelButtonTitle:@"取消" 
                                       destructiveButtonTitle:nil 
                                            otherButtonTitles:kTitlePicture, nil];
    }
    [tmpActionSheet showInView:self.presentingViewController.view];
    [tmpActionSheet release];
}

- (void)presentWithViewController:(UIViewController *)viewController completion:(ImagePickerCompletion)completion
{
    [self retain];
    __block typeof(self) bself = self;
    self.callback = completion;
    self.presentingViewController = viewController;
    
    DialogCompletion dialogCallbck = ^(NSInteger buttonIndex, NSString *buttonTitle) {
        UIImagePickerController *imgPickerController = [[[UIImagePickerController alloc] init]  autorelease];
        imgPickerController.delegate = self;
        imgPickerController.allowsEditing = YES;
        if([buttonTitle isEqualToString:kTitleCamera]){
            imgPickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
        }else if([buttonTitle isEqualToString:kTitlePicture]){
            imgPickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        }else{
            [bself release];
            return;
        }
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
            self.popoverController = [[[UIPopoverController alloc] initWithContentViewController:imgPickerController] autorelease];
            self.popoverController.delegate = self;
            self.popoverController.popoverContentSize = CGSizeMake(320, 480);
            [self.popoverController presentPopoverFromRect:CGRectMake((viewController.view.frame.size.width - 320) / 2, 0, 320, 2)
                                                    inView:self.presentingViewController.view
                                  permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
        }else{
            [self.presentingViewController presentModalViewController:imgPickerController animated:YES];
        }
    };
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
        [AlertDialog showWithTitle:kTitleSelectPicture
                           message:nil
                        completion:dialogCallbck
                 cancelButtonTitle:@"取消"
                 otherButtonTitles:kTitleCamera, kTitlePicture, nil];
    }else{
        [AlertDialog showWithTitle:kTitleSelectPicture
                           message:nil
                        completion:dialogCallbck
                 cancelButtonTitle:@"取消"
                 otherButtonTitles:kTitlePicture, nil];
    }
}

#pragma mark - UIPopoverControllerDelegate
- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
    [self release];
}

#pragma mark - ActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *actionTitle = [actionSheet buttonTitleAtIndex:buttonIndex];
    if([actionTitle isEqualToString:@"取消"]){
        [self release];
        return;
    }
    UIImagePickerController *imgPickerController = [[[UIImagePickerController alloc] init]  autorelease];
    imgPickerController.delegate = self;
    imgPickerController.allowsEditing = YES;
    if([actionTitle isEqualToString:kTitleCamera]){
        imgPickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
    }else if([actionTitle isEqualToString:kTitlePicture]){
        imgPickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        self.popoverController = [[[UIPopoverController alloc] initWithContentViewController:imgPickerController] autorelease];
        [self.popoverController presentPopoverFromRect:CGRectZero inView:self.presentingViewController.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    }else{
        [self.presentingViewController presentModalViewController:imgPickerController animated:YES];
    }
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo
{
    [self.presentingViewController dismissModalViewControllerAnimated:YES];
    [self.popoverController dismissPopoverAnimated:YES];
    if(self.callback){
        self.callback(image);
    }
    [self release];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self.presentingViewController dismissModalViewControllerAnimated:YES];
    [self release];
}

@end
