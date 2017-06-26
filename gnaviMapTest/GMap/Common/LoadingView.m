#import "LoadingView.h"

@interface LoadingView ()

@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UIActivityIndicatorView *indicator;

@end

@implementation LoadingView

- (void)awakeFromNib {
    [super awakeFromNib];
    self.hidden = YES;
}

- (void)setLodingTitle:(NSString *)title {
    self.titleLabel.text = title;
}

- (void)startIndicator {
    [self.indicator startAnimating];
    self.hidden = NO;
}

- (void)stopIndicator {
    [self.indicator stopAnimating];
    // 完了状態にする
    self.hidden = YES;
}

@end
