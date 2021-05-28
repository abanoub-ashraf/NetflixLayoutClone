import UIKit

// takes the section and the type of the items
typealias MovieDataSource = UICollectionViewDiffableDataSource<MovieManager.Section, Movie>

/**
 * the Home View Controller
 */
class MovieFeedViewController: UIViewController {
    
    private var dataSource: MovieDataSource!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    private func setupView() {
        setupNavigationBarImage()
        
        collectionView.register(
            TitleHeader.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: TitleHeader.reuseIdentifier
        )
        
        collectionView.collectionViewLayout = configureCollectionViewLayout()
        
        configureDataSource()
        
        configureSnapshot()
        
        collectionView.delegate = self
        
        self.navigationController?.hidesBarsOnSwipe = true
    }
    
    private func setupNavigationBarImage() {
        let logo = UIImage(named: "logo-navbar")
        
        let imageView = UIImageView(image: logo)
        imageView.contentMode = .scaleAspectFit
        
        self.navigationItem.titleView = imageView
    }

}

// MARK: - UICollectionViewCompositionalLayout -

extension MovieFeedViewController {
    
    // configure the collection view compositional layout
    func configureCollectionViewLayout() -> UICollectionViewCompositionalLayout {
        
        // configure the sections
        let sectionProvider = { (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            
            var section: NSCollectionLayoutSection?
            
            switch sectionIndex {
                case 0:  section = self.getHighLightSection()
                case 1:  section = self.getPreviewSection()
                default: section = self.getRecommendationsSection()
            }
            
            return section
        }
        
        return UICollectionViewCompositionalLayout(sectionProvider: sectionProvider)
    }
    
    // configure each section inside the collection view
    private func getHighLightSection() -> NSCollectionLayoutSection? {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalHeight(1)
        )
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalHeight(0.3)
        )
        
        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: groupSize,
            subitems: [item]
        )
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPaging
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
        
        return section
    }
    
    private func getPreviewSection() -> NSCollectionLayoutSection? {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalHeight(1)
        )
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 15, leading: 0, bottom: 0, trailing: 0)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.3),
            heightDimension: .fractionalHeight(0.2)
        )
        
        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: groupSize,
            subitems: [item]
        )
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
        section.boundarySupplementaryItems = getHeader()
        
        return section
    }
    
    private func getRecommendationsSection() -> NSCollectionLayoutSection? {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalHeight(1)
        )
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 15, leading: 10, bottom: 0, trailing: 0)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.3),
            heightDimension: .fractionalHeight(0.22)
        )
        
        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: groupSize,
            subitems: [item]
        )
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
        section.boundarySupplementaryItems = getHeader()
        
        return section
    }
    
    // configure the title of each section
    private func getHeader() -> [NSCollectionLayoutBoundarySupplementaryItem] {
        let headerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .estimated(44)
        )
        
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .topLeading
        )
        
        return [sectionHeader]
    }
    
}

// MARK: - UICollectionViewDiffableDataSource -

extension MovieFeedViewController {
    
    func configureDataSource() {
        
        // configure the content of each cell
        dataSource = MovieDataSource(collectionView: collectionView, cellProvider: { (collectionView: UICollectionView, indexPath: IndexPath, movie: Movie) -> UICollectionViewCell? in
            
            var reuseIdentifier: String
            
            // each cell is gonna have different section
            switch indexPath.section {
                case 0:  reuseIdentifier = HighlightCell.reuseIdentifier
                case 1:  reuseIdentifier = PreviewCell.reuseIdentifier
                case 2:  reuseIdentifier = RecommendationsCell.reuseIdentifier
                default: reuseIdentifier = RecommendationsCell.reuseIdentifier
            }
            
            // use the cell tha matches the selected identifier above
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: reuseIdentifier,
                for: indexPath
            ) as? MovieCell else {
                return nil
            }
            
            let section = MovieManager.Section.allCases[indexPath.section]
            
            cell.showMovie(movie: MovieManager.movies[section]?[indexPath.item])
            
            return cell
        })
        
        // configure the content of the header of each cell
        dataSource.supplementaryViewProvider = { [weak self] (collectionView: UICollectionView, kind: String, indexPath: IndexPath) -> UICollectionReusableView? in
            if
                let self = self,
                let headerSupplementaryView = collectionView.dequeueReusableSupplementaryView(
                    ofKind: UICollectionView.elementKindSectionHeader,
                    withReuseIdentifier: TitleHeader.reuseIdentifier,
                    for: indexPath
                ) as? TitleHeader {
                
                let section = self.dataSource.snapshot().sectionIdentifiers[indexPath.section]
                
                headerSupplementaryView.textLabel.text = section.rawValue
                
                return headerSupplementaryView
            }
            return nil
        }
    }
    
    func configureSnapshot() {
        var currentSnapshot = NSDiffableDataSourceSnapshot<MovieManager.Section, Movie>()
        MovieManager.Section.allCases.forEach { collection in
            currentSnapshot.appendSections([collection])
            if let movies = MovieManager.movies[collection] {
                currentSnapshot.appendItems(movies)
            }
        }
        dataSource.apply(currentSnapshot, animatingDifferences: true, completion: nil)
    }
    
}

// MARK: - UICollectionViewDelegate -

extension MovieFeedViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let movie = dataSource.itemIdentifier(for: indexPath)
        print(movie?.title ?? "movie title is nil")
    }
    
}
