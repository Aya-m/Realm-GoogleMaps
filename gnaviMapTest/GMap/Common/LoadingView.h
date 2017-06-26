#import <UIKit/UIKit.h>

@interface LoadingView : UIView

// 通信中に表示するラベルのテキストを設定
- (void)setLodingTitle:(NSString *)title;
// インディケーターのアニメーションを開始する
- (void)startIndicator;
// インディケーターのアニメーションを停止する
- (void)stopIndicator;

@end
