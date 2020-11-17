
import Foundation

struct DiffReportOptions {
    enum Accessibility: String {
        case `fileprivate` = "source.lang.swift.accessibility.`fileprivate`"
        case `private` = "source.lang.swift.accessibility.`private`"
        case `internal` = "source.lang.swift.accessibility.`internal`"
        case `open` = "source.lang.swift.accessibility.`open`"
        case `public` = "source.lang.swift.accessibility.public"
    }
    
    var accessibilityLevels: [Accessibility] = [.open, .public]
    var ignoreUndocumented = true
    var ignoredKeys = Set(arrayLiteral: "key.doc.line", "key.parsed_scope.end", "key.parsed_scope.start", "key.doc.column", "key.doc.comment", "key.bodyoffset", "key.nameoffset", "key.doc.full_as_xml", "key.offset", "key.fully_annotated_decl", "key.length", "key.bodylength", "key.namelength", "key.annotated_decl", "key.doc.parameters", "key.elements", "key.related_decls",
                          "key.filepath", "key.attributes",
                          "key.parsed_declaration",
                          "key.docoffset", "key.attributes")
    
    func verifyAccessibility(_ accessibility: String) -> Bool {
        if let target = Accessibility(rawValue: accessibility) {
            return accessibilityLevels.contains(target)
        }
        return false
    }
}
