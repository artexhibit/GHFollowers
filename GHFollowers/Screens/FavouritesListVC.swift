import UIKit

class FavouritesListVC: GFDataLoadingVC {
    
    let tableView = UITableView()
    var favourites: [Follower] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        configureTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getFavourites()
    }
    
    @available(iOS 17.0, *)
    override func updateContentUnavailableConfiguration(using state: UIContentUnavailableConfigurationState) {
        if favourites.isEmpty {
            var config = UIContentUnavailableConfiguration.empty()
            config.image = UIImage(systemName: "star")
            config.text = "No favourites"
            config.secondaryText = "Add a favourite on the follower list screen"
            contentUnavailableConfiguration = config
        } else {
            contentUnavailableConfiguration = nil
        }
    }
    
    func configureViewController() {
        view.backgroundColor = .systemBackground
        title = "Favourites"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    func configureTableView() {
        view.addSubview(tableView)
        tableView.frame = view.bounds
        tableView.rowHeight = 80
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(FavouriteCell.self, forCellReuseIdentifier: FavouriteCell.reuseID)
    }
    
    func getFavourites() {
        PersistenceManager.retrieveFavourites { [weak self] result in
            guard let self else { return }
            
            switch result {
            case .success(let favourites):
                self.updateUI(with: favourites)
                
            case .failure(let error):
                DispatchQueue.main.async {
                    self.presentGFAlert(title: "Something went wrong", message: error.rawValue, buttonTitle: "OK")
                }
            }
        }
    }
    
    func updateUI(with favourites: [Follower]) {
        if #available(iOS 17.0, *) {
            self.favourites = favourites
            setNeedsUpdateContentUnavailableConfiguration()
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.view.bringSubviewToFront(self.tableView)
            }
        } else {
            if favourites.isEmpty {
                showEmptyStateView(with: "No Favourites?\nAdd on the follower screen", view: self.view)
            } else {
                self.favourites = favourites
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    self.view.bringSubviewToFront(self.tableView)
                }
            }
        }
    }
}

extension FavouritesListVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        favourites.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FavouriteCell.reuseID) as! FavouriteCell
        cell.set(favourite: favourites[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let favourite = favourites[indexPath.row]
        let destVC = FollowerListVC(username: favourite.login)
        
        navigationController?.pushViewController(destVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }
        
        PersistenceManager.updateWith(favourite: favourites[indexPath.row], actionType: .remove) { [weak self] error in
            guard let self else { return }
            guard let error = error else {
                self.favourites.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .left)
                
                if #available(iOS 17.0, *) {
                    setNeedsUpdateContentUnavailableConfiguration()
                } else {
                    if self.favourites.isEmpty { showEmptyStateView(with: "No Favourites?\nAdd on the follower screen", view: self.view) }
                }
                return
            }
            DispatchQueue.main.async {
                self.presentGFAlert(title: "Unable to remove", message: error.rawValue, buttonTitle: "OK")
            }
        }
    }
}
