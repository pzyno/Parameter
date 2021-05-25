//
//  ViewController.m
//  PerameterDemo_iOS
//
//  Created by 彭之耀 on 2021/5/25.
//

#import "ViewController.h"
#import "Person.h"

@interface ViewController ()
{
    dispatch_source_t _timer;
    Person *_zs;
}
@property (weak, nonatomic) IBOutlet UITextField *nameTF;
@property (weak, nonatomic) IBOutlet UITextField *addressTF;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    NSLog(@"全局变量地址:%p",_zs);
    Person *p = [[Person alloc] init];
    p.name = @"张三";
    p.address = @"聚贤路";
    _zs = p;
    NSLog(@"原始地址:%p",p);
    NSLog(@"全局变量地址:%p",_zs);
    [self say:p];
    self.nameTF.text = p.name;
    self.addressTF.text = p.address;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self stopTimer];
}

- (IBAction)change:(UIButton *)sender {
    _zs.name = self.nameTF.text;
    _zs.address = self.addressTF.text;
    
    
}



-(void)say:(Person *)p
{
    NSLog(@"形参地址:%p",p);
    
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_global_queue(0, 0));
    dispatch_source_set_timer(timer, DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
    dispatch_source_set_event_handler(timer, ^{
        NSLog(@"OC---name:%@    addresss:%@\n",p.name,p.address);
    });
    dispatch_resume(timer);
    _timer = timer;
    
}


-(void)stopTimer
{
    dispatch_source_cancel(_timer);
    _timer = nil;
}


@end
