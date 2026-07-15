import UIKit
import SnapKit

final class AvatarActionViewController: UIViewController {

    // MARK: - 回调

    var albumHandler: (() -> Void)?
    var cameraHandler: (() -> Void)?
    var historyHandler: (() -> Void)?

    // MARK: - 当前头像

    var avatarImage: UIImage?

    // MARK: - UI

    /// 黑色背景
    private lazy var maskView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.45)

        let tap = UITapGestureRecognizer(target: self,
                                         action: #selector(dismissSelf))
        view.addGestureRecognizer(tap)

        return view
    }()

    /// 白色容器
    private let contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        view.layer.cornerRadius = 18
        view.clipsToBounds = true
        return view
    }()

    /// 当前头像
    private lazy var avatarView: UIImageView = {
        let imageView = UIImageView()

        imageView.image = avatarImage
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 60
        imageView.clipsToBounds = true

        return imageView
    }()

    private lazy var albumButton = makeButton(title: "从相册选择")
    private lazy var cameraButton = makeButton(title: "拍照")
    private lazy var historyButton = makeButton(title: "历史头像")
    private lazy var cancelButton = makeButton(title: "取消")

    private var bottomConstraint: Constraint?

    // MARK: -

    override func viewDidLoad() {
        super.viewDidLoad()

        modalPresentationStyle = .overFullScreen
        view.backgroundColor = .clear

        setupUI()
        bindEvents()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        showAnimation()
    }
}

// MARK: - UI

private extension AvatarActionViewController {

    func setupUI() {

        view.addSubview(maskView)
        view.addSubview(contentView)

        maskView.snp.makeConstraints {maker in
            maker.edges.equalToSuperview()
        }

        contentView.snp.makeConstraints {maker in

            maker.left.right.equalToSuperview().inset(20)

            bottomConstraint = maker.bottom.equalToSuperview().offset(400).constraint
        }

        contentView.addSubview(avatarView)

        avatarView.snp.makeConstraints {maker in
            maker.top.equalToSuperview().offset(20)
            maker.centerX.equalToSuperview()
            maker.width.height.equalTo(120)
        }

        let stack = UIStackView(arrangedSubviews: [
            albumButton,
            cameraButton,
            historyButton,
            cancelButton
        ])

        stack.axis = .vertical
        stack.spacing = 1
        stack.distribution = .fillEqually

        contentView.addSubview(stack)

        stack.snp.makeConstraints {maker in
            maker.top.equalTo(avatarView.snp.bottom).offset(20)
            maker.left.right.bottom.equalToSuperview()
            maker.height.equalTo(220)
        }
    }

    func makeButton(title: String) -> UIButton {

        let btn = UIButton(type: .system)

        btn.setTitle(title, for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: 18)

        btn.backgroundColor = .secondarySystemBackground

        return btn
    }
}

// MARK: - Event

private extension AvatarActionViewController {

    func bindEvents() {

        albumButton.addTarget(self,
                              action: #selector(albumClick),
                              for: .touchUpInside)

        cameraButton.addTarget(self,
                               action: #selector(cameraClick),
                               for: .touchUpInside)

        historyButton.addTarget(self,
                                action: #selector(historyClick),
                                for: .touchUpInside)

        cancelButton.addTarget(self,
                               action: #selector(dismissSelf),
                               for: .touchUpInside)
    }

    @objc
    func albumClick() {

        dismiss(animated: false) {
            self.albumHandler?()
        }
    }

    @objc
    func cameraClick() {

        dismiss(animated: false) {
            self.cameraHandler?()
        }
    }

    @objc
    func historyClick() {

        dismiss(animated: false) {
            self.historyHandler?()
        }
    }

    @objc
    func dismissSelf() {

        hideAnimation()
    }
}

// MARK: - Animation

private extension AvatarActionViewController {

    func showAnimation() {

        maskView.alpha = 0

        self.bottomConstraint?.update(offset: -30)

        UIView.animate(withDuration: 0.25) {

            self.maskView.alpha = 1
            self.view.layoutIfNeeded()
        }
    }

    func hideAnimation() {

        self.bottomConstraint?.update(offset: 400)

        UIView.animate(withDuration: 0.25) {

            self.maskView.alpha = 0
            self.view.layoutIfNeeded()

        } completion: { _ in

            self.dismiss(animated: false)
        }
    }
}
