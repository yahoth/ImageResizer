//
//  TempVC.swift
//  ImageResizer
//
//  Created by TAEHYOUNG KIM on 10/6/23.
//

import UIKit
import Combine

class TempVC: UIViewController {
    var subscriptions = Set<AnyCancellable>()

    var imageView: UIImageView = {
        var imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.isUserInteractionEnabled = true
        return imageView
    }()

    let imagePicker = ImagePicker()

    override func viewDidLoad() {
        setNavigationBar()
        setConstraint()
        bind()
    }

    func setConstraint() {
        view.addSubview(imageView)
        imageView.center = view.center

        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20)
        ])
    }

    func setNavigationBar() {
        let modes = [
            UIAction(title: "select image") { _ in
                self.imagePicker.presentPhotoPicker(from: self)
            },
            UIAction(title: "take a picture") { _ in
                print("b")
            }
        ]
        let image = UIImage(systemName: "photo")
        let menu = UIMenu(options: .displayInline, children: modes)
        let button = UIBarButtonItem(image: image, menu: menu)
        self.navigationItem.rightBarButtonItem = button
    }

    func bind() {
        imagePicker.modifiedImagePublisher
            .receive(on: DispatchQueue.main)
            .sink { image in
                self.imageView.image = image
//                let vc = ImageResizeViewController()
//                vc.selectedImage = image
//                vc.modalPresentationStyle = .fullScreen
//                self.present(vc, animated: true)
            }.store(in: &subscriptions)
    }



}
