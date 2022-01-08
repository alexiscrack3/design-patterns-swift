# Memento

The memento pattern is used to capture the current state of an object and store it in such a manner that it can be restored at a later time without breaking the rules of encapsulation.

## Example

```swift
class EditorMemento {
    let editorState: String

    init(state: String) {
        editorState = state
    }

    func getSavedState() -> String {
        return editorState
    }
}

class Editor {
    var contents = ""

    func save() -> EditorMemento {
        return EditorMemento(state: contents)
    }

    func restoreToState(memento: EditorMemento) {
        contents = memento.getSavedState()
    }
}
```

### Usage

```swift
let editor = Editor()
editor.contents = "Foo"
let memento = editor.save()

editor.contents = "Bar"
editor.restoreToState(memento: memento)
editor.contents
```
