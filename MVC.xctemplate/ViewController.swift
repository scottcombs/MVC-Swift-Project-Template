//___FILEHEADER___

import Cocoa

class ViewController: NSViewController {
	@IBOutlet var model : Model?
	@IBOutlet var wordsTextField: NSTextField!

	override func viewDidLoad() {
		// Do any additional setup after loading the view.
		if let m = self.model {
			wordsTextField.stringValue = m.words
		}
	}

	override var representedObject: Any? {
		didSet {
			// Update the view, if already loaded.
			self.model = self.representedObject as? Model
			self.wordsTextField.stringValue = (self.model?.words)!
		}
	}

}

