//
//  AlertMessage.m
//  MicroFinance
//
//  Created by SPMach on 7/14/14.
//  Copyright (c) 2014 SPMach. All rights reserved.
//

#import "AlertMessage.h"

@implementation AlertMessage (Private)

-(void)_doneShowAlert{
    
    [_alertView dismissWithClickedButtonIndex:0 animated:YES];
}

@end

@implementation AlertMessage

@dynamic alertMessageConfirmCompletionBlock;
@dynamic alertMessageCancelCompletionBlock;
@dynamic alertMessageContinueCompletionBlock;
@synthesize mode = _alertType;

#pragma mark
#pragma mark - lifeCycle
-(id)initWithTitle:(NSString *)title
              mode:(AlertMessageType)mode
           message:(NSString *)message
          delegate:(id)delegate
confirmCompleteSelector:(SEL)sel
cancelCompleteSelector:(SEL)sel2
 cancelButtonTitle:(NSString *)cancelButtonTitle
 otherButtonTitles:(NSString *)otherButtonTitles, ...{

    if (self = [super init]) {
        
        if ((_alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:cancelButtonTitle otherButtonTitles:otherButtonTitles, nil])) {
            
            _alertType = mode;
            _delegate = delegate;
            if (sel) {
                _alertMessageConfirmCompleteSelector = sel;
            }
            if (sel2) {
                _alertMessageCancelCompleteSelector = sel2;
            }
        }
    }
    return self;
}
-(id)initWithTitle:(NSString *)title
              mode:(AlertMessageType)mode
           message:(NSString *)message
          delegate:(id)delegate
 confirmCompletion:(void (^)(void))completion
  cancelCompletion:(void (^)(void))completion2
 cancelButtonTitle:(NSString *)cancelButtonTitle
 otherButtonTitles:(NSString *)otherButtonTitles, ...{

    if (self = [super init]) {
        
        if ((_alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:cancelButtonTitle otherButtonTitles:otherButtonTitles, nil])) {

            _alertType = mode;
            _delegate = delegate;
            if (completion) {
                if (_alertMessageConfirmCompletionBlock) {
                    Block_release((__bridge void *)_alertMessageConfirmCompletionBlock);
                    _alertMessageConfirmCompletionBlock = nil;
                }
                _alertMessageConfirmCompletionBlock = (__bridge id)Block_copy((__bridge void *)completion);
            }
            if (completion2) {
                if (_alertMessageCancelCompletionBlock) {
                    Block_release((__bridge void *)_alertMessageCancelCompletionBlock);
                    _alertMessageCancelCompletionBlock = nil;
                }
                _alertMessageCancelCompletionBlock = (__bridge id)Block_copy((__bridge void *)completion2);
            }
        }
    }
    return self;
}
-(id)initWithTitle:(NSString *)title
              mode:(AlertMessageType)mode
           message:(NSString *)message
          delegate:(id)delegate
 confirmCompletion:(void (^)(void))completion
  cancelCompletion:(void (^)(void))completion2
continueCompletion:(void (^)(void))completion3
 cancelButtonTitle:(NSString *)cancelButtonTitle
 otherButtonTitle1:(NSString *)otherButtonTitle1
 otherButtonTitle2:(NSString *)otherButtonTitle2, ...{

    if (self = [super init]) {
        
        if ((_alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:cancelButtonTitle otherButtonTitles:otherButtonTitle1,otherButtonTitle2, nil])) {
            
            _alertType = mode;
            _delegate = delegate;
            if (completion) {
                if (_alertMessageConfirmCompletionBlock) {
                    Block_release((__bridge void *)_alertMessageConfirmCompletionBlock);
                    _alertMessageConfirmCompletionBlock = nil;
                }
                _alertMessageConfirmCompletionBlock = (__bridge id)Block_copy((__bridge void *)completion);
            }
            if (completion2) {
                if (_alertMessageCancelCompletionBlock) {
                    Block_release((__bridge void *)_alertMessageCancelCompletionBlock);
                    _alertMessageCancelCompletionBlock = nil;
                }
                _alertMessageCancelCompletionBlock = (__bridge id)Block_copy((__bridge void *)completion2);
            }
            if (completion3) {
                if (_alertMessageContinueCompletionBlock) {
                    Block_release((__bridge void *)_alertMessageContinueCompletionBlock);
                    _alertMessageContinueCompletionBlock = nil;
                }
                _alertMessageContinueCompletionBlock = (__bridge id)Block_copy((__bridge void *)completion3);
            }
        }
    }
    return self;
}
-(void)dealloc{
    
    if (_alertMessageConfirmCompletionBlock) {
        Block_release((__bridge void *)_alertMessageConfirmCompletionBlock);
        _alertMessageConfirmCompletionBlock = nil;
    }
    if (_alertMessageCancelCompletionBlock) {
        Block_release((__bridge void *)_alertMessageCancelCompletionBlock);
        _alertMessageCancelCompletionBlock = nil;
    }
    if (_alertMessageContinueCompletionBlock) {
        Block_release((__bridge void *)_alertMessageContinueCompletionBlock);
        _alertMessageContinueCompletionBlock = nil;
    }
    [_alertView release];
    [self release];
    [super dealloc];
}


