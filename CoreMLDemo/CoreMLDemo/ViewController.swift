//
//  ViewController.swift
//  CoreMLDemo
//
//  Created by Hugo Peregrina Sosa on 7/28/17.
//  Copyright © 2017 Wizeline. All rights reserved.
//

import UIKit
import CoreML

class ViewController: UIViewController, UINavigationControllerDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var results: UITextView!
    @IBOutlet weak var classificationLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var model: Inceptionv3!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //Instance specific model to be used
        model = Inceptionv3()
    }
    
    func processImage(image: UIImage){
        //Crop and process the image to the required 299x299 size
         DispatchQueue.global().async {
            guard let processedImage = ImageConverter.shared.processImage(image: image) else { return }
            
            DispatchQueue.main.async { [weak self] in
                guard let strongSelf = self else { return }
                strongSelf.imageView.image = processedImage
                strongSelf.predictResult(image: processedImage)
            }
        }
        
    }
    
    func predictResult(image: UIImage){
        results.text = ""
        guard let pixelBuffer = ImageConverter.shared.getImagePixelBuffer() else { return }
        guard let prediction = try? model.prediction(image: pixelBuffer) else { return }
        
        let classLabel = prediction.classLabel
        let probs = prediction.classLabelProbs
        
        classificationLabel.text = "Classification: \(classLabel)"
        
        let sorted = probs.sorted(by: { $0.1 > $1.1 })
        for (classification, value) in sorted {
            results.text = results.text.appending("\(classification) \(value)%\n")
        }
        activityIndicator.alpha = 0.0
        activityIndicator.stopAnimating()
    }
    
    @IBAction func camera(_ sender: Any) {
        
        if !UIImagePickerController.isSourceTypeAvailable(.camera) {
            return
        }
        
        let cameraPicker = UIImagePickerController()
        cameraPicker.delegate = self
        cameraPicker.sourceType = .camera
        cameraPicker.allowsEditing = false
        
        present(cameraPicker, animated: true)
    }
    
    @IBAction func openLibrary(_ sender: Any) {
        let picker = UIImagePickerController()
        picker.allowsEditing = false
        picker.delegate = self
        picker.sourceType = .photoLibrary
        present(picker, animated: true)
    }
}

extension ViewController: UIImagePickerControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        picker.dismiss(animated: true, completion: { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.activityIndicator.alpha = 1.0
            strongSelf.activityIndicator.startAnimating()
            strongSelf.classificationLabel.text = "Processing..."
            strongSelf.imageView.image = nil
            strongSelf.results.text = ""
            guard let image = info["UIImagePickerControllerOriginalImage"] as? UIImage else { return }
            strongSelf.processImage(image: image)
        })
    }
}
