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
    let modifiedImagePublisher = PassthroughSubject<UIImage?, Never>()

    func presentPhotoPicker(from viewController: UIViewController) {
        var config = PHPickerConfiguration(photoLibrary: .shared())
        config.filter = .images
        config.preferredAssetRepresentationMode = .current
        config.selectionLimit = 1

        let pickerVC = PHPickerViewController(configuration: config)

        pickerVC.delegate = self

        viewController.present(pickerVC, animated:true)
    }

    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        let itemProvider = results.first?.itemProvider

        let vc = ImageResizeViewController()
        let vm = ImageResizeViewModel(modifiedImagePublisher: self.modifiedImagePublisher, picker: picker)
        vc.vm = vm
        picker.present(vc, animated: true)

        if let itemProvider = itemProvider, itemProvider.canLoadObject(ofClass: UIImage.self) {
            itemProvider.loadObject(ofClass: UIImage.self) { image, error in
                DispatchQueue.main.async {
                    let selectedImage = image as? UIImage
                    vm.selectedImage = selectedImage
                }
            }
        } else {
            DispatchQueue.main.async {
                vm.selectedImage = nil
            }
        }
    }
}