#pragma mark
#pragma mark - public
-(void)show{

    [_alertView show];
    [self retain];
}
-(void)showForSeconds:(float)sec{

    [_alertView show];
    [self performSelector:@selector(_doneShowAlert) withObject:nil afterDelay:sec];
    _autoCompletion = YES;
    [self retain];
}


#pragma mark
#pragma mark - alertView
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (alertView == _alertView) {
        
        if (_delegate && [_delegate respondsToSelector:@selector(alertMessage:clickedButtonAtIndex:)]) {
            
            [_delegate alertMessage:self clickedButtonAtIndex:buttonIndex];
            
            if (buttonIndex == 0) {
                
                if (_alertType == AlertMessageTypeAlert) {
                    
                    if (_alertMessageConfirmCompletionBlock) {
                        _alertMessageConfirmCompletionBlock();
                    }
                    if (_alertMessageConfirmCompleteSelector) {
                        [_delegate performSelector:_alertMessageConfirmCompleteSelector withObject:nil];
                    }
                }
                else if (_alertType == AlertMessageTypeDecision) {
                    
                    if (_alertMessageCancelCompletionBlock) {
                        _alertMessageCancelCompletionBlock();
                    }
                    if (_alertMessageCancelCompleteSelector) {
                        [_delegate performSelector:_alertMessageCancelCompleteSelector withObject:nil];
                    }
                }
            }
            else if (buttonIndex == 1) {
                
                if (_alertType == AlertMessageTypeDecision) {
                    
                    if (_alertMessageContinueCompletionBlock) {
                        _alertMessageContinueCompletionBlock();
                    }
                    else {
                        
                        if (_alertMessageConfirmCompletionBlock) {
                            _alertMessageConfirmCompletionBlock();
                        }
                        if (_alertMessageConfirmCompleteSelector) {
                            [_delegate performSelector:_alertMessageConfirmCompleteSelector withObject:nil];
                        }
                    }
                }
            }
            else {
                
                if (_alertType == AlertMessageTypeDecision) {
                    
                    if (_alertMessageConfirmCompletionBlock) {
                        _alertMessageConfirmCompletionBlock();
                    }
                    if (_alertMessageConfirmCompleteSelector) {
                        [_delegate performSelector:_alertMessageConfirmCompleteSelector withObject:nil];
                    }
                }
            }
        }
    }
}
-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{
    
    if (alertView == _alertView) {
        
        if (_autoCompletion) {
            
            if (!_delegate) {
                return;
            }
//            && [_delegate respondsToSelector:@selector(alertMessage:clickedButtonAtIndex:)]
            if (_delegate ) {
                
//                [_delegate alertMessage:self clickedButtonAtIndex:buttonIndex];
                
                if (buttonIndex == 0) {
                    
                    if (_alertType == AlertMessageTypeAlert) {
                        
                        if (_alertMessageConfirmCompletionBlock) {
                            _alertMessageConfirmCompletionBlock();
                        }
                        if (_alertMessageConfirmCompleteSelector) {
                            [_delegate performSelector:_alertMessageConfirmCompleteSelector withObject:nil];
                        }
                    }
                    else if (_alertType == AlertMessageTypeDecision) {
                        
                        if (_alertMessageCancelCompletionBlock) {
                            _alertMessageCancelCompletionBlock();
                        }
                        if (_alertMessageCancelCompleteSelector) {
                            [_delegate performSelector:_alertMessageCancelCompleteSelector withObject:nil];
                        }
                    }
                }
                else {
                    
                    if (_alertType == AlertMessageTypeDecision) {
                        
                        if (_alertMessageConfirmCompletionBlock) {
                            _alertMessageConfirmCompletionBlock();
                        }
                        if (_alertMessageConfirmCompleteSelector) {
                            [_delegate performSelector:_alertMessageConfirmCompleteSelector withObject:nil];
                        }
                    }
                }
            }
        }
    }
}


@end



















