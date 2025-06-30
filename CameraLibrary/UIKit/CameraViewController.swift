//
//  CameraViewController.swift
//  Camera
//
//  Created by Ahmet Bostanci on 30.06.2025.
//

import SwiftUI
import AVFoundation

class CameraViewController: UIViewController {
    weak var delegate: CameraViewControllerDelegate?
    var captureSession: AVCaptureSession?
    var photoOutput: AVCapturePhotoOutput?
    var previewLayer: AVCaptureVideoPreviewLayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if !setupCamera() {
            delegate?.didCancelCapture()
        }
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        guard let layer = previewLayer else { return }
        layer.frame = view.bounds
    }
    
    func setupCamera() -> Bool {
        let session = AVCaptureSession()
        session.sessionPreset = .photo
        
        guard let videoCaptureDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) else { return false }
        
        let videoInput: AVCaptureDeviceInput
        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            print(error.localizedDescription)
            return false
        }
        
        if session.canAddInput(videoInput) {
            session.addInput(videoInput)
        } else {
            return false
        }
        
        let output = AVCapturePhotoOutput()
        if session.canAddOutput(output) {
            session.addOutput(output)
            self.photoOutput = output
        } else {
            return false
        }
        
        self.captureSession = session
        let layer = AVCaptureVideoPreviewLayer(session: session)
        layer.videoGravity = .resizeAspectFill
        self.previewLayer = layer
        
        if let actualPreviewLayer = previewLayer {
            view.layer.addSublayer(actualPreviewLayer)
        } else {
            return false
        }
        
        let captureButton = UIButton(type: .system)
        captureButton.setTitle("Take a Photo", for: .normal)
        captureButton.setTitleColor(.white, for: .normal)
        captureButton.backgroundColor = .systemBlue
        captureButton.layer.cornerRadius = 10
        captureButton.translatesAutoresizingMaskIntoConstraints = false
        captureButton.addTarget(self, action: #selector(takePhoto), for: .touchUpInside)
        view.addSubview(captureButton)
        
        let cancelButton = UIButton(type: .system)
        cancelButton.setTitle("İptal", for: .normal)
        cancelButton.setTitleColor(.white, for: .normal)
        cancelButton.backgroundColor = .systemRed
        cancelButton.layer.cornerRadius = 10
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.addTarget(self, action: #selector(cancelCapture), for: .touchUpInside)
        view.addSubview(cancelButton)
        
        NSLayoutConstraint.activate([
            captureButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            captureButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            captureButton.widthAnchor.constraint(equalToConstant: 150),
            captureButton.heightAnchor.constraint(equalToConstant: 50),
            cancelButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            cancelButton.bottomAnchor.constraint(equalTo: captureButton.topAnchor, constant: -10),
            cancelButton.widthAnchor.constraint(equalToConstant: 150),
            cancelButton.heightAnchor.constraint(equalToConstant: 50)])
        
        return true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let session = captureSession else { return }
        if !session.isRunning {
            DispatchQueue.global(qos: .userInitiated).async {
                session.startRunning()
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        guard let session = captureSession else { return }
        if session.isRunning {
            DispatchQueue.global(qos: .userInitiated).async {
                session.stopRunning()
            }
        }
    }
    
    @objc func takePhoto() {
        guard let output = photoOutput else { return }
        let settings = AVCapturePhotoSettings()
        output.capturePhoto(with: settings, delegate: self)
    }
    
    @objc func cancelCapture() {
        delegate?.didCancelCapture()
    }
}

extension CameraViewController: AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: (any Error)?) {
        if let error {
            print("\(error.localizedDescription)")
            delegate?.didCancelCapture()
            return
        }
        guard let imageData = photo.fileDataRepresentation(), let image = UIImage(data: imageData) else {
            delegate?.didCancelCapture()
            return
        }
        delegate?.didCapture(image: image)
    }
}
