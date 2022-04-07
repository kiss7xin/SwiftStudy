//
//  TabCardView.swift
//  EnterpriseUniversity
//
//  Created by weixin on 2022/1/24.
//

import Foundation
import UIKit

protocol SKTabCardViewDelegate {
    func tabCardViewCurrentIndex(index: NSInteger)
}

class SKTabBaseCardView: UIView {}

class SKTabCardView: UIView {
    
    let kCardViewNoDataString: String = "kCardViewNoDataString"
    /// 卡片内容数组
    var cards: [SKTabBaseCardView] = []
    /// 是否展示无数据占位view
    private var _isShowNoDataView = false
    var isShowNoDataView: Bool = false {
        didSet {
            if isShowNoDataView {
                addCardViewsToShow()
            }
        }
    }
    /// 无数据占位图
    var noDataView: UIView? {
        didSet {
            if let noDataView = noDataView, isShowNoDataView {
                for subView in self.subviews {
                    if subView.layer.name == kCardViewNoDataString {
                        subView.addSubview(noDataView)
                    }
                }
            }
        }
    }
    /// 展示卡片的横坐标偏移量
    var offsetX = 20.0
    /// 展示卡片的纵坐标偏移量
    var offsetY = 0.0
    /// 代理协议
    var delegate: SKTabCardViewDelegate?
    /// 展示的卡片数
    private var showCardsNumber: NSInteger
    /// 当前索引
    private var currentIndex: NSInteger = 0
    /// 中心坐标
    private var oldCenter: CGPoint = .zero
    /// 卡片总量
    private var cardCount: NSInteger {
        get {
            return cards.count
        }
    }
    /// 顶部卡片拖动中，底部卡片缩放系数
    private var sizePercent: CGFloat = 0.05
    
    private lazy var cardPan = UIPanGestureRecognizer(target: self, action: #selector(panHandle(pan:)))
    
    private weak var currentShowingView: SKTabBaseCardView?
    
    private var alphaArray: [CGFloat] = []
    
    private var keyWindow: UIWindow? {
        get {
            if #available(iOS 13, *) {
                return UIApplication.shared.connectedScenes.compactMap {
                    $0 as? UIWindowScene
                }.first?.windows.first(where: {
                    $0.isKeyWindow
                })
            } else {
                return UIApplication.shared.keyWindow
            }
        }
    }
    
