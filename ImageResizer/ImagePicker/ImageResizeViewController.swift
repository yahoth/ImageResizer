//
//  ImageResizeViewController.swift
//  ImageResizer
//
//  Created by TAEHYOUNG KIM on 10/5/23.
//

///image의 비율값을 구한다.
///그 비율대로 스크롤뷰를 만든다
///이미지를 넣는다

/// 현재 상황
/// 3:4비율 ✅
/// 가로가 더 길때: 이미지가 스크롤뷰의 위에 붙음. CenterY를 적용하면 가운데 위치하나 확대할 경우 아래로 붙음.
/// 세로가 더 길때:  3:4비율의 스크롤뷰보다 이미지가 더 크지만, 이미지가 스크롤뷰의 가운데 있지 않고 위에 붙음.
///
/// 공통문제: 확대 전에는 드래그가 안된다.

import UIKit
import Combine

class ImageResizeViewController: UIViewController {

    var vm: ImageResizeViewModel!

    let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 3.0

//        scrollView.backgroundColor = .red
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
    }()

    let imageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    let hStack: UIStackView = {
        let hStack = UIStackView()
        hStack.axis = .horizontal
        hStack.distribution = .equalSpacing
        hStack.alignment = .fill
        hStack.translatesAutoresizingMaskIntoConstraints = false
        return hStack
    }()

    // HStack Subviews
    let xButton = UIButton()

    let confirmButton = UIButton()

    var cropLabel: UILabel = {
        let label = UILabel()
        label.text = "Crop"
        label.textColor = .label
        return label
    }()

    let scrollViewColorChangeButton:UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "arrow.left.arrow.right.circle.fill"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .label
        button.setPreferredSymbolConfiguration(.init(pointSize: 30), forImageIn: .normal)
        return button
    }()

    var subscriptions = Set<AnyCancellable>()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        setScrollViewConstraints()
        bind()
        //        let maxDimension = max(imageView.bounds.width, imageView.bounds.height)
        ////        scrollView.contentSize = CGSize(width: maxDimension, height: maxDimension)
        //        scrollView.contentSize = imageView.bounds.size
        setupXAndConfirmButton()
        setHStackConstraints()
        setColorChangeButtonConstraints()
    }

    func bind() {
        vm.$selectedImage.receive(on: DispatchQueue.main)
            .sink { image in
                guard let image else { return }
                self.setImageViewConstraints(image: image)
            }.store(in: &subscriptions)
    }

    func setColorChangeButtonConstraints() {
        scrollViewColorChangeButton.addTarget(self, action: #selector(changeColor), for: .touchUpInside)

        view.addSubview(scrollViewColorChangeButton)

        NSLayoutConstraint.activate([
            scrollViewColorChangeButton.topAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: 20),
            scrollViewColorChangeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
        ])
    }

    @objc func changeColor() {
        let colors: [UIColor] = [.black, .white, .gray]
        let randomColor = colors.randomElement()
        scrollView.backgroundColor = randomColor
        print("change: \(randomColor)")
    }

    func setScrollViewConstraints() {
        view.addSubview(scrollView)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            scrollView.heightAnchor.constraint(equalToConstant: (view.bounds.size.width - 40) * 4 / 3),
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20)
        ])

        scrollView.delegate = self
    }

    func setImageViewConstraints(image: UIImage) {
        imageView.image = image

        scrollView.addSubview(imageView)

        let imageWidth = image.size.width
        let imageHeight = image.size.height
        let aspectRatio = imageWidth / imageHeight

        if aspectRatio >= 1 {
            NSLayoutConstraint.activate([
                imageView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
                imageView.centerYAnchor.constraint(equalTo: scrollView.centerYAnchor),
                imageView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
                imageView.heightAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 1 / aspectRatio)
            ])
        } else {
            NSLayoutConstraint.activate([
                imageView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
                //                imageView.centerYAnchor.constraint(equalTo: scrollView.centerYAnchor),
                imageView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
                imageView.heightAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 1 / aspectRatio)
            ])
        }
    }

    func setupXAndConfirmButton() {
        xButton.setImage(UIImage(systemName: "xmark"), for: .normal)
        confirmButton.setImage(UIImage(systemName: "checkmark"), for: .normal)

        xButton.addTarget(self, action: #selector(dismissImageResizer), for: .touchUpInside)
        confirmButton.addTarget(self, action: #selector(confirm), for: .touchUpInside)

        [xButton, confirmButton].forEach { button in
            button.translatesAutoresizingMaskIntoConstraints = false
            button.tintColor = .label
            button.setPreferredSymbolConfiguration(.init(pointSize: 30), forImageIn: .normal)
            hStack.addArrangedSubview(button)
        }
    }

    func setHStackConstraints() {
        view.addSubview(hStack)

        cropLabel.text = "Crop"
        cropLabel.textColor = .label

        hStack.insertArrangedSubview(cropLabel, at: 1)

        NSLayoutConstraint.activate([
            hStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            hStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            hStack.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            hStack.heightAnchor.constraint(equalToConstant: 100)
        ])
    }

    @objc func dismissImageResizer() {
        self.dismiss(animated: true, completion: nil)
        print("dismiss")
    }

    @objc func confirm() {
        vm.modifiedImagePublisher.send(vm.selectedImage)
        self.dismiss(animated: true) { [weak self] in
            self?.vm.picker.dismiss(animated: true, completion: nil)
        }
        print("confirm")
    }
}

extension ImageResizeViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.imageView
    }
}
