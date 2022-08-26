//
//  ViewController.m
//  Demo16
//
//  Created by vfa on 8/26/22.
//

#import "ViewController.h"

@interface ViewController ()
@property (nonatomic,strong) UISwipeGestureRecognizer *swipe;
@property (nonatomic,strong) UIRotationGestureRecognizer *rotation;
@property (nonatomic,strong) UIPanGestureRecognizer *pan;
@property (nonatomic,strong) UILongPressGestureRecognizer *longPress;
@property (nonatomic,strong) UITapGestureRecognizer *tap;
@property (nonatomic,strong) UIPinchGestureRecognizer *pinch;

@property (nonatomic,strong) UILabel *label;
@property (nonatomic,unsafe_unretained) CGFloat rotationAngleRadians;

@property (nonatomic,unsafe_unretained) CGFloat currentScale;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.label = [[UILabel alloc] initWithFrame:CGRectZero];
    
    self.label.text = @"Hello world";
    self.label.font = [UIFont systemFontOfSize:30];
    [self.label sizeToFit];
    self.label.center = self.view.center;
    self.label.userInteractionEnabled = YES;
    [self.view addSubview:self.label];
    
    [self createSwipe];
    [self createRotation];
    [self createPan];
    [self createLongPress];
    [self createTap];
    [self createPinch];
    // Do any additional setup after loading the view.
}
-(void) createSwipe{
    
    self.swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    //swipe to left
    self.swipe.direction = UISwipeGestureRecognizerDirectionLeft;
    
    self.swipe.numberOfTouchesRequired = 1;
    
    [self.view addGestureRecognizer:self.swipe];
    
}

-(void) handleSwipe: (UISwipeGestureRecognizer *)sender{
    
    if(sender.direction & UISwipeGestureRecognizerDirectionDown){
        NSLog(@"Swipe down");
    }
    if(sender.direction & UISwipeGestureRecognizerDirectionLeft){
        NSLog(@"Swipe left");
    }
    if(sender.direction & UISwipeGestureRecognizerDirectionRight){
        NSLog(@"Swipe right");
    }
    if(sender.direction & UISwipeGestureRecognizerDirectionUp){
        NSLog(@"Swipe up");
    }
}

-(void) createRotation{
    
    self.rotation = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(handleRotation:)];
    
    [self.view addGestureRecognizer:self.rotation];
}

-(void) handleRotation:(UIRotationGestureRecognizer *) sender{
    if(self.label == nil){
        return;
        
    }
    self.label.transform = CGAffineTransformMakeRotation(self.rotationAngleRadians+sender.rotation);
    
    if(sender.state == UIGestureRecognizerStateEnded){
        self.rotationAngleRadians +=sender.rotation;
    }
}
-(void) createPan{
    
    self.pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    self.pan.minimumNumberOfTouches=1;
    self.pan.maximumNumberOfTouches=1;
    [self.label addGestureRecognizer:self.pan];
}

-(void) handlePan:(UIPanGestureRecognizer *) sender{
    if(self.label == nil){
        return;
        
    }
    if(sender.state != UIGestureRecognizerStateEnded &&sender.state != UIGestureRecognizerStateFailed){
        CGPoint location = [sender locationInView:sender.view.superview];
        sender.view.center = location;
    }
    
}

-(void) createLongPress{
    
    self.longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
    self.longPress.numberOfTouchesRequired = 2;
    self.longPress.minimumPressDuration = 1.0;
    
    [self.label addGestureRecognizer:self.longPress];
}

-(void) handleLongPress:(UILongPressGestureRecognizer *) sender{
    if(self.label == nil){
        return;
        
    }
    if([sender isEqual:self.longPress]){
        if(sender.numberOfTouchesRequired == 2){
            NSLog(@"Long Press");
            self.label.textColor = UIColor.redColor;
        }
    }
    
}

-(void) createTap{
    
    self.tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    self.tap.numberOfTouchesRequired =2;
    self.tap.numberOfTapsRequired= 3;
    
    [self.view addGestureRecognizer:self.tap];
}

-(void) handleTap:(UITapGestureRecognizer * )sender{
    
    NSInteger counter =0;
    for (counter = 0; counter<sender.numberOfTouchesRequired; counter++) {
        CGPoint touchPoint = [sender locationOfTouch:counter inView:sender.view];
        NSLog(@"Touch #%lu: %@",counter+1,NSStringFromCGPoint(touchPoint));
    }
}
-(void) createPinch{
    self.pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinch:)];
    [self.label addGestureRecognizer:self.pinch];
}

-(void) handlePinch:(UIPinchGestureRecognizer *) sender{
    
    if(sender.state ==UIGestureRecognizerStateEnded){
        self.currentScale = sender.scale;
    }else if (sender.state == UIGestureRecognizerStateBegan && self.currentScale != 0.0f){
        sender.scale = self.currentScale;
    }
    if(sender.scale != NAN && sender.scale !=0){
        self.label.transform = CGAffineTransformMakeScale(sender.scale, sender.scale);
    }
}
@end
