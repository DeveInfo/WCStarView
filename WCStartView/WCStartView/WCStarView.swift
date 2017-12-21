//
//  WCStarView.swift
//  WCStartView
//
//  Created by 工作 on 2017/12/19.
//  Copyright © 2017年 工作. All rights reserved.
//

import UIKit
enum RateStyle
{
    case WholeStar //整星
    case HalfStar  //半星
    case IncompleteStar
}
typealias swiftBlock = (_ startView: WCStarView , _ score:Float) -> Void
class WCStarView: UIView
{

    
//    static let share = WCStarView.init()
//    private init(){}
    private let ForegroundStarImage = "b27_icon_star_yellow"
    private let BackgroundStarImage = "b27_icon_star_gray"
    public var startNum = 5
    public var rateStyle:RateStyle = .IncompleteStar
    public var isAnimate:Bool = true
    weak var delegate:WCStarRateViewDelegate?
    var callBack: swiftBlock?
    public var currentScore:Float = 5
    {
        didSet
        {
            
            delegate?.wcstartViewDelegate(startView: self, currentScore: currentScore)
            self.callBack?(self , currentScore)
            self.setNeedsLayout()
        }
    }
    
    override func awakeFromNib()
    {
        super .awakeFromNib()
        self.createStartView()
    }
    
    public convenience init(frame:CGRect,startNum:NSInteger, rateStyle:RateStyle,isAnimate:Bool,swiftBlock:@escaping swiftBlock) {
        self.init(frame: frame)
        self.startNum = startNum
        self.rateStyle = rateStyle
        self.isAnimate = isAnimate
        self.callBack = swiftBlock
        self.createStartView()
    }
    
    lazy var foregroundStarView :UIView = {
        let foregroundStarView = self.createView(ForegroundStarImage as NSString)
        foregroundStarView.clipsToBounds = true;
        self.addSubview(self.backgroundStarView)
        self.addSubview(foregroundStarView)
        return foregroundStarView
    }()
    
    lazy var backgroundStarView :UIView = {
        let backgroundStarView = self.createView(BackgroundStarImage as NSString)
        backgroundStarView.clipsToBounds = true
        return backgroundStarView
    }()
   
    func createStartView() -> Void
    {
        let tap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action:#selector(tapgestAction(tap:)))
        
        self.addGestureRecognizer(tap)
        
        let pan:UIPanGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(tapgestAction(tap:)))
        
        self.addGestureRecognizer(pan)
        
    }
    
    func createView(_ imagename:NSString) -> UIView
    {
        let view:UIView = UIView(frame: self.bounds)
        view.clipsToBounds = true;
        
        for num in 0...(startNum - 1)
        {
            let imageView = UIImageView(image: UIImage(named: imagename as String))
            imageView.frame = CGRect(x: CGFloat(num) * CGFloat(view.bounds.size.width) / CGFloat(startNum), y: 0, width: CGFloat(view.bounds.size.width) / CGFloat(startNum), height: view.bounds.size.height)
            imageView.contentMode = UIViewContentMode.scaleAspectFit
            view.addSubview(imageView)
        }
        return view
    }
    
    @objc func tapgestAction(tap:UIGestureRecognizer) -> Void
    {
        let point:CGPoint = tap.location(in: self)
        var offset:Float = Float(point.x)
        if offset <= 0
        {
            offset = 0;
        }
        
        if offset >= Float(self.bounds.size.width)
        {
            offset = Float(self.bounds.size.width)
        }
        
        let realScore:Float = Float(offset / Float(self.bounds.size.width) * Float(startNum))
        
        switch rateStyle {
        case .WholeStar:
            self.currentScore = ceil(realScore)
        case .HalfStar:
            self.currentScore = roundf(Float(realScore)) >= Float(realScore) ? ceilf(realScore) : (ceilf(realScore) - 0.5)
        default:
            self.currentScore = realScore
        }
    }
    
    override func layoutSubviews()
    {
        super.layoutSubviews()
        let animationTimeInterval = isAnimate ? 0.2 : 0;
        UIView.animate(withDuration: animationTimeInterval) {
            self.foregroundStarView.frame = CGRect(x: 0.0, y: 0.0, width: CGFloat(self.bounds.size.width) * CGFloat(self.currentScore) / CGFloat(self.startNum), height: CGFloat(self.bounds.size.height))
        }
    }
    
}

protocol WCStarRateViewDelegate : NSObjectProtocol
{
    func wcstartViewDelegate(startView:WCStarView ,currentScore:Float)
}
