//
//  TabCardVC.swift
//  SwiftStudy
//
//  Created by weixin on 2022/1/26.
//

import Foundation
import UIKit

class TabCardVC: BaseViewController, SKTabCardViewDelegate {
    
    override func createUI() {
        
        testFor()
        
        let cardView = SKTabCardView(frame: CGRect(x:50,y:200,width:200,height:150), showCardsNumber: 3)
        cardView.isShowNoDataView = true
        cardView.noDataView = UIView()
        cardView.offsetX = 0.1
        cardView.offsetY = 20
        cardView.delegate = self
        view.addSubview(cardView)
        
        var cards: [TabCardView] = []
        for _ in 0...5 {
            let view = TabCardView()
            let sub = UIView()
            sub.backgroundColor = .red
            view.addSubview(sub)
            sub.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
            cards.append(view)
        }
        
        cardView.loadCard(cards: cards, showCardsNumber: 3)
    }
    
    func tabCardViewCurrentIndex(index: NSInteger) {
        print("index:\(index)")
    }
    
    func testFor() {
        let names = ["John", "Emma", "Robert", "Julia"]
        for index in 0..<names.count {
            print(index, names[index])
        }
        
        for index in names.indices {
            print(index, names[index])
        }
        
        for (index, name) in names.enumerated() {
            print(index, name)
        }
    }
}

class TabCardView: SKTabBaseCardView {
    
}
