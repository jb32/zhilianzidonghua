//
//  NavigationHandle.swift
//  Inteligence
//
//  Created by zzzl on 2018/10/16.
//  Copyright © 2018年 zzzl. All rights reserved.
//

import UIKit

class BarButton: UIButton {
    var instanceId: String?
    var nodeRef: String?
    var position: WXNavigationItemPosition?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}

class NavigationHandle: NSObject {
    static let imageHandle = ImageHandle()
}

extension NavigationHandle: WXNavigationProtocol {
    func navigationController(ofContainer container: UIViewController!) -> Any! {
        return container.navigationController
    }
    
    func setNavigationBarHidden(_ hidden: Bool, animated: Bool, withContainer container: UIViewController!) {
        if container.isKind(of: WXBaseViewController.self) {
            return;
        }
        
        container.navigationController?.isNavigationBarHidden = hidden;
    }
    
    func setNavigationBackgroundColor(_ backgroundColor: UIColor!, withContainer container: UIViewController!) {
        if let backgroundColor = backgroundColor {
            container.navigationController?.navigationBar.barTintColor = backgroundColor;
        }
    }
    
    func setNavigationItemWithParam(_ param: [AnyHashable : Any]!, position: WXNavigationItemPosition, completion block: WXNavigationResultBlock!, withContainer container: UIViewController!) {
        
        switch position {
        case .center:
            setNaviBarTitle(param: param, completion: block, container: container)
        case .right:
            setNaviBarRightItem(param: param, completion: block, container: container)
        case .left:
            setNaviBarLeftItem(param: param, completion: block, container: container)
        case .more:
            break
        @unknown default:
            break
        }
    }
    
    func clearNavigationItem(withParam param: [AnyHashable : Any]!, position: WXNavigationItemPosition, completion block: WXNavigationResultBlock!, withContainer container: UIViewController!) {
        switch position {
        case .center:
            clearNaviBarTitle(param: param, completion: block, container: container)
        case .right:
            clearNaviBarRightItem(param: param, completion: block, container: container)
        case .left:
            clearNaviBarLeftItem(param: param, completion: block, container: container)
        case .more:
            break
        @unknown default:
            break
        }
    }
    
    func pushViewController(withParam param: [AnyHashable : Any]!, completion block: WXNavigationResultBlock!, withContainer container: UIViewController!) {
        if param.count == 0 || param["url"] == nil || container == nil {
            callback(block: block, code: MSG_PARAM_ERR, data: nil)
            return
        }
        var animated = true
        if let obj = param["animated"], let objstr = obj as? String {
            let objb = objstr.lowercased()
            if objb == "false" {
                animated = false
            }
        }
        
        guard let url = param["url"] as? String else {
            return
        }
        let vc = BaseViewController(url: url)
        vc.hidesBottomBarWhenPushed = true
        vc.param = param["param"] as? [String : AnyHashable] ?? [:]
        container.navigationController?.pushViewController(vc, animated: animated)
        callback(block: block, code: MSG_SUCCESS, data: nil)
    }
    
    func popViewController(withParam param: [AnyHashable : Any]!, completion block: WXNavigationResultBlock!, withContainer container: UIViewController!) {
        var animated = true
        if let obj = param?["animated"], let objstr = obj as? String {
            let objb = objstr.lowercased()
            animated = WXConvert.bool(objb)
        }
        
        if let root = param?["root"] as? Bool, root {
            container.navigationController?.popToRootViewController(animated: animated)
        } else {
            let vc = container.navigationController?.popViewController(animated: animated) as! BaseViewController
            vc.param = param?["param"] as? [String : AnyHashable] ?? [:]
        }
        callback(block: block, code: MSG_SUCCESS, data: nil)
    }
}

extension NavigationHandle {
    
