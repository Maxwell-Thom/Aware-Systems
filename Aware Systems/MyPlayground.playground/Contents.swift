import Foundation
import XCPlayground


func httpGet(request: NSURLRequest!, callback: (String, String?) -> Void) {
    var session = NSURLSession.sharedSession()
    var task = session.dataTaskWithRequest(request){
        (data, response, error) -> Void in
            var result = NSString(data: data, encoding:
                NSASCIIStringEncoding)!
            callback(result as String, nil)
}
}
var request = NSMutableURLRequest(URL: NSURL(string: "https://mighty-brushlands-7150.herokuapp.com/users")!);

    httpGet(request){
        (data, error) -> Void in
        if error != nil {
            println(error)
        } else {
            println(data)
        }
    }
    XCPSetExecutionShouldContinueIndefinitely(continueIndefinitely: true)


