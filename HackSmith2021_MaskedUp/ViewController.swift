//
//  ViewController.swift
//  HackSmith2021_MaskedUp
//
//  Created by Sophie Koh on 3/26/21.
//

import UIKit

class ViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBOutlet weak var textTitle:UILabel?
    @IBOutlet weak var instructions:UILabel?
    @IBOutlet weak var maskClass:UILabel?
    @IBOutlet weak var imageView:UIImageView?
    @IBOutlet weak var butt:UIButton!
    var buttonType:Bool = false //false means it is ready to take a photo
    var imagePicker: UIImagePickerController!
    var uiImage: UIImage? = nil

    // photo code adapted from https://www.ioscreator.com/tutorials/take-photo-ios-tutorial
    
    @IBAction func takePhoto(){
        if buttonType == false{
            //hide other labels
            instructions?.isHidden = true
            maskClass?.isHidden = true
            
            //take photo
            imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .camera
            imagePicker.cameraFlashMode = .off
            imagePicker.allowsEditing = true
            present(imagePicker, animated: true, completion: nil)
            //change button
            butt.setTitle("Classify", for: .normal)
            buttonType=true
        }
        else{
            let maskStat:Int = classify()
            if maskStat == 0{
                maskClass?.textColor = UIColor.green
                maskClass?.text = "Correct"
                instructions?.text = "Thank you for helping prevent the spread of COVID-19!"
            }
            else{
                maskClass?.textColor = UIColor.red
                maskClass?.text = "Incorrect"
                if maskStat == 1{
                    //pull your mask over your chin
                    instructions?.text = "Make sure your mask covers your mouth"
                }
                else if maskStat == 2{
                    //pull your mask up over your nose
                    instructions?.text = "Make sure your mask covers your nose"
                }
                else if maskStat == 3{
                    //pull your mask up over your nose and mouth
                    instructions?.text = "Make sure your mask covers your nose and mouth"
                }
            }
            instructions?.isHidden = false
            maskClass?.isHidden = false
            butt.setTitle("Take Photo", for: .normal)
            buttonType = false
        }
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            imagePicker.dismiss(animated: true, completion: nil)
            uiImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage
            imageView?.image = uiImage
        }
    func classify()-> Int{
        var maskStatus:Int
        let scaledImage = scaleToSize(img:uiImage!)
        let png:Data = scaledImage.pngData()!
        //Use ML model to figure this out but using random number for now
        
        let randomInt = Int.random(in: 0..<4)
        maskStatus = randomInt
        //
        return maskStatus
    }
    
    func scaleToSize(img:UIImage) -> UIImage{
        let size = img.size
        let ratio  = 256.0/size.width
        let newSize:CGSize = CGSize(width: size.width*ratio, height: size.height*ratio)
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0)
        img.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }

}

