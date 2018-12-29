//___FILEHEADER___

import Cocoa

class Document: NSDocument {
	var model : Model?

	override init() {
	    super.init()
		// Add your subclass-specific initialization here.
		self.model = Model(with: self)
	}

	override class var autosavesInPlace: Bool {
		return true
	}

	override func makeWindowControllers() {
		// Returns the Storyboard that contains your Document window.
		let storyboard = NSStoryboard(name: NSStoryboard.Name("Main"), bundle: nil)
		let windowController = storyboard.instantiateController(withIdentifier: NSStoryboard.SceneIdentifier("Document Window Controller")) as! NSWindowController

		// Set the Window Controller into the Model
		self.model?.windowController = windowController

		// Set the model to the View Controller
		windowController.contentViewController?.representedObject = self.model

		self.addWindowController(windowController)
	}

	override func data(ofType typeName: String) throws -> Data {
		if typeName == "___VARIABLE_documentExtension___" {
			return try NSKeyedArchiver.archivedData(withRootObject: self.model!, requiringSecureCoding: false)
		}else{
			throw NSError(domain: NSOSStatusErrorDomain, code: unimpErr, userInfo: nil)
		}
	}

	override func read(from data: Data, ofType typeName: String) throws {
		if typeName == "___VARIABLE_documentExtension___" {
			if let aModel : Model = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? Model {
				// Set specific data from model
				// DO NOT SET model.document & model.windowController

				// Migrate values from local Model to self's Model
				self.model?.words = aModel.words

				// Set the View Controller's representedObject to the new Model
				self.model?.windowController?.contentViewController?.representedObject = self.model
			}
		}else{
			throw NSError(domain: NSOSStatusErrorDomain, code: unimpErr, userInfo: nil)
		}
	}

	@IBAction override func save(_ sender: Any?) {
		// First Responder to save a file
		if let wc = NSApp.keyWindow?.windowController {
			if let document = wc.document as? Document {
				if document.fileURL != nil {
					do{
						let data : Data = try document.data(ofType: "___VARIABLE_documentExtension___")
						try data.write(to: document.fileURL!)
						document.updateChangeCount(NSDocument.ChangeType.changeDone)
					}catch{
						
					}
				}else{
					self.saveAs(sender)
				}
			}
		}
	}

	@IBAction override func saveAs(_ sender: Any?) {
		if let wc = NSApp.keyWindow?.windowController {
			if let document = wc.document as? Document {
				let panel : NSSavePanel = NSSavePanel()
				panel.showsHiddenFiles = false
				panel.allowedFileTypes = ["___VARIABLE_documentExtension___"]
				panel.title = "Save File"
				panel.prompt = "Save a file"

				panel.beginSheetModal(for: (document.model?.windowController?.window)!) { (response) in
					if response == NSApplication.ModalResponse.OK {
						if let document = wc.document as? Document {
							do{
								let data : Data = try document.data(ofType: "___VARIABLE_documentExtension___")
								try data.write(to: panel.url!)
								document.fileURL = panel.url!
								document.updateChangeCount(NSDocument.ChangeType.changeDone)
							}catch{

							}
						}
					}
				}
			}
		}
	}

	@IBAction override func printDocument(_ sender: Any?) {
		// Print our words view
		if let viewController = self.model?.windowController?.contentViewController {
			let printOperation = NSPrintOperation(view: viewController.view, printInfo: NSPrintInfo.shared)
			printOperation.run()
		}
	}
}

