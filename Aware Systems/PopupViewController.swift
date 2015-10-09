import UIKit

class PopupViewController: UIViewController
{
    
    
    @IBAction func nineOneOneAction(sender: AnyObject) {
        
        
    }
    
    @IBAction func callContactOneAction(sender: AnyObject) {
        let url:NSURL = NSURL(string: "tel://7757454726")!
        UIApplication.sharedApplication().openURL(url)
    }
    
    @IBAction func callContactTwoAction(sender: AnyObject) {
        let url:NSURL = NSURL(string: "tel://3102001912")!
        UIApplication.sharedApplication().openURL(url)
        
    }

    @IBAction func callContactThreeAction(sender: AnyObject) {
        let url:NSURL = NSURL(string: "tel://5125899814")!
        UIApplication.sharedApplication().openURL(url)
    }
 
    
  override var preferredContentSize: CGSize {
    get {
      return CGSize(width: 150, height: 175)
    }
    set {
      super.preferredContentSize = newValue
    }
  }
}