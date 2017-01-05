//
//  WelcomePageViewController.swift
//  zf
//
//  Created by waterway on 2016/12/16.
//  Copyright © 2016年 waterway. All rights reserved.
//

import UIKit

class WelcomePageViewController: UIViewController {

    var scrollView = UIScrollView()
    var pageControl = UIPageControl()
    let MaxNumber:Int = 4
    
    let startButton = UIButton()
    var timer:Timer?
    var startClosure:(()->Void)?

    func startAction(_ sender:UIButton){
        self.dismiss(animated: false, completion: nil)
        self.startClosure!()
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.white
        self.creatView()
        self.createPageControl()
        self.createButton()
        self.createTimer()
    }
    
    func createTimer(){
        let time:TimeInterval = 3
        self.timer = Timer.scheduledTimer(timeInterval: time, target: self, selector: #selector(scrollNext), userInfo: nil, repeats: true)
        RunLoop.current.add(timer!, forMode: .commonModes)
    }
    func scrollNext(){
        let index = Int(scrollView.contentOffset.x/ScreenWidth)
        if index == MaxNumber-1 {
            self.pageControl.currentPage = 0
            self.scrollView.contentOffset = CGPoint(x: CGFloat(0)*ScreenWidth, y: 0)
        }else {
            self.pageControl.currentPage = index
            self.scrollView.contentOffset = CGPoint(x: CGFloat(index+1)*ScreenWidth, y: 0)
            
        }
    }
    
    func createButton(){
        let imgBPath = Bundle.main.path(forResource: "welcomepage4_btn", ofType: "png")
        let imgBtn = UIImage(contentsOfFile: imgBPath!)
        self.startButton.frame = CGRect(x:0,y:0,width:180,height:44)
        self.startButton.center = CGPoint(x:ScreenWidth/2,y:ScreenHeight-130)
        self.startButton.setImage(imgBtn, for: .normal)
        self.view.addSubview(startButton)
        self.startButton.alpha = 0.0
        self.startButton.addTarget(self, action: #selector(startAction), for: UIControlEvents.touchDown)

    }

    func creatView() {
        scrollView = UIScrollView(frame: UIScreen.main.bounds)
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.bounces = false
        for i in 0...MaxNumber {
            var imageName = String()
            if i == MaxNumber{
                imageName = "welcomepage1"

            }else{
                imageName = "welcomepage\(i+1)"

            }
            
            let path = Bundle.main.path(forResource: imageName, ofType: "png")
            let image = UIImage(contentsOfFile: path!)
            let imageView = UIImageView(frame: CGRect(x: ScreenWidth*CGFloat(i), y: 0, width: ScreenWidth, height: ScreenHeight))
            imageView.image = image
            scrollView.addSubview(imageView)
            
            
        }
        
        scrollView.contentSize = CGSize(width: ScreenWidth*CGFloat(MaxNumber+1), height: ScreenHeight)
        
        scrollView.contentOffset = CGPoint(x: 0, y: 0)
        scrollView.isPagingEnabled = true
        scrollView.delegate = self
        self.view.addSubview(scrollView)
    }
    
    func createPageControl() {
        pageControl = UIPageControl(frame: CGRect(x: 0,y: ScreenHeight-50,width: ScreenWidth,height: 50))
        pageControl.numberOfPages = MaxNumber
        pageControl.currentPage = 0
        pageControl.isUserInteractionEnabled = false
        pageControl.currentPageIndicatorTintColor = UIColor.transform(fromHexString: "#089BF1")
        pageControl.pageIndicatorTintColor = UIColor.transform(fromHexString: "#089B88")
        pageControl.alpha = 0.5
        self.view.addSubview(pageControl)
        
        
        
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var prefersStatusBarHidden: Bool{
        self.navigationController?.navigationBar.isHidden = true
        return true
    }

}

extension WelcomePageViewController:UIScrollViewDelegate{
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let index = Int(scrollView.contentOffset.x/ScreenWidth)
        if index == MaxNumber {
            pageControl.currentPage = 0
            scrollView.contentOffset = CGPoint(x: CGFloat(0)*ScreenWidth, y: 0)
        }else {
            pageControl.currentPage = index
            scrollView.contentOffset = CGPoint(x: CGFloat(index)*ScreenWidth, y: 0)

        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset = scrollView.contentOffset
        // 随着滑动改变pageControl的状态
        pageControl.currentPage = Int(offset.x / view.bounds.width)
        // 因为currentPage是从0开始，所以numOfPages减1
        if pageControl.currentPage == MaxNumber-1 {
            UIView.animate(withDuration: 0.5, animations: {
                self.startButton.alpha = 1.0
            })
        } else {
            UIView.animate(withDuration: 0.2, animations: {
                self.startButton.alpha = 0.0
            })
        }
    }
    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView){
        self.timer?.invalidate()
    }
    public func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>){
        self.createTimer()
    }

}
