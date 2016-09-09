//
//  RBImageCollectionCell.m
//  RBImagePicker
//
//  Created by Roshan Balaji on 1/29/14.
//  Copyright (c) 2014 Uniq Labs. All rights reserved.
//

#import "RBImageCollectionCell.h"

#define CHECKMARK @"888-checkmark"

@interface  RBImageCollectionCell()



@end

@implementation RBImageCollectionCell



- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.assetImage = [[UIImageView alloc] init];
      
      //NSLog(@"width %f",[UIScreen mainScreen].bounds.size.width);
      CGFloat width_height = [UIScreen mainScreen].bounds.size.width/2 - 7 ;
      
        self.assetImage.frame = CGRectMake(1, 1, width_height, width_height);
        self.isSelected = false;
    }
    return self;
}

-(UIView*)countView:(CGRect)frame selected:(NSInteger)total{
  UIView* count = [UIView new];
  count.frame = frame;
  count.backgroundColor = [UIColor greenColor];
  
  UILabel* countLabel = [[UILabel alloc] init];
  countLabel.text = [NSString stringWithFormat:@"%ld",total];
  countLabel.center = count.center ; 
  
  [count addSubview:countLabel];
  return count ;
}

-(void)setImageAsset:(ALAsset *)imageAsset{
    
    _imageAsset = imageAsset;
    self.assetImage.image = [UIImage imageWithCGImage:[_imageAsset thumbnail]];
    
}

-(void)highlightCell{
  
  
 
    
    UIView *darkTint = [[UIView alloc] init];
    darkTint.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:.6];
    darkTint.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
  
  
  
  
  
    [self.contentView addSubview:darkTint];
    UIImageView *checkMark = [[UIImageView alloc] initWithImage:[UIImage imageNamed:CHECKMARK]];
    CGFloat width_height = [UIScreen mainScreen].bounds.size.width/2 - 7 ;
    checkMark.backgroundColor = [UIColor purpleColor];
    checkMark.frame = CGRectMake(width_height-30, width_height-30, 30, 30);
    [self.contentView addSubview:checkMark];

    
}


@end
