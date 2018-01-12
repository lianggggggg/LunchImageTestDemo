//
//  AppDelegate.swift
//  LunchImageTestDemo
//
//  Created by MrLiang on 2018/1/11.
//  Copyright © 2018年 MrLiang. All rights reserved.
//

import UIKit


let KSCREENWIDTH = UIScreen.main.bounds.width
let KSCREENHEIGHT = UIScreen.main.bounds.height



@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, CAAnimationDelegate {

    var window: UIWindow?

//    var animation:CABasicAnimation?
    
    lazy var pointView:UIView = {
        let view = UIView()
        view.frame = CGRect.init(x: 5, y: KSCREENHEIGHT - 250, width: 50, height: 50)
        view.backgroundColor = UIColor.white
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 25
        return view
    }()
    
    
    lazy var logoImageView:UIImageView = {
        let imageview = UIImageView.init()
        imageview.frame = CGRect.init(x: (KSCREENWIDTH-300)/2, y: (KSCREENHEIGHT-150)/2, width: 300, height: 150)
        imageview.image = UIImage.init(named: "splash_logo")
        imageview.alpha = 0
        return imageview
    }()
    

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        self.window = UIWindow.init(frame: UIScreen.main.bounds)
        self.window?.backgroundColor = .white
        self.window?.rootViewController = ViewController()
        self.window?.makeKeyAndVisible()
        
        customLaunchImageView()
        
        
        return true
    }
    
    
    func customLaunchImageView(){
        
        let launchImageView = UIImageView.init(frame: self.window!.bounds)
        launchImageView.image = getLaunchImage()
        
        self.window?.addSubview(launchImageView)
        self.window?.bringSubview(toFront: launchImageView)
        
        launchImageView.addSubview(pointView)
        launchImageView.addSubview(logoImageView)
        
        pathAnimation()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2), execute: {[weak self] () -> () in
            
            self?.pointView.alpha = 0
            
            UIView.animate(withDuration: 0.3, animations: {[weak self] () -> () in
                self?.logoImageView.alpha = 1
            })
            
            UIView.animate(withDuration: 0.8, animations: {[weak self] () -> () in
                launchImageView.alpha = 0
                self?.logoImageView.alpha = 1
                launchImageView.transform = CGAffineTransform.init(scaleX: 1.2, y: 1.2)
            }, completion: { (finished) in
                launchImageView.removeFromSuperview()
            })
            
        })
        
    }
    
    func pathAnimation(){
        //画轨迹
        
        let myPath = CGMutablePath()
        myPath.move(to: CGPoint.init(x: 30, y: KSCREENHEIGHT - 250)) //最后的位置
        myPath.addLine(to: CGPoint.init(x: KSCREENWIDTH/6, y: KSCREENHEIGHT - 100))
        myPath.addLine(to: CGPoint.init(x: KSCREENWIDTH/3, y: /*KSCREENHEIGHT - 200*/100))
        myPath.addLine(to: CGPoint.init(x: KSCREENWIDTH/2, y: KSCREENHEIGHT - 100))
        
        myPath.addLine(to: CGPoint.init(x: KSCREENWIDTH, y: 0))
        myPath.addLine(to: CGPoint.init(x: 0, y: 0))
        myPath.addLine(to: CGPoint.init(x: KSCREENWIDTH/2, y: KSCREENHEIGHT/2))
        pointView.layer.add(keyFrameAnimation(myPath, time: 1.4, repeatTimes: MAXFLOAT), forKey: nil)
        
    }
    
    func keyFrameAnimation(_ path:CGMutablePath,time:Double,repeatTimes:Float) -> CAKeyframeAnimation{
        
        let animation = CAKeyframeAnimation.init(keyPath: "position")
        animation.path = path
        animation.timingFunctions = [CAMediaTimingFunction.init(name: kCAMediaTimingFunctionEaseIn)]
//        animation.autoreverses = false  //是否
        animation.duration = time
        animation.delegate = self
        animation.isRemovedOnCompletion = false
        animation.fillMode = kCAFillModeForwards
        animation.repeatCount = 1 //循环次数
        return animation
    }
    
    
    //获取launchImage
    func getLaunchImage() -> UIImage?{
        
        var lanchImage:UIImage? = nil
        var viewOrientation:String? = nil
        let viewSize = UIScreen.main.bounds.size
        let orientation = UIApplication.shared.statusBarOrientation
        
        if orientation == .landscapeLeft || orientation == .landscapeRight {
            viewOrientation = "Landscape"
        }else{
            viewOrientation = "Portrait"
        }
        
        let imagesDictionaryArr = Bundle.main.infoDictionary!["UILaunchImages"] as? [NSDictionary] ?? []
        
        
        for dic in imagesDictionaryArr {
            let imageSize = CGSizeFromString(dic["UILaunchImageSize"] as? String ?? "")
            if __CGSizeEqualToSize(imageSize, viewSize) && (viewOrientation == (dic["UILaunchImageOrientation"] as? String ?? "")){
                lanchImage = UIImage.init(named: dic["UILaunchImageName"] as? String ?? "")
            }
        }
        return lanchImage
    }
    
    //MARK:CAAnimationDelegate
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        print("动画结束")
        addlat()
    }
    
    func addlat(){
        
        let opacityAnimation = CABasicAnimation.init(keyPath: "opacity")
        opacityAnimation.fromValue = NSNumber.init(value: 1.0)
        opacityAnimation.toValue = NSNumber.init(value: 0.0)
        opacityAnimation.duration = 1.5
        opacityAnimation.autoreverses = false
        opacityAnimation.repeatCount = 1
        
        
        let animation2 = CABasicAnimation.init(keyPath: "transform.scale")
        animation2.fromValue = NSNumber.init(value: 0.9)
        animation2.toValue = NSNumber.init(value: 10)
        animation2.duration = 1.5
        animation2.autoreverses = false
        animation2.repeatCount = 1
        
        pointView.layer.add(animation2, forKey: "scale")
        pointView.layer.add(opacityAnimation, forKey: nil)
    }
    
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

}

