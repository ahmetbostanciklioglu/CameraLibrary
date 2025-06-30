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
        VStack {
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
            
            // Image implemantation which is taken from Camera
            List {
                ForEach(cameraManager.images) { image in
                    if let uiImage = image.image {
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFill()
                            .frame(maxWidth: .infinity)
                            .frame(height: 200)
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                            .shadow(radius: 3, y: 2)
                    } else {
                        ProgressView()
                            .frame(maxWidth: .infinity)
                            .frame(height: 200)
                    }
                }
            }
        }
    }
}

#Preview {
    CameraView()
}

