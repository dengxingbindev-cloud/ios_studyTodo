import UIKit
import SnapKit

class PersonalHomepageView: UIView {
    
    var onAvatarTapped: (() -> Void)?
    
    private lazy var titleLabel : UILabel = {
        let label=UILabel()
        label.font=UIFont.systemFont(ofSize:28,weight:.bold)
        label.textAlignment = .center
        return label
    }()
    
    lazy var userAvator: UIImageView = {
        let avator = UIImageView()
        avator.contentMode = .scaleAspectFill
        avator.clipsToBounds = true
        //avator.layer.cornerRadius = avator.bounds.width / 2
        avator.layer.cornerRadius = 60
        avator.isUserInteractionEnabled = true
        
        let tap = UITapGestureRecognizer(
            target: self,
            action: #selector(avatarTapped)
        )

        avator.addGestureRecognizer(tap)
        
        return avator
    }()
    
    private lazy var nicknameLabel : UILabel = {
        let label=UILabel()
        label.font=UIFont.systemFont(ofSize:28,weight:.bold)
        label.textAlignment = .center
        return label
    }()
    
    private let aboutLabel:UITextView = {
        let textView = UITextView()
        textView.font = .systemFont(ofSize: 20,weight:.light)
        textView.textColor = UIColor.black
        textView.isEditable = false
        textView.textAlignment = .center
        textView.isScrollEnabled = false
        return textView
    }()
    
    private lazy var aboutView : UIView = {
        let container = UIView()
        container.layer.borderWidth = 2
        container.layer.borderColor = UIColor.systemCyan.cgColor
        container.layer.cornerRadius = 20
        
        container.addSubview(aboutLabel)
        
        aboutLabel.snp.makeConstraints{ make in
            make.edges.equalToSuperview().inset(20)
        }
        
        return container
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
        bindEvents()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func avatarTapped() {
        onAvatarTapped?()
    }
    
}

private extension PersonalHomepageView{
    func setupUI(){
        backgroundColor = .white
        
        addSubview(titleLabel)
        addSubview(userAvator)
        addSubview(nicknameLabel)
        addSubview(aboutView)
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(20)
            make.centerX.equalToSuperview()
            
        }
        
        userAvator.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(60)
            //make.left.right.equalToSuperview().inset(100)
            make.width.equalTo(120)
            make.height.equalTo(userAvator.snp.width)
            make.centerX.equalToSuperview()
        }
        
        nicknameLabel.snp.makeConstraints { make in
            make.top.equalTo(userAvator.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(100)
            make.centerX.equalToSuperview()
            
        }
        
        aboutView.snp.makeConstraints { make in
            make.top.equalTo(nicknameLabel.snp.bottom).offset(80)
            make.left.right.equalToSuperview().inset(20)
            make.centerX.equalToSuperview()
        }
    }
}

private extension PersonalHomepageView{
    func bindEvents(){
        
    }
}

extension PersonalHomepageView{
    func configure(with person: Person) {
        titleLabel.text = "个人资料卡"
        
        //默认头像和用户选择头像
        if person.avatorPath.isEmpty {
            userAvator.image = UIImage(named: "yuling")
        } else {
            userAvator.image = ImageStorage.load(path: person.avatorPath)
        }
        
        nicknameLabel.text = person.name

        aboutLabel.text = person.about
    }
}

@available(iOS 17,*)
#Preview{
    PersonalHomepageView()
}


