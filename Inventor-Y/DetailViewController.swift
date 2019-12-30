//
//  DetailViewController.swift
//  Inventor-Y
//
//  Created by Muhammad Faisal Imran Khan on 2/19/18.
//  Copyright © 2018 MI Apps. All rights reserved.
//

import UIKit
import AVFoundation
import CoreData



class DetailViewController: UIViewController, UIImagePickerControllerDelegate, UITextFieldDelegate, AVCaptureMetadataOutputObjectsDelegate, UINavigationControllerDelegate, AVCapturePhotoCaptureDelegate, UIGestureRecognizerDelegate {
    
    


    
    
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var viewBackground: UIView!
    
    
    
    @IBOutlet weak var lbl_partnumber: UILabel!
    
    @IBOutlet weak var txt_partNumber: UITextField!
    
    @IBOutlet weak var btn_barcode: UIButton!
    
    
    
    @IBOutlet weak var txt_description: UITextField!
   
    @IBOutlet weak var btn_saveReturn: UIButton!
    
    @IBOutlet weak var btn_saveNext: UIButton!
    
    var savedimageUrl = String()
    
    var image = UIImage()
    
    var scanning = false
    
    var photoOutPut = AVCapturePhotoOutput()
    
    var local_image_id = 0
    
    var output = AVCaptureMetadataOutput()
    
    var previewLayer: AVCaptureVideoPreviewLayer!
    
    var captureSession = AVCaptureSession()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if !savedimageUrl.isEmpty {
            let image = getImageFromPath(sender: savedimageUrl) as UIImage
            
            imageView.image = image
        }
        
        if !captureSession.isRunning {
            captureSession.startRunning()
        }
       
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

       
        
        btn_barcode.backgroundColor = UIColorFromRGB(rgbValue: 0xDC2429)
        btn_barcode.tintColor = UIColor.white
        
        btn_saveNext.backgroundColor = UIColorFromRGB(rgbValue: 0xDC2429)
        btn_saveNext.tintColor = UIColor.white
        
        btn_saveReturn.backgroundColor = UIColorFromRGB(rgbValue: 0xDC2429)
        btn_saveReturn.tintColor = UIColor.white
        
        self.navigationItem.hidesBackButton = true
        
        let newBackButton = UIBarButtonItem(title: "Back", style: UIBarButtonItemStyle.plain, target: self, action: #selector(back(sender:)))
        
        self.navigationItem.leftBarButtonItem = newBackButton
        
        txt_partNumber.delegate = self
        txt_description.delegate = self
        
        txt_partNumber.autocorrectionType = .no
        txt_description.autocorrectionType = .no
        
        self.navigationItem.title = "Goods Details"
        
        txt_description.layer.cornerRadius = 2.0
        txt_partNumber.layer.cornerRadius = 2.0
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        
        tap.delegate = self
        
        self.view.addGestureRecognizer(tap)
        
        btn_saveReturn.layer.cornerRadius = 2.0
        btn_saveNext.layer.cornerRadius = 2.0
        
        btn_barcode.layer.cornerRadius = 2.0
        
      
        lbl_partnumber.textColor = UIColorFromRGB(rgbValue: 0x6C6C6C)
        
        
        
        self.view.backgroundColor = UIColorFromRGB(rgbValue: 0xf5f5f5)
        
        
        
    }
    
    func back(sender: UIBarButtonItem) {
        
        if scanning == true {
            
            previewLayer.removeFromSuperlayer()
            
            if captureSession.isRunning {
                captureSession.stopRunning()
            }
            
            scanning = false
        }
        else {
             _ = navigationController?.popViewController(animated: true)
        
        }
    
    }
    
    func failed() {
        let ac = UIAlertController(title: "Scanning not supported", message: "Your device does not support scanning a code from an item. Please use a device with a camera.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
       
    }
    
    
    private func setupCamera() {
        
        scanning = true
        captureSession = AVCaptureSession()
        
        guard let videoCaptureDevice = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo) else { return }
        let videoInput: AVCaptureDeviceInput
        
        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            return
        }
        
        if (captureSession.canAddInput(videoInput)) {
            captureSession.addInput(videoInput)
        } else {
            failed()
            return
        }
        
        let metadataOutput = AVCaptureMetadataOutput()
        
