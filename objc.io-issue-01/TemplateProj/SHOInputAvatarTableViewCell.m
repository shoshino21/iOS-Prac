//
//  InputAvatarTableViewCell.m
//  TemplateProj
//
//  Created by shoshino21 on 12/26/16.
//  Copyright © 2016 shoshino21. All rights reserved.
//

#import "SHOInputAvatarTableViewCell.h"

static CGFloat const kMargin = 10.f;
static CGFloat const kAvatarLength = 60.f;

@interface SHOInputAvatarTableViewCell ()

@property (nonatomic, strong, readwrite) UIImageView *avatarImageView;

@end

@implementation SHOInputAvatarTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
  self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
  if (self) {
    _avatarImageView = [UIImageView new];
    _avatarImageView.clipsToBounds = YES;
    _avatarImageView.layer.cornerRadius = kAvatarLength / 2;
    [self addSubview:_avatarImageView];

    [_avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
      make.top.equalTo(self).offset(kMargin);
      make.bottom.equalTo(self).offset(-kMargin);
      make.width.equalTo(kAvatarLength);
      make.centerX.equalTo(self);
    }];
  }
  return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
  [super setSelected:selected animated:animated];
}

@end
