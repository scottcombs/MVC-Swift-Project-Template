//___FILEHEADER___

import Cocoa

class Model: NSObject, NSCoding {
	// Internal Non-Saving Properties
	var document : Document?
	var windowController : NSWindowController?

	// App specific Saving Properties
	@IBOutlet var words : String! = "Words"

	// Convenience Initializer
	init(with document: Document) {
		super.init()
		self.document = document
		
	}

	required init?(coder aDecoder: NSCoder) {
		super.init()

		// Add Decoding
		self.words = aDecoder.decodeObject(forKey: "words") as? String
		
	}

	func encode(with aCoder: NSCoder) {
		// Add Encoding
		aCoder.encode(self.words, forKey: "words")

	}

}
