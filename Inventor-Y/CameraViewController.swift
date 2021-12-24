//
//  ViewController.swift
//  Inventor-Y
//
//  Created by Muhammad Faisal Imran Khan on 2/17/18.
//  Copyright © 2018 MI Apps. All rights reserved.
//

import UIKit
import AVFoundation


class CameraViewController: UIViewController, AVCapturePhotoCaptureDelegate, UIGestureRecognizerDelegate {
    
    
    @IBOutlet weak var imgTick: UIImageView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var button_accept: UIButton!
    @IBOutlet weak var button_retake: UIButton!
    @IBOutlet weak var lbl_view: UILabel!
    
    @IBOutlet weak var viewBackground: UIView!
    var previewLayer = AVCaptureVideoPreviewLayer()
    
    var stillImageOutput = AVCapturePhotoOutput()
    
    var image = UIImage()
    
    var captureSession = AVCaptureSession()
    
    var savedImageUrl = String()
    
    func UIColorFromRGB(rgbValue: UInt) -> UIColor {
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.tintColor = UIColor.black
        
        imageView.isHidden = true
        
        previewLayer = AVCaptureVideoPreviewLayer()
        
        stillImageOutput = AVCapturePhotoOutput()
        
        image = UIImage()
        
        captureSession = AVCaptureSession()
        
        savedImageUrl = String()
        
        self.captureSession.sessionPreset = AVCaptureSession.Preset.photo
        
        let inputDevice = AVCaptureDevice.default(for: AVMediaType.video)
        
        stillImageOutput = AVCapturePhotoOutput()

       

        button_accept.isHidden = true
        
        button_retake.isHidden = true
        
        imageView.isHidden = true
        
        imgTick.isHidden = false
        
        lbl_view.isHidden = false
        
        if let input = try? AVCaptureDeviceInput(device: inputDevice!) {
            if (self.captureSession.canAddInput(input)) {
                self.captureSession.addInput(input)
                if (captureSession.canAddOutput(stillImageOutput)) {
                    captureSession.addOutput(stillImageOutput)
                    previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
                    previewLayer.frame = viewBackground.bounds
                    viewBackground.layer.insertSublayer(previewLayer, at: 0)
                    captureSession.startRunning()
                }
            } else {
                print("issue here : captureSesssion.canAddInput")
            }
        } else {
            print("some problem here")
        }
    }
    
    @IBAction func unwindToCameraView(segue: UIStoryboardSegue) {
        
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        button_accept.backgroundColor = UIColor.white
        
        button_accept.setTitleColor(UIColor.black, for: .normal)
        
        button_retake.backgroundColor = UIColor.white
        
        button_retake.setTitleColor(UIColor.black, for: .normal)
        
        button_accept.layer.cornerRadius = 2.0
        
        button_retake.layer.cornerRadius = 2.0
        
        button_accept.isHidden = true
        
        button_retake.isHidden = true
        
        imgTick.isUserInteractionEnabled = true
        
        let pgr = UITapGestureRecognizer.init(target: self, action: #selector(capturePhoto))
        
        pgr.delegate = self
        
        imgTick.addGestureRecognizer(pgr)
        
       
    }

    @objc func capturePhoto() {
        
        let settings = AVCapturePhotoSettings()
        let previewPixelType = settings.availablePreviewPhotoPixelFormatTypes.first!
        let previewFormat = [kCVPixelBufferPixelFormatTypeKey as String: previewPixelType,
                             kCVPixelBufferWidthKey as String: 160,
                             kCVPixelBufferHeightKey as String: 160]
        settings.previewPhotoFormat = previewFormat
        self.stillImageOutput.capturePhoto(with: settings, delegate: self)
        
    }
  
    func photoOutput(_ captureOutput: AVCapturePhotoOutput, didFinishProcessingPhoto photoSampleBuffer: CMSampleBuffer?, previewPhoto previewPhotoSampleBuffer: CMSampleBuffer?, resolvedSettings: AVCaptureResolvedPhotoSettings, bracketSettings: AVCaptureBracketedStillImageSettings?, error: Error?) {
    
        if let error = error {
            print(error.localizedDescription)
        }
        
        if let sampleBuffer = photoSampleBuffer, let previewBuffer = previewPhotoSampleBuffer, let dataImage = AVCapturePhotoOutput.jpegPhotoDataRepresentation(forJPEGSampleBuffer: sampleBuffer, previewPhotoSampleBuffer: previewBuffer) {
            
            
            imageView.autoresizingMask = [.flexibleTopMargin, .flexibleHeight, .flexibleWidth, .flexibleLeftMargin, .flexibleRightMargin, .flexibleBottomMargin]
            
            imageView.contentMode = UIView.ContentMode.scaleAspectFit
            
            imageView.clipsToBounds = true
            
            imageView.image = UIImage(data: dataImage)
            
            image = UIImage(data: dataImage)!
            
            imageView.isHidden = false
            
            imgTick.isHidden = true
            
            previewLayer.removeFromSuperlayer()
            
            self.captureSession.stopRunning()
            
            
           
        }
        
        button_accept.layer.zPosition = 1.0
        
        button_retake.layer.zPosition = 1.0
        
        button_accept.isHidden = false
        
        button_retake.isHidden = false
        
        lbl_view.isHidden = true
        
        
    }
    
    
    
    
    @IBAction func accept_action(_ sender: UIButton) {
        
        if (!image.isEqual(nil)){
            
            let viewImage = image as UIImage
            
            let imageName = saveImageDataWithImage(viewImage)
            
            savedImageUrl = imageName
            
        }
        
       
        
    }
    
    func saveImageDataWithImage(_ sender: UIImage) -> String{
        
       
        
        let date = Int64(Date().timeIntervalSince1970 * 1000)
        
        let photoName = date.description + ".jpeg"
        
     
        
        if let data = sender.jpegData(compressionQuality: 0.8) {
                let filename = getDocumentsDirectory().appendingPathComponent(photoName)
                try? data.write(to: filename)
            }
        
        return photoName
        
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
 //   func getImageFromPath(_ sender: String) ->UIImage{
        
 //   }
    
    
    
    @IBAction func retake_action(_ sender: UIButton) {
        
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        
        previewLayer.frame = viewBackground.bounds
        
        viewBackground.layer.insertSublayer(previewLayer, at: 0)
        
        captureSession.startRunning()
        
        button_accept.isHidden = true
        
        button_retake.isHidden = true
        
        imageView.isHidden = true
        
        imgTick.isHidden = false
        
        lbl_view.isHidden = false
        
    }
   
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
  
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        switch(segue.identifier ?? "") {
            
       
        case "Detail":
            guard let detailViewController = segue.destination as? DetailViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            
            detailViewController.savedimageUrl = savedImageUrl
       
            
            default:
            fatalError("Unexpected Segue Identifier; \(String(describing: segue.identifier))")
        }

     }


}