    init(frame: CGRect, showCardsNumber: NSInteger) {
        self.showCardsNumber = showCardsNumber
        super.init(frame: frame)
        self.alphaArray = self.getAlphaArray(showCardsNumber: showCardsNumber)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open func loadCard(cards: [SKTabBaseCardView], showCardsNumber: NSInteger) {
        self.showCardsNumber = showCardsNumber
        if cards.count < 3 {
            self.showCardsNumber = cards.count
        }
        self.alphaArray = getAlphaArray(showCardsNumber: showCardsNumber)
        for subView in self.subviews {
            if subView.isKind(of: SKTabBaseCardView.self) || subView.layer.name == kCardViewNoDataString {
                subView.removeFromSuperview()
            }
        }
        
        self.cards = cards
        
        for (i, cardView) in self.cards.enumerated() {
            cardView.frame = self.bounds
            cardView.center = CGPoint(x: self.center.x + self.offsetX * Double(self.cardCount-1-i) - self.frame.origin.x,
                                      y: self.center.y + self.offsetY * Double(self.cardCount-1-i) - self.frame.origin.y)
            cardView.transform = CGAffineTransform(scaleX: 1.0 - sizePercent * Double(self.cardCount-i-1),
                                                   y: 1.0 - sizePercent * Double(self.cardCount-i-1))
            cardView.backgroundColor = .clear
        }
        addCardViewsToShow()
    }
    
    // MARK: 手势方法
    @objc private func panHandle(pan: UIPanGestureRecognizer) {
        
        let cardView = cards[currentIndex]
        let velocity = pan.velocity(in: self.keyWindow)
        
        // 开始拖动
        if pan.state == .began {
            self.oldCenter = cardView.center
        }
        
        // 拖动中
        // 给顶部视图添加动画
        let transLcation = pan.translation(in: cardView)
        // 视图跟随手势移动
        cardView.center = CGPoint(x: cardView.center.x + transLcation.x, y: cardView.center.y)
        // 计算偏移系数
        let XOffPercent: CGFloat = (cardView.center.x - self.center.x)/self.center.x
        let rotation = Double.pi / 2.0 / 10.5 * XOffPercent
        cardView.transform = CGAffineTransform(rotationAngle: -rotation)
        pan.setTranslation(.zero, in: cardView)
        // 给其余底部视图添加缩放动画
        animationBlowViewWithXOffPercent(abs(XOffPercent))
        
        // 拖动结束
        if pan.state == .ended {
            // 移除拖动视图逻辑
            // 加速度 小于 1100points/second
            if (sqrt(pow(velocity.x, 2) + pow(velocity.y, 2)) < 1100.0) {
                
                // 移动区域半径大于120pt
                if ((sqrt(pow(self.oldCenter.x-cardView.center.x,2) + pow(self.oldCenter.y-cardView.center.y,2))) > 120) {
                    UIView.animate(withDuration: 0.3) {
                        cardView.center = CGPoint(x: (cardView.center.x > self.oldCenter.x ? 1000 : -1000),y: cardView.center.y)
                    } completion: { _ in
                        self.cardRemove(card: cardView)
                    }
                    animationBlowViewWithXOffPercent(1)
                } else {
                    // 不移除，回到初始位置
                    UIView.animate(withDuration: 0.5) {
                        cardView.center = self.oldCenter
                        cardView.transform = CGAffineTransform(rotationAngle: 0)
                        self.animationBlowViewWithXOffPercent(0)
                    }
                }
            }else {
                // 移除，以手势速度飞出
                UIView.animate(withDuration: 0.3) {
                    cardView.center = CGPoint(x: velocity.x ,y: cardView.center.y)
                } completion: { _ in
                    self.cardRemove(card: cardView)
                }
                animationBlowViewWithXOffPercent(1)
            }
        }
    }
    
    // MARK: 私有方法
    
    func getAlphaArray(showCardsNumber: NSInteger) -> [CGFloat] {
        let interval = CGFloat(showCardsNumber-1)/10.0
        let numbers = [Int](0..<showCardsNumber)
        let array = numbers.map { index -> CGFloat in
            if index == 0 {
                return 0.0
            } else if index == (showCardsNumber-1) {
                return 1.0
            }
            return CGFloat(index) * interval + 0.2
        }
        return array
    }
    
    func addNewCard() {
        let isLessShowNum = (cards.count < (showCardsNumber + 1))
        // 添加一个视图
        if (self.currentIndex - showCardsNumber + 1) >= 0 {
            let cardView = cards[currentIndex - showCardsNumber + 1]
            cardView.center = CGPoint(x: self.center.x + self.offsetX * Double(showCardsNumber-1) - self.frame.origin.x,
                                      y: self.center.y + self.offsetY * Double(showCardsNumber-1) - self.frame.origin.y)
            cardView.transform = CGAffineTransform(
                scaleX: 1.0 - sizePercent * Double(showCardsNumber-1),
                y: 1.0-sizePercent * Double(showCardsNumber-1)
            )
            cardView.alpha = 0.0
            if isLessShowNum {
                self.insertSubview(cardView, at: 0)
            } else {
                self.insertSubview(cardView, belowSubview: self.cards[currentIndex - showCardsNumber + 2])
            }
            currentShowingView = cardView
        } else {
            let index = cardCount + currentIndex - showCardsNumber + 1
            let cardView = cards[index]
            cardView.center = CGPoint(x: self.center.x + self.offsetX * Double(showCardsNumber-1) - self.frame.origin.x,
                                      y: self.center.y + self.offsetY * Double(showCardsNumber-1) - self.frame.origin.y)
            cardView.transform = CGAffineTransform(scaleX: 1.0-sizePercent * Double(showCardsNumber-1),
                                                   y: 1.0-sizePercent * Double(showCardsNumber-1))
            cardView.alpha = 0.0
            if isLessShowNum {
                self.insertSubview(cardView, at: 0)
            } else {
                self.insertSubview(cardView, belowSubview: currentShowingView!)
            }
            currentShowingView = cardView
        }
        
        self.delegate?.tabCardViewCurrentIndex(index: self.currentIndex)
    }
    
    func cardRemove(card: SKTabBaseCardView) {
        card.removeGestureRecognizer(self.cardPan)
        card.removeFromSuperview()
        
        currentIndex -= 1
        if currentIndex < 0 {
            currentIndex = cardCount - 1
        }
        
        addPanGestureWithView(cardView: cards[currentIndex])
        addNewCard()
    }
    
    /// 视图上的卡片 偏移缩放
    func animationBlowViewWithXOffPercent(_ XOffPercent: CGFloat) {
        for i in 0..<(showCardsNumber-1) {
            var index = currentIndex - i - 1
            if index < 0 {
                index = cardCount + index
            }
            let otherView = self.cards[index]
            if i > 0 {
                let alpha = self.alphaArray[showCardsNumber - i - 2] + (self.alphaArray[showCardsNumber - i - 1] - self.alphaArray[showCardsNumber - i - 2]) * XOffPercent
                otherView.alpha = alpha
            } else {
                otherView.alpha = 1.0
            }
            // 中心
            let point = CGPoint(x: self.center.x + self.offsetX * Double(i + 1) - self.offsetX*XOffPercent - self.frame.origin.x,
                                y: self.center.y + self.offsetY * Double(i + 1) - self.offsetY*XOffPercent - self.frame.origin.y)
            otherView.center = point
            // 缩放大小
            let scale = 1.0 - sizePercent * Double(i + 1) + XOffPercent * sizePercent
            otherView.transform = CGAffineTransform(scaleX: scale, y: scale)
        }
    }
    
    func addPanGestureWithView(cardView: SKTabBaseCardView) {
        self.cardPan.delegate = cardView as? UIGestureRecognizerDelegate
        cardView.addGestureRecognizer(self.cardPan)
    }
    
    func addCardViewsToShow() {
        if self.cards.count == 0 {
            if self.isShowNoDataView {
                for i in 0..<showCardsNumber {
                    let cardView = UIView()
                    cardView.backgroundColor = .white
                    if let noDataView = noDataView {
                        cardView.addSubview(noDataView)
                    }
                    cardView.frame = self.bounds
                    // 位置偏移
                    cardView.center = CGPoint(x: self.center.x + self.offsetX*Double(showCardsNumber-1-i) - self.frame.origin.x,
                                              y: self.center.y + self.offsetY*Double(showCardsNumber-1-i) - self.frame.origin.y)
                    // 缩放效果
                    cardView.transform = CGAffineTransform(scaleX: 1.0 - sizePercent * Double(showCardsNumber-i-1),
                                                           y: 1.0 - sizePercent * Double(showCardsNumber-i-1))
                    cardView.alpha = self.alphaArray[i]
                    cardView.layer.name = kCardViewNoDataString
                    self.addSubview(cardView)
                }
            }
        } else
        {
            if (self.cardCount < showCardsNumber) {
                
                let removeNum = showCardsNumber - self.cardCount
                showCardsNumber = self.cardCount
                
                for _ in 0..<removeNum {
                    self.alphaArray.remove(at: 0)
                }
                
                for i in 0..<showCardsNumber {
                    let cardView = self.cards[i]
                    cardView.alpha = self.alphaArray[i]
                    self.addSubview(cardView)
                    if i == (showCardsNumber - 1) {
                        self.addPanGestureWithView(cardView: cardView)
                        self.currentIndex = showCardsNumber - 1
                    }
                }
            } else
            {
                for i in 0..<showCardsNumber {
                    let cardView = cards[self.cardCount - showCardsNumber + i]
                    cardView.alpha = self.alphaArray[i]
                    self.addSubview(cardView)
                    if i == (showCardsNumber - 1) {
                        self.addPanGestureWithView(cardView: cardView)
                        currentIndex = cardCount - 1
                    }
                }
            }
        }
    }
}
