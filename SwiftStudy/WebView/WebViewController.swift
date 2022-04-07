//
//  WebViewController.swift
//  SwiftStudy
//
//  Created by weixin on 2022/1/11.
//

import Foundation
import WebKit

class WebViewController: BaseViewController {
    
    @IBOutlet weak var webView: WKWebView!
    
    override func createUI() {
        let content = """
<html>
<ol>
<li>
<span style=\"font-size:144px\">个人风格高二哥认同感很容易让他给让他坏投入核桃仁还挺好</span>
</li>
</ol>
<p>
</p>
<div class=\"media-wrap image-wrap\">
<img class=\"media-wrap image-wrap\" id=\"1641868073744_3\" alt=\"image.png\" title=\"image.png\" src=\"https://scu-1301925519.cos.ap-nanjing.myqcloud.com/scu/-/image/0e0df13e493e7b9c364de1fe05a2ef05.png\"/>
</div>
<p></p>
<div class=\"media-wrap image-wrap\">
<img class=\"media-wrap image-wrap\" id=\"1641868074349_4\" alt=\"image.png\" title=\"image.png\" src=\"https://scu-1301925519.cos.ap-nanjing.myqcloud.com/scu/-/image/0e0df13e493e7b9c364de1fe05a2ef05.png\"/>
</div>
<p></p>
</html>
"""
        let htmlContent = makeHTML(htmlString: content, fontSiz: ratio(for: 15))
        webView.loadHTMLString(htmlContent, baseURL: nil)
    }
    
    
    func makeHTML(htmlString: String, fontSiz: CGFloat) -> String {
        let formFilePath = Bundle.main.path(forResource: "TJWebContent", ofType: "txt")!
        let htmlContent = try? NSMutableString.init(contentsOfFile: formFilePath, encoding: String.Encoding.utf8.rawValue)
        
        guard let htmlCon = htmlContent else { return htmlString }
        let replaceFont = htmlCon.replacingOccurrences(of: "###contentFontSize###", with: String("\(fontSiz)"))
        let replaceContent = replaceFont.replacingOccurrences(of: "###content###", with: htmlString)
        return replaceContent as String
        
    }
    
    @IBAction func showView() {
        
    }
    
    func show() {
        let vc = UIViewController()
        vc.view.backgroundColor = UIColor.init(white: 1.0, alpha: CGFloat(arc4random()%100)/100.0)
        self.present(vc, animated: false)
    }
}

public func ratio(for size: CGFloat) -> CGFloat {
    return (KScreenWith > KScreenHeight ? KScreenHeight : KScreenWith) / 375.0 * size
}

let KScreenBounds: CGRect = UIScreen.main.bounds   /* 屏幕bounds */
let KScreenSize: CGSize = KScreenBounds.size   /* 屏幕大小 */
let KScreenWith: CGFloat = (KScreenBounds.width < KScreenBounds.height) ? KScreenBounds.width : KScreenBounds.height   /* 屏幕宽度 */
let KScreenHeight: CGFloat = (KScreenBounds.width < KScreenBounds.height) ? KScreenBounds.height : KScreenBounds.width   /* 屏幕高度 */
