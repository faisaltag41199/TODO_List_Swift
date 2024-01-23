//
//  TasksViewController.swift
//  taskapp_swift_workshop
//
//  Created by Faisal TagEldeen on 05/01/2024.
//

import UIKit

class TasksViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate {
 
    var tasks:[Task] = [];
    let userDefaults=UserDefaults.standard;
    var statusTasks:[Task] = []
    var tempTasksArrayForSearch:[Task] = []

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate=self;
        tableView.dataSource=self;
        searchBar.delegate=self;

    }
    
    override func viewWillAppear(_ animated: Bool) {
                
        print("get data will appear")
        reloadTasksFromUserDeafults()
    }
    
    func reloadTasksFromUserDeafults(){
        do {
            
            let retrievedObject = userDefaults.data(forKey:"Stored_Tasks_Key")
            if(retrievedObject == nil){
                
                tasks = []
            }else{
                
                tasks = try JSONDecoder().decode([Task].self, from: retrievedObject!)
            }
                   
           }
           catch {
             print(error)
           }
        
        statusTasks=[]
        
        for temp in tasks {
            if temp.status == "New" {
                statusTasks.append(temp)
            }
        }
        
        tempTasksArrayForSearch = tasks
        
        tableView.reloadData()
    }
    
    
    @IBAction func goToAddEditTaskScreen(_ sender: Any) {
        
        if let addEditVC = self.storyboard?.instantiateViewController(withIdentifier: "addEditVC") as? AddEditTaskViewController {
            addEditVC.editTask = false
            self.navigationController?.pushViewController(addEditVC, animated: true)
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchText.isEmpty {
            print("data empty everything back ya zmeely")
            reloadTasksFromUserDeafults()
            
        } else {
            
            print("your search text is : \(searchText)")
            statusTasks = [Task]()
            
            for tempSearchTask in tempTasksArrayForSearch {
                let isContainAllCharInUpperCase = tempSearchTask.title?.uppercased().contains(searchText.uppercased())
                let isContainAllCharInLowerCase = tempSearchTask.title?.lowercased().contains(searchText.lowercased())
                
                if isContainAllCharInUpperCase == true || isContainAllCharInLowerCase == true{
                    statusTasks.append(tempSearchTask)
                }
            }
            
            tableView.reloadData()
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return statusTasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
       let cell = tableView.dequeueReusableCell(withIdentifier: "addedTaskCell")
       let task = statusTasks[indexPath.row]
       var image: UIImage?
            
       if task.priority == "Low" {
            image = UIImage(named: "low.png")
        } else if task.priority == "Medium" {
            image = UIImage(named: "med.png")
        } else {
            image = UIImage(named: "high.png")
        }
        
        cell?.imageView?.image = image
        cell?.textLabel?.text = task.title
            
        return cell ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let addEditVC = storyboard?.instantiateViewController(withIdentifier: "addEditVC") as? AddEditTaskViewController {
            
            addEditVC.editTask = true
            addEditVC.task = statusTasks[indexPath.row]
            navigationController?.pushViewController(addEditVC, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true;
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle==UITableViewCell.EditingStyle.delete {
            
            showAlert(message: "Do you want to delete this task", title: "delete task ", forRowAtIndexPath: indexPath)
        }
    }
    
    func showAlert(message: String,title: String,forRowAtIndexPath indexPath: IndexPath) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)

        let okAction = UIAlertAction(title: "OK", style: .default) { [weak self] _ in
            guard let self = self else { return }

            self.deleteTask(removedTask: self.statusTasks[indexPath.row])
            print("ok////")
        }

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in
            print("cancel////")
        }

        alertController.addAction(okAction)
        alertController.addAction(cancelAction)

        present(alertController, animated: true, completion: nil)
    }

    func deleteTask(removedTask:Task){
        
        do {
            //retrieve
            let retrievedObject = userDefaults.data(forKey:"Stored_Tasks_Key")
            var temporaryRetrivedTasks:[Task] = try JSONDecoder().decode([Task].self, from: retrievedObject!)
            
            var newTasksAfterDelete:[Task] = []
            // delete and update
            
            for oldTask in temporaryRetrivedTasks {
                if oldTask.taskId == removedTask.taskId {
                    continue
                } else {
                    newTasksAfterDelete.append(oldTask)
                    print("oldTask")
                }
            }
            //store
            let newData = try? JSONEncoder().encode(newTasksAfterDelete)
            userDefaults.set(newData, forKey:"Stored_Tasks_Key")

           } catch {
             print(error)
           }

        print("go to reload data")
        reloadTasksFromUserDeafults()
    }

}
