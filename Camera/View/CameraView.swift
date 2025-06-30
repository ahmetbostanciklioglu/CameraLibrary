//
//  Camera.swift
//  Camera
//
//  Created by Ahmet Bostanci on 30.06.2025.
//

import SwiftUI

struct CameraView: View {
    @StateObject private var cameraManager = CameraManager()
    
    var body: some View {
        Button {
            cameraManager.handleCamera(action: .camera)
        } label: {
            Label("Camera", systemImage: "camera.fill")
        }
        .buttonStyle(.plain)
        .sheet(isPresented: $cameraManager.isShowingCamera) {
            CameraCaptureView { uiImage in
                cameraManager.handleScannedImage(uiImage)
                DispatchQueue.main.async {
                    cameraManager.isShowingCamera = false
                }
            } didCancel: {
                DispatchQueue.main.async {
                    cameraManager.isShowingCamera = false
                }
            }
        }
    }
}

#Preview {
    CameraView()
}

