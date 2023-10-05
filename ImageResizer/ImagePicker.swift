//
//  ImagePicker.swift
//  ImageResizer
//
//  Created by TAEHYOUNG KIM on 2023/10/03.
//

import UIKit
import Combine
import PhotosUI

class ImagePicker: NSObject, PHPickerViewControllerDelegate {
    let selectedImagePublisher = PassthroughSubject<UIImage?, Never>()

    weak var viewController: UIViewController?
    var nav: UINavigationController?
    func presentPhotoPicker(from viewController: UIViewController) {

        var config = PHPickerConfiguration(photoLibrary: .shared())
        config.filter = .images
        config.preferredAssetRepresentationMode = .current
        config.selectionLimit = 1

        let pickerVC = PHPickerViewController(configuration: config)
        self.viewController = viewController
        nav = UINavigationController(rootViewController: pickerVC)
        pickerVC.delegate = self
        pickerVC.modalPresentationStyle = .fullScreen
        viewController.present(nav!, animated:true)
    }

//    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
//        let itemProvider = results.first?.itemProvider
//
////        picker.dismiss(animated: true, completion: nil)
//
//        if let itemProvider = itemProvider, itemProvider.canLoadObject(ofClass: UIImage.self) {
//            itemProvider.loadObject(ofClass: UIImage.self) { [weak self] image, error in
//                DispatchQueue.main.async {
////                    self?.selectedImagePublisher.send(image as? UIImage)
//                    let vc = Temp2ViewController()
//                    vc.selectedImage = image as? UIImage
//                    vc.modalPresentationStyle = .fullScreen
//                    self?.viewController?.present(vc, animated: true)
//                }
//            }
//        } else {
//            DispatchQueue.main.async {
//                self.selectedImagePublisher.send(nil)
//            }
//        }
//    }
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {

        picker.dismiss(animated: true) { [weak self] in
            if let itemProvider = results.first?.itemProvider,
               itemProvider.canLoadObject(ofClass: UIImage.self) {
                itemProvider.loadObject(ofClass: UIImage.self) { (object, error) in

                    DispatchQueue.main.async {
                        if let image = object as? UIImage {
                            let vc = Temp2ViewController()
                            vc.selectedImage = image
                            vc.modalPresentationStyle = .fullScreen
                            //                                                self?.viewController?.present(vc, animated: true)
                            self?.nav?.pushViewController(vc, animated: true)
                        } else if let error = error {
                            print("Error loading image:", error)
                        }
                    }
                }
            }
        }
    }
}
