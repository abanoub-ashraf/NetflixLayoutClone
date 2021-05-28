import UIKit

// takes the section and the type of the items
typealias MovieDataSource = UICollectionViewDiffableDataSource<MovieManager.Section, Movie>

/**
 * the Home View Controller
 */
class MovieFeedViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    private func setupView() {
        setupNavigationBarImage()
        
        // configure collectionview layout-
        // configure datasource
        // configureSnapshot
    }
    
    private func setupNavigationBarImage() {
        let logo = UIImage(named: "logo-navbar")
        
        let imageView = UIImageView(image: logo)
        imageView.contentMode = .scaleAspectFit
        
        self.navigationItem.titleView = imageView
    }

}

// MARK: -  -

extension MovieFeedViewController {
    
    func configureCollectionViewLayout() -> UICollectionViewCompositionalLayout {
        let sectionProvider = { (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            var section: NSCollectionLayoutSection?
            switch sectionIndex {
            case 0:
                getHighLightSection()
            default:
                getHighLightSection()
            }
            return section
        }
    }
    
    private func getHighLightSection() -> NSCollectionLayoutSection? {
        
    }
    
}
