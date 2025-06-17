//
//  AddTodoViewController.swift
//  TodoList
//
//  Created by KS on 6/16/25.
struct Todo: Codable {
    var title: String
    var dueDate: Date
    var detail: String
}


import UIKit

class AddTodoViewController: UIViewController {

    @IBOutlet weak var detailTextView: UITextView!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var titleTextField: UITextField!
    @IBAction func saveButtonTapped(_ sender: UIButton) {
        guard let title = titleTextField.text, !title.isEmpty else { return }
        let dueDate = datePicker.date
        let detail = detailTextView.text ?? ""

        let newTodo = Todo(title: title, dueDate: dueDate, detail: detail)

        var todoList = fetchTodoList()
        todoList.append(newTodo)

        if let encoded = try? JSONEncoder().encode(todoList) {
            UserDefaults.standard.set(encoded, forKey: "todoList")
        }

        // 입력 초기화
        titleTextField.text = ""
        detailTextView.text = ""
    }
    override func viewDidLoad() {
            super.viewDidLoad()
            // Do any additional setup after loading the view.
        }

        // ✅ 이건 클래스 내부에 있지만 viewDidLoad() 바깥에 위치해야 해!
        func fetchTodoList() -> [Todo] {
            if let data = UserDefaults.standard.data(forKey: "todoList"),
               let decoded = try? JSONDecoder().decode([Todo].self, from: data) {
                return decoded
            }
            return []
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */


