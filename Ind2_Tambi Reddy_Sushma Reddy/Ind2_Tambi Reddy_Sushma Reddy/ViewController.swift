import UIKit

class ViewController: UIViewController {
   
    @IBOutlet var image0: UIImageView!
    @IBOutlet var image1: UIImageView!
    @IBOutlet var image2: UIImageView!
    @IBOutlet var image3: UIImageView!
    @IBOutlet var image4: UIImageView!
    @IBOutlet var image5: UIImageView!
    @IBOutlet var image6: UIImageView!
    @IBOutlet var image7: UIImageView!
    @IBOutlet var image8: UIImageView!
    @IBOutlet var image9: UIImageView!
    @IBOutlet var image10: UIImageView!
    @IBOutlet var image11: UIImageView!
    @IBOutlet var image12: UIImageView!
    @IBOutlet var image13: UIImageView!
    @IBOutlet var image14: UIImageView!
    @IBOutlet var image15: UIImageView!
    @IBOutlet var image16: UIImageView!
    @IBOutlet var image17: UIImageView! // blank block
    @IBOutlet var image18: UIImageView!
    @IBOutlet var image19: UIImageView!
    
// watched youtube tutorial to get an idea on blurview and popupview
    @IBAction func showanswer(_ sender: Any) {
        animateIn(desiredview: blurview)
        animateIn(desiredview: popupview)
    }
    
    @IBAction func hideanswer(_ sender: Any) {
        animateOut(desiredview: popupview)
        animateOut(desiredview: blurview)
    }
    
    @IBAction func playAgain(_ sender: Any) {
        animateOut(desiredview: winningview)
    }
        
    @IBOutlet var winningview: UIView! // popup view when the user solves the puzzle
    
    @IBOutlet var blurview: UIVisualEffectView! // will blur the background
    
    @IBOutlet var popupview: UIView! // will show a popup view of the answer
    
    @IBOutlet var shuffle: UIButton! // button to shuffle image views
    
    //function to display blur effect and popup view
    func animateIn(desiredview: UIView){
        let backgroundview = self.view!
        
        backgroundview.addSubview(desiredview)
        
        desiredview.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        desiredview.alpha = 0
        desiredview.center = backgroundview.center
        
        UIView.animate(withDuration: 0.3, animations: {
            desiredview.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            desiredview.alpha = 1
        })
    }
    
    //function to get back to main page after viewing the answer
    func animateOut(desiredview: UIView){
        UIView.animate(withDuration: 0.3, animations: {
            desiredview.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
            desiredview.alpha = 0
        }, completion: { _ in
            desiredview.removeFromSuperview()
        })
    }
    
    private var imagearray = [UIImageView]() // An array that consists of all the images
    
    private var blankblock: CGPoint! // Position of the blank block
    
    private var correctPositions = [CGPoint]() // An array where images are in correct positions
    
    private var correctAnswer = true // if the images are in correct positions we will change the shuffle button to "You Win :D shuffle again"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        blurview.bounds = self.view.bounds
            
        popupview.bounds = CGRect(x: 0, y: 0, width: self.view.bounds.width * 0.9, height: self.view.bounds.height * 0.4)
        
        // Setting the images array
        imagearray = [image0, image1, image2, image3, image4, image5, image6, image7, image8, image9, image10, image11, image12, image13, image14, image15, image16, image17, image18, image19]
        
        for image in imagearray {
            image.isUserInteractionEnabled = true // setting up userInteration for all image views
            image.addGestureRecognizer(setupTapGesture()) // setting up tap gestures for all image views
            correctPositions.append(image.center) // adding correct positions of images into the array
        }
        blankblock = image17.center // Passing the empty image center to emptyCenter var
    }

    @IBAction func clickshuffle(_ sender: UIButton) {
    shuffle.setTitle("Shuffle", for: .normal)
        randomShuffle() // Shuffles the images
    }
}

extension ViewController {
    private func setupTapGesture() -> UITapGestureRecognizer {
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(clickImage(_:))) // Creating the tap gesture with it's action
        return tapRecognizer
    }
    
    @objc private func clickImage(_ sender: UITapGestureRecognizer) {
        guard correctAnswer == false
            else {
                return // checking if images are shuffled and not in correct position
                 }
        guard sender.view != image17
            else {
                return // no action takes place if blank block is clicked
                }
        if Horizontal(image: sender.view as! UIImageView) { // if image can be moved horizontally we swap it with the blank block
            swapImageWithBlankBlock(image: sender.view as! UIImageView)
        }
        else if Vertical(image: sender.view as! UIImageView) { // if image can be moves vertically we swap it with the blank block
            swapImageWithBlankBlock(image: sender.view as! UIImageView)
        }
        correctanswer()
    }
    
    // function to move the image horizontally
    private func Horizontal(image: UIImageView) -> Bool {
    
        if image.center.x - blankblock.x == 95 || blankblock.x - image.center.x == 95 {
            guard image.center.y - blankblock.y == 0, blankblock.y - image.center.y == 0
            else {
                return false // images moves in horizontal manner
                 }
            return true
        }
        return false
    }
    
    //function to move the image vertically
    private func Vertical(image: UIImageView) -> Bool {
        
        if image.center.y - blankblock.y == 95 || blankblock.y - image.center.y == 95 {
            guard image.center.x - blankblock.x == 0, blankblock.x - image.center.x == 0
            else {
                return false // images moves in vertical manner
                 }
            return true
        }
        return false
    }
    
    // function to swap blank block with the image that is clicked
    private func swapImageWithBlankBlock(image: UIImageView) {
        UIView.animate(withDuration: 0.5) { // will swap the images in 0.5 time
            self.image17.center = image.center // swapping the positions of both images
            image.center = self.blankblock // assigning clicked image position to blank block position
        }
        self.blankblock = self.image17.center // assigning the new position to blank block for next action to procees accordingly
    }
    
    // function to shuffle the images
    private func randomShuffle() {
        var numberOfSwapsRequired = 15 // shuffling the images 15 times
        while numberOfSwapsRequired > 0 {
            let image = imagearray.randomElement()!
            guard image != image17
                else {
                    continue
                    }
            if Horizontal(image: image) || Vertical(image: image) {
                swapImageWithBlankBlock(image: image)
                numberOfSwapsRequired -= 1
            }
        }
        correctAnswer = false // making sure the the images are shuffled
    }
    
    private func correctanswer() {
        var solved = true
        for (index, image) in imagearray.enumerated() { // capturing an image's index
            if image.center != correctPositions[index] { // we are checking if the index are in correct position
                solved = false
                break
            }
        }
        if solved {
            correctAnswer = true
            animateIn(desiredview: winningview) // display popup view to show that the user Won the game
        }
    }
}


