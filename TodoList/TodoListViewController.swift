import UIKit

class TodoListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var todoList: [Todo] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self

        loadTodoList()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadTodoList()
        tableView.reloadData()
    }

    func loadTodoList() {
        if let data = UserDefaults.standard.data(forKey: "todoList"),
           let decoded = try? JSONDecoder().decode([Todo].self, from: data) {
            todoList = decoded
            tableView.reloadData()
        }
    }
}

// MARK: - UITableViewDataSource & Delegate
extension TodoListViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoList.count
    }
    
    // 스와이프 삭제 기능
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // 1. 데이터 삭제
            todoList.remove(at: indexPath.row)

            // 2. UserDefaults에 저장
            if let encoded = try? JSONEncoder().encode(todoList) {
                UserDefaults.standard.set(encoded, forKey: "todoList")
            }

            // 3. 테이블 뷰에서 해당 셀 삭제
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }


    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(withIdentifier: "todoCell", for: indexPath) as? TodoTableViewCell else {
            return UITableViewCell()
        }

        let todo = todoList[indexPath.row]
        cell.titleLabel.text = todo.title
        cell.dueDateLabel.text = getDdayString(from: todo.dueDate)
        cell.detailLabel.text = todo.detail

        return cell
    }

    func getDdayString(from date: Date) -> String {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let target = calendar.startOfDay(for: date)

        let components = calendar.dateComponents([.day], from: today, to: target)
        guard let dDay = components.day else { return "" }

        if dDay > 0 {
            return "D-\(dDay)"
        } else if dDay == 0 {
            return "D-DAY"
        } else {
            return "D+\(-dDay)"
        }
    }
}
