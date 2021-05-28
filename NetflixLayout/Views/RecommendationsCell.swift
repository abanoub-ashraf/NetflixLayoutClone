import UIKit

class RecommendationsCell: UICollectionViewCell, MovieCell {
    
    static let reuseIdentifier = String(describing: RecommendationsCell.self)
    
    @IBOutlet weak var image: UIImageView!
    
    func showMovie(movie: Movie?) {
        image.image = movie?.thumbnail
    }
    
}
