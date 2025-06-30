//
//  CameraCaptureView.swift
//  Camera
//
//  Created by Ahmet Bostanci on 30.06.2025.
//

import SwiftUI
import AVFoundation

protocol CameraViewControllerDelegate: AnyObject {
    func didCapture(image: UIImage)
    func didCancelCapture()
}

struct CameraCaptureView: UIViewControllerRepresentable {
    var didCaptureImage: (UIImage) -> Void
    var didCancel: () -> Void
    
    func makeUIViewController(context: Context) -> CameraViewController {
        let viewController = CameraViewController()
        viewController.delegate = context.coordinator
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: CameraViewController, context: Context) { }
    
    func makeCoordinator() -> Coordinator { Coordinator(self) }
    
    class Coordinator: NSObject, CameraViewControllerDelegate {
        var parent: CameraCaptureView
        
        init(_ parent: CameraCaptureView) {
            self.parent = parent
        }
        func didCapture(image: UIImage) {
            parent.didCaptureImage(image)
        }
        func didCancelCapture() {
            parent.didCancel()
        }
    }
}