        if (captureSession.canAddOutput(metadataOutput)) {
            
            captureSession.addOutput(metadataOutput)

            
            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes =
               [AVMetadataObjectTypeQRCode, AVMetadataObjectTypeUPCECode, AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code,AVMetadataObjectTypePDF417Code, AVMetadataObjectTypeUPCECode, AVMetadataObjectTypeITF14Code, AVMetadataObjectTypeCode39Code, AVMetadataObjectTypeCode39Mod43Code, AVMetadataObjectTypeCode128Code, AVMetadataObjectTypeAztecCode]
            
        } else {
            failed()
            return
        }
        
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = view.layer.bounds
        previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
       
        self.view.layer.addSublayer(previewLayer)

        captureSession.startRunning()
        
    }
    
    
    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [Any]!, from connection: AVCaptureConnection!) {
        
        for metadata in metadataObjects {
            if let readableObject = metadata as? AVMetadataMachineReadableCodeObject,
                let code = readableObject.stringValue {
           //     dismiss(animated: true)
                
                found(code: code)
                print(code)
            }
        }
    }

    func found(code: String) {
       
        txt_partNumber.text = code
        
        print(code)
        
    previewLayer.removeFromSuperlayer()
        
      if captureSession.isRunning {
          captureSession.stopRunning()
      }
        
    }

    func dismissKeyboard(){
        txt_partNumber.resignFirstResponder()
        txt_description.resignFirstResponder()
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func retake_action(_ sender: UIButton) {
        
        
    }
    
    
    @IBAction func scan_action(_ sender: UIButton) {
        
        setupCamera()
    }
    
    @IBAction func return_action(_ sender: UIButton) {
        
        
        if ((txt_partNumber.text?.isEmpty)! || (txt_description.text?.isEmpty)!){
            
            let alertController = UIAlertController(title: "Error", message: "Please Enter Value for partnumber and description", preferredStyle: UIAlertControllerStyle.alert)
            
            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
                (result : UIAlertAction) -> Void in
                print("OK")
            }
            
            
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)

            
        }
        else {
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            
            let newPhoto = NSEntityDescription.insertNewObject(forEntityName: "Photos", into: context)
            
            let part_number = txt_partNumber.text ?? ""
            
            let description = txt_description.text ?? ""
            
            let url = savedimageUrl
            
            newPhoto.setValue(part_number, forKey: "barcode")
            
            newPhoto.setValue(description, forKey: "desc")
            
            newPhoto.setValue(url, forKey: "upload")
            
            
            
            do {
                try context.save()
            } catch {
                fatalError("Failure to save context: \(error)")
            }
            
            self.performSegue(withIdentifier: "home", sender: self)

            
        }
        
    }
    
    @IBAction func next_action(_ sender: UIButton) {
        
        if ((txt_partNumber.text?.isEmpty)! || (txt_description.text?.isEmpty)!){
            
            let alertController = UIAlertController(title: "Error", message: "Please Enter Value for partnumber and description", preferredStyle: UIAlertControllerStyle.alert)
            
            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
                (result : UIAlertAction) -> Void in
                print("OK")
            }
            
            
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
            
            
        }

        
        else {
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            
            let newPhoto = NSEntityDescription.insertNewObject(forEntityName: "Photos", into: context)
            
            newPhoto.setValue(txt_partNumber.text, forKey: "barcode")
            
            newPhoto.setValue(txt_description.text, forKey: "desc")
            
            newPhoto.setValue(savedimageUrl, forKey: "upload")
            
            
            
            do {
                try context.save()
            } catch {
                fatalError("Failure to save context: \(error)")
            }
            
            self.performSegue(withIdentifier: "camera", sender: self)

            
        }
        
        
    }
    
    func UIColorFromRGB(rgbValue: UInt) -> UIColor {
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    func getImageFromPath(sender: String) -> UIImage {
        let nsDocumentDirectory = FileManager.SearchPathDirectory.documentDirectory
        let nsUserDomainMask    = FileManager.SearchPathDomainMask.userDomainMask
        let paths               = NSSearchPathForDirectoriesInDomains(nsDocumentDirectory, nsUserDomainMask, true)
        
        var image = UIImage()
        if let dirPath          = paths.first
        {
            let imageURL = URL(fileURLWithPath: dirPath).appendingPathComponent(sender)
             image    = UIImage(contentsOfFile: imageURL.path)!
            
            return image
            // Do whatever you want with the image
        }
        
        return image
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    

   
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        
       
    }
   

}