    func setNaviBarLeftItem(param: [AnyHashable : Any], completion: WXNavigationResultBlock?, container: UIViewController) -> Void {
        if param.count == 0 {
            callback(block: completion, code: MSG_PARAM_ERR, data: nil)
            return
        }
        
        if let button = container.navigationItem.leftBarButtonItem?.customView as? BarButton {
            if let atitle = param["title"], let title = atitle as? String {
                let attribute: [NSAttributedString.Key: Any] = [.font: UIFont.systemFont(ofSize: 18)]
                var size = title.boundingRect(with: CGSize(width: 70, height: 18), options: [.truncatesLastVisibleLine, .usesLineFragmentOrigin, .usesFontLeading], attributes: attribute, context: nil).size
                size.width += 1
                button.frame = CGRect(origin: .zero, size: size)
                button.titleLabel?.font = UIFont.systemFont(ofSize: 18)
                button.setTitleColor(.white, for: .normal)
                button.setTitle(title, for: .normal)
                button.setTitle(title, for: .highlighted)
                
                if let color = param["titleColor"] as? String {
                    button.setTitleColor(WXConvert.uiColor(color), for: .normal)
                    button.setTitleColor(WXConvert.uiColor(color), for: .highlighted)
                }
            } else if let icon = param["icon"] as? String {
                NavigationHandle.imageHandle.downloadImage(withURL: icon, imageFrame: CGRect(x: 0, y: 0, width: 25, height: 25)) { (image, error, finished) in
                    button.setBackgroundImage(image, for: .normal)
                    button.setBackgroundImage(image, for: .highlighted)
                }
            }
        } else {
            if let view = barButton(param: param, position: .left, container: container) {
                container.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: view)
            }
        }
        callback(block: completion, code: MSG_SUCCESS, data: param as? [String : Any])
    }
    
    func clearNaviBarLeftItem(param: [AnyHashable : Any], completion: WXNavigationResultBlock?, container: UIViewController) -> Void {
        container.navigationItem.leftBarButtonItem = nil
        callback(block: completion, code: MSG_SUCCESS, data: nil)
    }
    
    func setNaviBarRightItem(param: [AnyHashable : Any], completion: WXNavigationResultBlock?, container: UIViewController) -> Void {
        if param.count == 0 {
            callback(block: completion, code: MSG_PARAM_ERR, data: nil)
            return
        }
        if let button = container.navigationItem.rightBarButtonItem?.customView as? BarButton {
            if let atitle = param["title"], let title = atitle as? String {
                let attribute: [NSAttributedString.Key: Any] = [.font: UIFont.systemFont(ofSize: 18)]
                var size = title.boundingRect(with: CGSize(width: 70, height: 18), options: [.truncatesLastVisibleLine, .usesLineFragmentOrigin, .usesFontLeading], attributes: attribute, context: nil).size
                size.width += 1
                button.frame = CGRect(origin: .zero, size: size)
                button.titleLabel?.font = UIFont.systemFont(ofSize: 18)
                button.setTitleColor(.white, for: .normal)
                button.setTitle(title, for: .normal)
                button.setTitle(title, for: .highlighted)
                
                if let color = param["titleColor"] as? String {
                    button.setTitleColor(WXConvert.uiColor(color), for: .normal)
                    button.setTitleColor(WXConvert.uiColor(color), for: .highlighted)
                }
            } else if let icon = param["icon"] as? String {
                NavigationHandle.imageHandle.downloadImage(withURL: icon, imageFrame: CGRect(x: 0, y: 0, width: 25, height: 25)) { (image, error, finished) in
                    button.setBackgroundImage(image, for: .normal)
                    button.setBackgroundImage(image, for: .highlighted)
                }
            }
        } else {
            if let view = barButton(param: param, position: .right, container: container) {
                container.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: view)
            }
        }
        callback(block: completion, code: MSG_SUCCESS, data: param as? [String : Any])
    }
    
    func clearNaviBarRightItem(param: [AnyHashable : Any], completion: WXNavigationResultBlock?, container: UIViewController) -> Void {
        container.navigationItem.rightBarButtonItem = nil
        callback(block: completion, code: MSG_SUCCESS, data: nil)
    }
    
    func setNaviBarTitle(param: [AnyHashable : Any], completion: WXNavigationResultBlock?, container: UIViewController) -> Void {
        if param.count == 0 {
            callback(block: completion, code: MSG_PARAM_ERR, data: nil)
            return
        }
        container.navigationItem.title = param["title"] as? String
        callback(block: completion, code: MSG_SUCCESS, data: param as? [String : Any])
    }
    
    func clearNaviBarTitle(param: [AnyHashable : Any], completion: WXNavigationResultBlock?, container: UIViewController) -> Void {
        container.navigationItem.title = ""
        callback(block: completion, code: MSG_SUCCESS, data: nil)
    }
    
    func callback(block: WXNavigationResultBlock?, code: String, data: [String: Any]?) -> Void {
        block?(code, data)
    }
    
    func barButton(param: [AnyHashable: Any], position: WXNavigationItemPosition, container: UIViewController) -> UIView? {
        
        if let atitle = param["title"], let title = atitle as? String  {
            let attribute: [NSAttributedString.Key: Any] = [.font: UIFont.systemFont(ofSize: 18)]
            let size = title.boundingRect(with: CGSize(width: 70, height: 18), options: [.truncatesLastVisibleLine, .usesLineFragmentOrigin, .usesFontLeading], attributes: attribute, context: nil).size
            let button = BarButton(frame: CGRect(x: 0, y: 0, width: size.width, height: size.height))
            button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
            button.setTitleColor(.white, for: .normal)
            button.setTitle(title, for: .normal)
            button.setTitle(title, for: .highlighted)
            button.addTarget(self, action: #selector(clickBarButton(_:)), for: .touchUpInside)
            button.instanceId = param["instanceId"] as? String
            button.nodeRef = param["nodeRef"] as? String
            button.position = position
            
            if let color = param["titleColor"] as? String {
                button.setTitleColor(WXConvert.uiColor(color), for: .normal)
                button.setTitleColor(WXConvert.uiColor(color), for: .highlighted)
            }
            return button
        } else if let icon = param["icon"] as? String {
            let button = BarButton(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
            button.addTarget(self, action: #selector(clickBarButton(_:)), for: .touchUpInside)
            button.instanceId = param["instanceId"] as? String
            button.nodeRef = param["nodeRef"] as? String
            button.position = position
            NavigationHandle.imageHandle.downloadImage(withURL: icon, imageFrame: CGRect(x: 0, y: 0, width: 25, height: 25)) { (image, error, finished) in
                button.setBackgroundImage(image, for: .normal)
                button.setBackgroundImage(image, for: .highlighted)
            }
            return button
        }
        return nil
    }
    
    @objc func clickBarButton(_ sender: BarButton) -> Void {
        if let instanceId = sender.instanceId {
            if let nodeRef = sender.nodeRef {
                WXSDKManager.bridgeMgr()?.fireEvent(instanceId, ref: nodeRef, type: "click", params: nil, domChanges: nil)
            } else {
                var eventType: String?
                
                switch sender.position! {
                case .center:
                    break
                case .right:
                    eventType = "clickrightitem"
                case .left:
                    eventType = "clickleftitem"
                case .more:
                    eventType = "clickmoreitem"
                @unknown default:
                    break
                }
                WXSDKManager.bridgeMgr()?.fireEvent(instanceId, ref: WX_SDK_ROOT_REF, type: eventType, params: nil, domChanges: nil)
            }
        }
    }
}

