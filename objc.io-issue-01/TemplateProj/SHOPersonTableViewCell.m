//
//  PersonTableViewCell.m
//  TemplateProj
//
//  Created by shoshino21 on 12/26/16.
//  Copyright © 2016 shoshino21. All rights reserved.
//

#import "SHOPersonTableViewCell.h"

static CGFloat const kMargin = 10.f;
static CGFloat const kAvatarLength = 60.f;
static CGFloat const kNameFontSize = 20.f;
static CGFloat const kBirthFontSize = 16.f;

@interface SHOPersonTableViewCell ()

@property (nonatomic, strong, readwrite) UIImageView *avatarImageView;
@property (nonatomic, strong, readwrite) UILabel *nameLabel;
@property (nonatomic, strong, readwrite) UILabel *birthLabel;

@end

@implementation SHOPersonTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
  self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
  if (self) {
    _avatarImageView = [UIImageView new];
    _avatarImageView.clipsToBounds = YES;
    _avatarImageView.layer.cornerRadius = kAvatarLength / 2;
    [self addSubview:_avatarImageView];

    _nameLabel = [UILabel new];
    _nameLabel.font = [UIFont systemFontOfSize:kNameFontSize];
    _nameLabel.textColor = [UIColor blackColor];
    _nameLabel.numberOfLines = 2;
    [self addSubview:_nameLabel];

    _birthLabel = [UILabel new];
    _birthLabel.font = [UIFont systemFontOfSize:kBirthFontSize];
    _birthLabel.textColor = [UIColor darkGrayColor];
    _birthLabel.numberOfLines = 1;
    _birthLabel.textAlignment = NSTextAlignmentRight;
    [self addSubview:_birthLabel];

//    _avatarImageView.backgroundColor = [UIColor greenColor];
//    _nameLabel.backgroundColor = [UIColor greenColor];
//    _birthLabel.backgroundColor = [UIColor greenColor];

    [self addConstraints];
  }
  return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
  [super setSelected:selected animated:animated];
}

- (void)addConstraints {
  [_avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.top.and.left.mas_equalTo(self).offset(kMargin);
    make.bottom.equalTo(self).offset(-kMargin);
    make.width.equalTo(kAvatarLength);
  }];

  [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.equalTo(_avatarImageView.right).offset(kMargin);
    make.right.equalTo(_birthLabel.left).offset(-kMargin);
    make.centerY.equalTo(self);
  }];

  [_birthLabel mas_makeConstraints:^(MASConstraintMaker *make) {
    make.right.equalTo(self).offset(-kMargin);
    make.centerY.equalTo(self);
  }];

  [_nameLabel setContentCompressionResistancePriority:UILayoutPriorityDefaultLow
                                              forAxis:UILayoutConstraintAxisHorizontal];
  [_birthLabel setContentCompressionResistancePriority:UILayoutPriorityDefaultHigh
                                               forAxis:UILayoutConstraintAxisHorizontal];
}

@end
