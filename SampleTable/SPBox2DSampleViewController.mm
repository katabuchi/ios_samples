//
//  SPBox2DSampleViewController.m
//  SampleTable
//
//  Created by 片淵 雄介 on 13/07/19.
//  Copyright (c) 2013年 Yusuke. All rights reserved.
//

#import "SPBox2DSampleViewController.h"

@interface SPBox2DSampleViewController ()

@end

@implementation SPBox2DSampleViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self.view setBackgroundColor:[UIColor whiteColor]];
        [self.navigationItem setTitle:@"Box2D"];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self _timeManager];
    [self _createView];
    UIGestureRecognizer *gesture;
    gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped:)];
    [self.view addGestureRecognizer:gesture];
}

//時間を経過させる　物理ワールドの時間を進める
- (void)_timeManager
{
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0/60.0 target:self selector:@selector(step:) userInfo:nil repeats:YES];
}

- (void)_createView
{
    //スクリーンのサイズを取得
    CGSize screenSize = [[UIScreen mainScreen] bounds].size;
    
    //物理ワールドを生成
    b2Vec2 gravity;
    gravity.Set(0.0f, -9.82f);
    world = new b2World(gravity);
    world -> SetContinuousPhysics(true);
    //壁の剛体を定義
    b2BodyDef edgeBodyDef;
    edgeBodyDef.position.Set(0, 0);
    
    //壁の剛体を生成
    b2Body *edgeBody = world -> CreateBody(&edgeBodyDef);
    
    //壁の形状を設定
    b2EdgeShape edgeShape;
    float32 widthByMeter = screenSize.width / kPointMeter;
    float32 heightByMeter = screenSize.height / kPointMeter;
    
    //下
    edgeShape.Set(b2Vec2(0, 0), b2Vec2(widthByMeter, 0));
    edgeBody -> CreateFixture(&edgeShape, 0);
    
    //上
    edgeShape.Set(b2Vec2(0, heightByMeter), b2Vec2(widthByMeter, heightByMeter));
    edgeBody -> CreateFixture(&edgeShape, 0);
    
    //左
    edgeShape.Set(b2Vec2(0, heightByMeter), b2Vec2(0, 0));
    edgeBody -> CreateFixture(&edgeShape, 0);
    
    //右
    edgeShape.Set(b2Vec2(widthByMeter, heightByMeter), b2Vec2(widthByMeter,0));
    edgeBody -> CreateFixture(&edgeShape, 0);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)step:(NSTimer *)timer
{
    //物理ワールドの時間を進める
    int32 velocityIterations = 8;
    int32 positionIterations = 1;
    
    world -> Step(1.0f/60.f, velocityIterations, positionIterations);
    
    //UIViewオブジェクトを剛体にあわせて移動、回転させる
    CGFloat screenHeight = self.view.bounds.size.height;
    for(b2Body *aBody = world->GetBodyList(); aBody; aBody = aBody->GetNext()){
        if(aBody->GetUserData() == NULL){
            continue;
        }
        
        //剛体のuserDataに格納されているUIViewオブジェクトへのポインタを取得
        UIView *aView = (__bridge UIView *)aBody->GetUserData();
        
        //剛体の現在位置に合わせUIViewオブジェクトを移動させる
        b2Vec2 bodyPos = aBody -> GetPosition();
        CGFloat newCenterX = bodyPos.x * kPointMeter;
        CGFloat newCenterY = screenHeight - bodyPos.y * kPointMeter;
        aView.center = CGPointMake(newCenterX, newCenterY);
        
        //剛体の現在の角度に合わせてUIViewオブジェクトを回転させる
        CGAffineTransform transform;
        transform = CGAffineTransformMakeRotation(-aBody->GetAngle());
        aView.transform = transform;
    }
}

- (void)tapped:(UITapGestureRecognizer *)gesture
{
    CGRect frame = CGRectMake(0, 0, 50, 30);
    UIView *physicalView = [[UIView alloc] initWithFrame:frame];
    physicalView.backgroundColor = [UIColor colorWithRed:0.0
                                                   green:204.0/255.0
                                                    blue:1.0
                                                   alpha:1.0];
    [self.view addSubview:physicalView];
    
    CGPoint tappedPos = [gesture locationInView:gesture.view];
    physicalView.center = tappedPos;
    
    [self addPhysicalBodyFromView:physicalView];
}

#pragma mark -
#pragma mark ---- make Physical Body ----
//引数に渡されたUIViewに対して剛体を作る
- (void)addPhysicalBodyFromView:(UIView *)physicalView
{
    CGSize screenSize = self.view.bounds.size;
    //剛体の中央
    CGPoint pos = physicalView.center;
    CGSize physicalSize = physicalView.bounds.size;
    
    //剛体を定義
    b2BodyDef bodyDef;
    bodyDef.type = b2_dynamicBody;
    bodyDef.position.Set(pos.x / kPointMeter, (screenSize.height - pos.y) / kPointMeter);
    bodyDef.userData = (__bridge void *)physicalView;
    
    //剛体を生成
    b2Body *body = world -> CreateBody(&bodyDef);
    
    //剛体の形状
    b2PolygonShape dynamicBox;
    CGFloat boxHalfWidth = physicalSize.width / kPointMeter / 2.0;
    CGFloat boxHalfHeight = physicalSize.height / kPointMeter / 2.0;
    dynamicBox.SetAsBox(boxHalfWidth, boxHalfHeight);
    
    //形状と各種パラメーターを剛体にセット
    b2FixtureDef fixtureDef;
    fixtureDef.shape = &dynamicBox;
    fixtureDef.density = 3.0f;
    fixtureDef.restitution = 0.5f;
    body -> CreateFixture(&fixtureDef);
}



@end
