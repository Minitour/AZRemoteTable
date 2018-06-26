# AZRemoteTable

[![CocoaPods](https://img.shields.io/cocoapods/v/AZRemoteTable.svg)]()
[![CocoaPods](https://img.shields.io/cocoapods/l/AZRemoteTable.svg)]()
[![CocoaPods](https://img.shields.io/cocoapods/p/AZRemoteTable.svg)]()

## Features
- [x] Automatic "Load More" 🚀
- [x] Pull To Refresh Support 🎯
- [x] Error Handling 🕸
- [x] Custom View and Sub-classing 🎨

## Installation


```
pod 'AZRemoteTable'
```

Or simply drag and drop ```Sources``` folder to your project.

## Usage


### Step #1: Create a Data Source 
```swift
class CustomRemoteDataSource: AZRemoteTableDataSource {

    //An array in which we will store the data.
    fileprivate var items: [String] = []


    /// Helper function to add items.
    public func addItems(items: [String]){
        for item in items { self.items.append(item) }
    }

    /// Helper function to clear items.
    public func clearItems() {
        items.removeAll()
        reset()
    }

    // MARK: - AZRemoteTableDataSource

    override func cellForRowAt(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        //simple implementation of cellForRowAt:
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        cell.textLabel?.text = items[indexPath.row]
        return cell
    }

    override func numberOfRowsInSection(_ tableView: UITableView, section: Int) -> Int {
        //return the number of items currently held.
        return items.count
    }
}
```

### Step #2: Create a Delegate 
```swift
class CustomRemoteDelegate: AZRemoteTableDelegate {
    override func tableView(_ tableView: UITableView,
                            didRequestPage page: Int,
                            usingRefreshControl: Bool) {

        // Make an API call.
        APIManager.shared.loadData(id: "a9dd9e00-55f8-4ce8-8ada-8e933d052e3a",
                                   token: "b54695d5-6f98-442f-9b39-4509fcd8aacd",
                                   page: page,
                                   itemsPerPage: 30) { (message, data, error) in

            //check for errors
            if error {
                //error found, notify table
                tableView.remote.notifyError()
            }else {
                //all good, data fetched, add it to the data source.
                let dataSource = tableView.remote.dataSource as? CustomRemoteDataSource

                //clear all items if we used pull to refresh
                if usingRefreshControl { dataSource?.clearItems() }

                //update data source
                dataSource?.addItems(items: data)

                //notify table that we are done, and if we have more data to load.
                tableView.remote.notifySuccess(hasMore: true)
            }
        }
    }
}
```

### Step #3: Use it in your controller

```swift
class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    let delegate = CustomRemoteDelegate()
    let dataSource = CustomRemoteDataSource()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = delegate
        tableView.dataSource = dataSource
        tableView.remote.initialLoad()
    }
}
```
