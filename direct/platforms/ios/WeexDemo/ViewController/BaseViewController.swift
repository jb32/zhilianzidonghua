//
//  BaseViewController.swift
//  Inteligence
//
//  Created by zzzl on 2018/10/8.
//  Copyright © 2018年 zzzl. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
    #if DEBUG
    private var hotReloadSocket: SRWebSocket?
    #endif
    
    var weex: WXSDKInstance!
    var weexView: UIView?
    var url: URL!
    var bundleUrl: String
    var param = [String: AnyHashable]()
    var commandQueue: UDPSubQueue!
    
    private var jsName: String?
    
    
    var weexjs: String {
        if let jsName = jsName {
            return jsName
        }
        return "\(type(of: self)).js"
    }
    
    init(url: String) {
        self.url = URL(string: url)
        let urls = url.components(separatedBy: "/")
        jsName = urls.last?.components(separatedBy: ".").first
        bundleUrl = "file://\(Bundle.main.bundlePath)/bundlejs/"
        commandQueue = UDPSubQueue(label: jsName ?? "")
        
        super.init(nibName: nil, bundle: nil)
        
        view.backgroundColor = UIColor.white
        render()
    }
    
    init() {
        bundleUrl = "file://\(Bundle.main.bundlePath)/bundlejs/"
        
        super.init(nibName: nil, bundle: nil)
        
        commandQueue = UDPSubQueue(label: weexjs)
        url = URL(string: "file://\(Bundle.main.bundlePath)/bundlejs/\(weexjs)")
        view.backgroundColor = UIColor.white
        
        render()
    }
    
    required init?(coder aDecoder: NSCoder) {
        bundleUrl = "file://\(Bundle.main.bundlePath)/bundlejs/"
        
        super.init(coder: aDecoder)
        
        url = URL(string: "file://\(Bundle.main.bundlePath)/bundlejs/\(weexjs)")
        commandQueue = UDPSubQueue(label: weexjs)
        render()
    }
    
    deinit {
        #if DEBUG
        hotReloadSocket?.close()
        #endif
        weex.destroy()
        print(msg: "\(String(describing: self.url.pathComponents.last)) 释放了")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(refreshWeex(notify:)), name: NSNotification.Name.refreshInstance, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(refresh(orientation:)), name: UIApplication.didChangeStatusBarOrientationNotification, object: nil)
        view.tintColor = .black
        
        #if DEBUG
        let hotReloadURL = Bundle.main.object(forInfoDictionaryKey: "WXSocketConnectionURL") as? String
        if let hotReloadURL = hotReloadURL {
            hotReloadSocket = SRWebSocket(url: URL(string: hotReloadURL))
            hotReloadSocket?.delegate = self
            hotReloadSocket?.open()
        }
        #endif
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if navigationItem.leftBarButtonItem?.customView == nil {
            let btn = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
            navigationItem.leftBarButtonItem = btn
        }
        commandQueue.resume()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        updateWeex(state: .WeexInstanceAppear)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        updateWeex(state: .WeexInstanceDisappear)
        commandQueue.interrupt()
    }
    
    @objc func refresh(orientation notify: Notification) {
        if let tabBarController = tabBarController, !tabBarController.tabBar.isHidden {
            weex.frame = CGRect(x: 0, y: .nav, width: .w, height: .h_nav_tab)
        } else {
            weex.frame = CGRect(x: 0, y: .nav, width: .w, height: .h_nav)
        }
        updateWeex(state: .WeexInstanceAppear)
    }
    
    @objc func refreshWeex(notify: Notification) {
        render()
    }
    
    private func render() {
        weex?.destroy()
        weex = WXSDKInstance()
        weex.viewController = self
        
        if let tabBarController = tabBarController, !tabBarController.tabBar.isHidden {
            weex.frame = CGRect(x: 0, y: .nav, width: .w, height: .h_nav_tab)
        } else {
            weex.frame = CGRect(x: 0, y: .nav, width: .w, height: .h_nav)
        }
        
        weex.onCreate = { [weak self] in
            guard let `self` = self else { return }
            self.weexView?.removeFromSuperview()
            self.weexView = $0
            self.view.addSubview(self.weexView!)
            self.navigationItem.leftBarButtonItem = nil
            UIAccessibility.post(notification: .screenChanged, argument: self.weexView!);
        }
        weex.onFailed = { [weak self] (error) in
            if let error = error as NSError?, error.domain == "1", let `self` = self {
                DispatchQueue.main.async {
                    var errMsg = "\(error.domain)"
                    errMsg += "\(error.code)"
                    errMsg += "\(error.userInfo)"
                    
                    let alerView = UIAlertController(title: "render failed", message: errMsg, preferredStyle: .alert)
                    let action = UIAlertAction(title: "确定", style: .default, handler: nil)
                    alerView.addAction(action)
                    self.present(alerView, animated: true, completion: nil)
                }
            }
        }
        weex.renderFinish = { [weak self] _ in
            guard let `self` = self else { return }
            if self.weex.state == .WeexInstanceDestroy {
                return
            }
            self.updateWeex(state: .WeexInstanceAppear)
        }
        weex.updateFinish = { _ in
            
        }
        weex.render(with: url, options: ["bundleUrl" : bundleUrl], data: nil)
    }
    
    func updateWeex(state: WXState) -> Void {
        if weex.state != state {
            weex.state = state
            
            if state == .WeexInstanceAppear {
                WXSDKManager.bridgeMgr()?.fireEvent(weex.instanceId, ref: WX_SDK_ROOT_REF, type: "viewappear", params: nil, domChanges: nil)
            } else if (state == .WeexInstanceDisappear) {
                WXSDKManager.bridgeMgr()?.fireEvent(weex.instanceId, ref: WX_SDK_ROOT_REF, type: "viewdisappear", params: nil, domChanges: nil)
            }
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
}

#if DEBUG
extension BaseViewController: SRWebSocketDelegate {
    func webSocket(_ webSocket: SRWebSocket!, didReceiveMessage message: Any!) {
        guard let message = message as? String else { return }
//        if message == "refresh" {
//            render()
//        }
        
        let messageDic = WXUtility.object(fromJSON: message) as? [AnyHashable: Any]
        let method = messageDic?["method"] as? String
        
        if let method0 = method, method0.hasPrefix("WXReload") {
//            let params = messageDic?["params"]
//            if method0 == "WXReloadBundle", let urlStr = params as? String {
//                let str = urlStr.replacingOccurrences(of: "LoginViewController.js", with: weexjs)
//                url = URL(string: str)
//            }
            render()
        }
    }
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .all
    }
}

#endif

extension WXRootViewController {
    open override var shouldAutorotate: Bool {
        return topViewController?.shouldAutorotate ?? false
    }
    
    open override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return topViewController?.supportedInterfaceOrientations ?? .portrait
    }
}
