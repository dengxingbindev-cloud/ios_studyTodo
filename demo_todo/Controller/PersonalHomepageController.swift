import UIKit
import SnapKit
import PhotosUI
import CropViewController

class PersonalHomepageController: UIViewController,PHPickerViewControllerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,CropViewControllerDelegate{
    
    private var person:Person
    
    private let detailView = PersonalHomepageView()
    
    init() {

        self.person = Person(name: "",avatorPath: "",about: "")

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {

        fatalError("init(coder:) has not been implemented")

    }
    
    override func loadView() {
        view = detailView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let person1 = Person(name: "余灵",avatorPath: "yuling",about:"人生尚有来处，却只剩归途")
//        PersonStorage.save(person1)
        
        person = PersonStorage.load()
        
        detailView.onAvatarTapped = { [weak self] in
            self?.showAvatarActionSheet()
        }
        
        detailView.configure(with:person)
    }
    
    private func showAvatarActionSheet() {
        let vc = AvatarActionViewController()

        vc.avatarImage = detailView.userAvator.image

        vc.albumHandler = { [weak self] in
            self?.openPhotoLibrary()
        }

        vc.cameraHandler = { [weak self] in
            self?.openCamera()
        }

        vc.historyHandler = { [weak self] in
            print("历史头像")
        }

        vc.modalPresentationStyle = .overFullScreen

        present(vc, animated: false)
    }
}

private extension PersonalHomepageController{
    func bindEvents(){
        
    }
}

private extension PersonalHomepageController{
    func openPhotoLibrary() {
        var config = PHPickerConfiguration()

        // 最多选择一张

        config.selectionLimit = 1

        // 只显示图片

        config.filter = .images

        let picker = PHPickerViewController(configuration: config)

        picker.delegate = self

        present(picker, animated: true)
    }
    
    private func openCamera() {
    guard UIImagePickerController.isSourceTypeAvailable(.camera)
        else {
            let alert = UIAlertController(

                title: "提示",

                message: "当前设备没有相机",

                preferredStyle: .alert

            )

            alert.addAction(UIAlertAction(title: "确定", style: .default))

            present(alert, animated: true)

            return

        }

        let picker = UIImagePickerController()

        picker.sourceType = .camera

        picker.delegate = self

        picker.allowsEditing = true

        present(picker, animated: true)
    }
}

extension PersonalHomepageController{
    func picker(_ picker: PHPickerViewController,
                didFinishPicking results: [PHPickerResult]) {

        dismiss(animated: true)

        guard let result = results.first else {
            return
        }

        result.itemProvider.loadObject(ofClass: UIImage.self) { [weak self] object, error in

            guard let self,
                  let image = object as? UIImage else {
                return
            }

            DispatchQueue.main.async {

                let cropVC = CropViewController(image: image)
                
//                //不允许改变裁剪框比例
//                cropVC.aspectRatioLockEnabled = true
//
//                //隐藏旋转按钮
//                cropVC.rotateButtonsHidden = true
//
//                //隐藏复位按钮
//                cropVC.resetButtonHidden = true


                cropVC.delegate = self

                self.present(cropVC, animated: true)
            }
        }
    }
    
    func cropViewController(_ cropViewController: CropViewController,
                            didCropToImage image: UIImage,
                            withRect cropRect: CGRect,
                            angle: Int) {
        
        print("裁剪完成")

        cropViewController.dismiss(animated: true)

        detailView.userAvator.image = image

        if let path = ImageStorage.save(image) {

            person.avatorPath = path

            PersonStorage.save(person)
            
            print("保存成功")
        }
    }
    
    func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]
    ) {

        dismiss(animated: true)

        guard let image = info[.editedImage] as? UIImage else {
            return
        }

        detailView.userAvator.image = image

        if let path = ImageStorage.save(image) {

            person.avatorPath = path

            PersonStorage.save(person)
        }
    }
}

@available(iOS 17,*)
#Preview{
    PersonalHomepageController()
}


