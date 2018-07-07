//
//  MZFlashCardPackChooserTableViewCell.m
//  MZFlashCard
//
//  Created by Zalan Mergl on 2018. 06. 29..
//

#import "MZFlashCardPackChooserTableViewCell.h"

@implementation MZFlashCardPackChooserTableViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    UIView* backgroundView = [UIView new];
    backgroundView.backgroundColor = [UIColor colorWithWhite:1.0f alpha:0.1f];
    
    self.selectedBackgroundView = backgroundView;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
