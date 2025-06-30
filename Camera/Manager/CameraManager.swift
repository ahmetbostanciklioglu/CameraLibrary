//
//  CameraViewModel.swift
//  Camera
//
//  Created by Ahmet Bostanci on 30.06.2025.
//

import UIKit
import AVFoundation

enum ActionType {
    case camera
}

class CameraManager: ObservableObject {
    @Published var images = [ImageItem]()
    @Published var permissionMessage = ""
    @Published var isShowingAlert = false
    @Published var isShowingCamera = false
    
    private func checkCameraPermission(completion: @escaping (Bool) -> Void) {
        let status = AVCaptureDevice.authorizationStatus(for: .video)
        
        switch status {
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { permissionGranted in
                DispatchQueue.main.async {
                    if permissionGranted {
                        completion(true)
                    } else {
                        self.permissionMessage = "Camera access is required to use this feature. Please enable it in Settings."
                        self.isShowingAlert = true
                        completion(false)
                    }
                }
            }
        case .restricted, .denied:
            permissionMessage = "Camera access was denied. Please enable it in Settings to use this feature."
            isShowingAlert = true
            completion(false)
        case .authorized:
            completion(true)
        @unknown default:
            completion(false)
        }
    }
    
    func handleCamera(action: ActionType) {
        switch action {
        case .camera:
            checkCameraPermission { [weak self] permissionGranted in
                if permissionGranted {
                    self?.isShowingCamera = true
                }
            }
        }
    }
    
    func handleScannedImage(_ image: UIImage) {
        let newImage = ImageItem(image: image)
        images.insert(newImage, at: 0)
    }
    
}
