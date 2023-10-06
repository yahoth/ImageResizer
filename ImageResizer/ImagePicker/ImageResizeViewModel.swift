//
//  ImageResizeViewModel.swift
//  ImageResizer
//
//  Created by TAEHYOUNG KIM on 10/6/23.
//

import UIKit
import Combine
import PhotosUI

final class ImageResizeViewModel {
    @Published var selectedImage: UIImage!
    let modifiedImagePublisher: PassthroughSubject<UIImage?, Never>

    var picker: PHPickerViewController

    init(modifiedImagePublisher: PassthroughSubject<UIImage?, Never>, picker: PHPickerViewController) {
        self.modifiedImagePublisher = modifiedImagePublisher
        self.picker = picker
    }
}
