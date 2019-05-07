//
//  ScanCodeViewController.swift
//  Inteligence
//
//  Created by zzzl on 2018/10/11.
//  Copyright © 2018年 zzzl. All rights reserved.
//

import UIKit
import AVFoundation

class ScanCodeViewController: UIViewController {
    
    @objc var callback: WXModuleKeepAliveCallback?
    private let obtain = SGQRCodeObtain()
    private let flashlightBtn = UIButton(type: .custom)
    private var isSelectedFlashlightBtn = false
    private let scanView = SGQRCodeScanView()
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    deinit {
        removeScanningView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "扫一扫"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "相册", style: .done, target: self, action: #selector(toPhotoAlbum))
        setupQRCodeScan()
        view.addSubview(scanView)
        // Do any additional setup after loading the view.
    }
    
    @objc func toPhotoAlbum() {
        obtain.establishAuthorizationQRCodeObtainAlbum(with: nil)
        
        if obtain.isPHAuthorization {
            scanView.removeTimer()
        }
        obtain.setBlockWithQRCodeObtainAlbumDidCancelImagePickerController { [weak self] (obtain) in
            guard let `self` = self else { return }
            self.view.addSubview(self.scanView)
        }
        
        obtain.setBlockWithQRCodeObtainAlbumResult { [weak self] (_, result) in
            self?.callback?(result, false)
        }
    }
    
    private func setupQRCodeScan() {
        let configure = SGQRCodeObtainConfigure()
        configure.sampleBufferDelegate = true
        obtain.establishQRCodeObtainScan(with: self, configure: configure)
        obtain.setBlockWithQRCodeObtainScanResult { [weak self] (obtain, result) in
            if let result = result {
                obtain?.stopRunning()
                guard let mids = result.split(separator: ",").filter({$0.contains("序列号:")}).first else { return }
                var mid = String(mids)
                guard let range = mid.range(of: "序列号:") else { return }
                mid.removeSubrange(range)
                self?.callback?(String(mid), false)
                DispatchQueue.main.async {
                    self?.navigationController?.popViewController(animated: true)
                }
            }
        }
        obtain.setBlockWithQRCodeObtainScanBrightness { [weak self] (obtain, brightness) in
            guard let `self` = self else { return }
            if brightness < -1 {
                self.view.addSubview(self.flashlightBtn)
            } else {
                if !self.isSelectedFlashlightBtn {
                    self.removeFlashlightBtn()
                }
            }
        }
    }
    
    private func removeFlashlightBtn() {
        DispatchQueue.main.async { [weak self] in
            self?.obtain.closeFlashlight()
            self?.isSelectedFlashlightBtn = false
            self?.flashlightBtn.isSelected = false
            self?.flashlightBtn.removeFromSuperview()
        }
    }
    
    private func removeScanningView() {
        scanView.removeTimer()
        scanView.removeFromSuperview()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scanView.frame = view.bounds
        let size = CGSize(width: 30, height: 30)
        let position = CGPoint(x: (view.frame.width - 30) * 0.5, y: view.frame.height * 0.55)
        flashlightBtn.frame = CGRect(origin: position, size: size)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        obtain.startRunningWith(before: nil, completion: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        scanView.addTimer()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        scanView.removeTimer()
        removeFlashlightBtn()
        obtain.stopRunning()
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
