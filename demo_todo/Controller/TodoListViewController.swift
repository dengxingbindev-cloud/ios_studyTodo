import UIKit
import SnapKit

class TodoListViewController: UIViewController {

    // MARK: - Data

    private var todos: [Todo] = []

    // MARK: - UI
    
    private lazy var detailLabelTo:UILabel = {
        let label = UILabel()
        label.text = "个人主页"
        label.textAlignment = .center
        label.isUserInteractionEnabled = true
        
        let tap = UITapGestureRecognizer(target:self,action:#selector(labelTapped))
        label.addGestureRecognizer(tap)
        
        return label
    }()

    private lazy var textField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "请输入待办事项"
        tf.borderStyle = .roundedRect
        return tf
    }()

    private lazy var addButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("添加", for: .normal)
        btn.addTarget(self,
                      action: #selector(addTodo),
                      for: .touchUpInside)
        return btn
    }()

    private lazy var tableView: UITableView = {
        let table = UITableView(frame: .zero,
                                style: .plain)

        table.delegate = self
        table.dataSource = self

        table.register(
            TodoCell.self,
            forCellReuseIdentifier: TodoCell.identifier
        )

        table.tableFooterView = UIView()

        return table
    }()

    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        

        title = "Todo List"

        view.backgroundColor = .white

        setupUI()

        // 先读取本地
        todos = TodoStorage.load()

        tableView.reloadData()

        // 再同步服务器
        TodoNetwork.load { [weak self] list in

            guard let self else { return }

            self.todos = list

            TodoStorage.save(list)

            self.tableView.reloadData()

        }
    }

    // MARK: - UI

    private func setupUI() {

        view.addSubview(textField)
        view.addSubview(addButton)
        view.addSubview(tableView)
        view.addSubview(detailLabelTo)

        detailLabelTo.snp.makeConstraints {maker in

            maker.top.equalTo(view.safeAreaLayoutGuide).offset(-10)

            maker.right.equalTo(addButton.snp.right).offset(-10)

            maker.height.equalTo(30)
            
            maker.width.equalTo(80)

        }
        
        textField.snp.makeConstraints {maker in

            maker.top.equalTo(view.safeAreaLayoutGuide).offset(40)

            maker.left.equalToSuperview().offset(20)

            maker.right.equalTo(addButton.snp.left).offset(-10)

            maker.height.equalTo(40)

        }

        addButton.snp.makeConstraints {maker in

            maker.centerY.equalTo(textField)

            maker.right.equalToSuperview().offset(-20)

            maker.width.equalTo(60)

        }

        tableView.snp.makeConstraints {maker in

            maker.top.equalTo(textField.snp.bottom).offset(20)

            maker.left.right.bottom.equalToSuperview()

        }

    }

    // MARK: - Event

    @objc
    private func addTodo() {

        guard let text = textField.text,
              !text.trimmingCharacters(in: .whitespaces).isEmpty else {

            return

        }

        let todo = Todo(title: text)

        todos.append(todo)

        TodoStorage.save(todos)
        
        TodoNetwork.save(todo)

        tableView.reloadData()

        textField.text = ""

        textField.resignFirstResponder()

    }
    
    @objc
    func labelTapped(){
        let vc = PersonalHomepageController()
        navigationController?.pushViewController(vc, animated: true)
        print("点我干嘛")
    }

}

// MARK: - UITableViewDataSource

extension TodoListViewController: UITableViewDataSource {

    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {

        return todos.count

    }

    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: TodoCell.identifier,
            for: indexPath
        ) as? TodoCell else {

            return UITableViewCell()

        }

        cell.configure(with: todos[indexPath.row])

        return cell

    }

}

// MARK: - UITableViewDelegate

extension TodoListViewController: UITableViewDelegate {

    // 点击切换完成状态
    func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {

        tableView.deselectRow(at: indexPath,
                              animated: true)

        todos[indexPath.row].isCompleted.toggle()

        TodoStorage.save(todos)
        
        TodoNetwork.update(todos[indexPath.row])

        tableView.reloadRows(
            at: [indexPath],
            with: .automatic
        )

    }

    // 左滑删除
    func tableView(
        _ tableView: UITableView,
        commit editingStyle: UITableViewCell.EditingStyle,
        forRowAt indexPath: IndexPath
    ) {

        guard editingStyle == .delete else {

            return

        }

        let todo = todos[indexPath.row]

        todos.remove(at: indexPath.row)

        TodoStorage.save(todos)

        TodoNetwork.delete(todo)

        tableView.deleteRows(
            at: [indexPath],
            with: .automatic
        )

    }

}

@available(iOS 17,*)
#Preview{
    TodoListViewController()
}
