//
//  RNImagePicker.m
//  ImagePicker
//
//  Created by Rajeev Kumar Upadhyay on 9/8/16.
//  Copyright © 2016 Facebook. All rights reserved.
//

#import "RNImagePicker.h"
#import "RBImagePickerDelegate.h"
#import "RBImagePickerController.h"
#import "ALAsset+RBAsset.h"

const MAX_NUMBER_SELECTION  = 10;

@interface RNImagePicker()<RBImagePickerDelegate,RBImagePickerDataSource>
@property (nonatomic, strong) RCTResponseSenderBlock callback;
@property (strong, nonatomic) RBImagePickerController *imagePicker;
@end

@implementation RNImagePicker



RCT_EXPORT_MODULE();

RCT_EXPORT_METHOD(launchImageGalleryWithcallback:(RCTResponseSenderBlock)callback)
{
  self.callback = callback ;
  
  // setUp Imagepicker controller
  self.imagePicker = [[RBImagePickerController alloc] init];
  self.imagePicker.delegate = self;
  self.imagePicker.dataSource = self;
  self.imagePicker.selectionType = RBMultipleImageSelectionType;
  self.imagePicker.title = @"Custom Title";
  self.imagePicker.navigationController.navigationItem.leftBarButtonItem.title = @"no";
  
  // LAUNCH IMAGEPICKER
  dispatch_async(dispatch_get_main_queue(), ^{
    UIViewController *root = [[[[UIApplication sharedApplication] delegate] window] rootViewController];
    while (root.presentedViewController != nil) {
      root = root.presentedViewController;
    }
    [root presentViewController:self.imagePicker animated:YES completion:nil];
  });
  
  
}

-(void)imagePickerController:(RBImagePickerController *)imagePicker didFinishPickingImagesWithURL:(NSArray *)assets;{
     
     NSMutableArray* responseArray = [NSMutableArray new];
     for (ALAsset *asset in assets) {
       NSMutableDictionary* data = [NSMutableDictionary new];
       NSString* ext ;
       NSURL*imageURL = [[asset defaultRepresentation] url];
       
       if (imageURL && [[imageURL absoluteString] rangeOfString:@"ext=JPG"].location != NSNotFound) {
         ext = @"jpg" ;
       }
       else if (imageURL && [[imageURL absoluteString] rangeOfString:@"ext=PNG"].location != NSNotFound) {
         ext = @"png" ;
       }else if (imageURL && [[imageURL absoluteString] rangeOfString:@"ext=JPEG"].location != NSNotFound) {
         ext = @"jpeg" ;
       }
       // setting the extension of the image here
       [data setObject:ext forKey:@"ext"];
       
       UIImage* image ;
       
       ALAssetRepresentation *defaultRep = [asset defaultRepresentation];
       image = [UIImage imageWithCGImage:[defaultRep fullScreenImage] scale:[defaultRep scale] orientation:0];
       
       BOOL vertical = (image.size.width < image.size.height) ? YES : NO;
       [data setObject:@(vertical) forKey:@"isVertical"];
       
       NSData *imageData;
       if ([ext isEqualToString:@"png"]) {
         imageData = UIImagePNGRepresentation(image);
       }
       else {
         imageData = UIImageJPEGRepresentation(image, 0.6);
       }
       
       NSString *dataString = [imageData base64EncodedStringWithOptions:0]; // base64 encoded image string
       [data setObject:dataString forKey:@"data"];
       
       [responseArray addObject:data];
       
       
     }
     
    self.callback(@[responseArray]);

   
  
  }

-(void)imagePickerControllerDidCancel:(RBImagePickerController *)imagePicker{
  [self.imagePicker dismissViewControllerAnimated:true completion:^{
    self.callback(@[@{@"didCancel": @YES}]);
  }];
}

-(NSInteger)imagePickerControllerMaxSelectionCount:(RBImagePickerController *)imagePicker
{
  
  return MAX_NUMBER_SELECTION;
  
}

-(NSInteger)imagePickerControllerMinSelectionCount:(RBImagePickerController *)imagePicker
{
  
  return 0;
  
}
@end
