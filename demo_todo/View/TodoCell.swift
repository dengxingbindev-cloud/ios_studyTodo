import UIKit
import SnapKit

class TodoCell: UITableViewCell {

    static let identifier = "TodoCell"

    private let titleLabel = UILabel()

    override init(style: UITableViewCell.CellStyle,
                  reuseIdentifier: String?) {

        super.init(style: style,
                   reuseIdentifier: reuseIdentifier)

        contentView.addSubview(titleLabel)

        titleLabel.snp.makeConstraints {

            $0.left.equalToSuperview().offset(20)
            $0.centerY.equalToSuperview()

        }

    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    func configure(with todo: Todo) {

        if todo.isCompleted {

            titleLabel.text = "✅ \(todo.title)"

        } else {

            titleLabel.text = "⬜️ \(todo.title)"

        }

    }

}
