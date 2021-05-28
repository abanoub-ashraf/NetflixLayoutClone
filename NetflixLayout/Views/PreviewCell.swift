import UIKit

class PreviewCell: UICollectionViewCell, MovieCell {
    
    static let reuseIdentifier = String(describing: PreviewCell.self)
    
    var gradientAdded = false
    
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var title: UILabel!
    
    func showMovie(movie: Movie?) {
        image.makeRounded(borderColor: #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1))

        if !gradientAdded {
            gradientAdded = true
            image.addGradient()
        }
        
        image.image = movie?.thumbnail
        title.text = movie?.title
    }
    
}
