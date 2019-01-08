import XCTest
@testable import Smarkdown

final class SmarkdownTests: XCTestCase {
    func testATXHeader() {
        XCTAssertEqual(ATXHeader.consume("# ATX Header")?.contents, "ATX Header")
        XCTAssertEqual(ATXHeader.consume("# Trailing Pound Sign #")?.contents, "Trailing Pound Sign")
        XCTAssertEqual(ATXHeader.consume("###### Six leading, lots trailing #################")?.contents,
                       "Six leading, lots trailing")
        XCTAssertEqual(ATXHeader.consume("## ")?.contents, "")
        XCTAssertEqual(ATXHeader.consume("   # Three leading spaces")?.contents, "Three leading spaces")
        XCTAssertEqual(ATXHeader.consume("#           Leading and Trailing        #")?.contents, "Leading and Trailing")
        XCTAssertEqual(ATXHeader.consume("### foo ### b")?.contents, "foo ### b")

        XCTAssertNil(ATXHeader.consume("####### Seven Leading Pounds"))
        XCTAssertNil(ATXHeader.consume("#5 Ordinal number"))
        XCTAssertNil(ATXHeader.consume("\\## Escaped"))
        XCTAssertNil(ATXHeader.consume("    # Four leading spaces"))
    }

    func testThematicBreak() {
        XCTAssertNotNil(ThematicBreak.consume("---"))
        XCTAssertNotNil(ThematicBreak.consume("   ---"))
        XCTAssertNotNil(ThematicBreak.consume("   - -  -     "))

        XCTAssertNil(ThematicBreak.consume("    ---"))
        XCTAssertNil(ThematicBreak.consume("--"))
        XCTAssertNil(ThematicBreak.consume("+++"))
    }

    func testSetextHeader() {
        XCTAssertEqual(SetextHeader.consume("Foo *bar*\n=========")?.contents, "Foo *bar*")
        XCTAssertEqual(SetextHeader.consume("Foo *bar*\n---------")?.contents, "Foo *bar*")
        XCTAssertEqual(SetextHeader.consume("Foo *bar*\n   ----      ")?.contents, "Foo *bar*")
        XCTAssertEqual(SetextHeader.consume("Foo *bar*\n-")?.contents, "Foo *bar*")
        XCTAssertEqual(SetextHeader.consume("Foo *bar*\n------------------")?.contents, "Foo *bar*")
        XCTAssertEqual(SetextHeader.consume("Foo *bar\nbaz*\n====")?.contents, "Foo *bar\nbaz*")
        XCTAssertEqual(SetextHeader.consume("   Foo\n---")?.contents, "Foo")
        XCTAssertEqual(SetextHeader.consume("  Foo\n  ===")?.contents, "Foo")
        XCTAssertEqual(SetextHeader.consume("Foo  \n===")?.contents, "Foo")
        XCTAssertEqual(SetextHeader.consume("Foo\\\n===")?.contents, "Foo\\")

        XCTAssertNil(SetextHeader.consume("Foo *bar*\n"))
        XCTAssertNil(SetextHeader.consume("    Foo\n    ---"))
        XCTAssertNil(SetextHeader.consume("Foo\n    ---"))
        XCTAssertNil(SetextHeader.consume("Foo\n- -"))
    }

    func testCodeBlock() {
        XCTAssertEqual(CodeBlock.consume("    a simple\n      indented code block")?.contents,
                       "a simple\n  indented code block")
        XCTAssertEqual(CodeBlock.consume("    chunk 1\n\n    chunk 2\n  \n \n \n    chunk 3")?.contents,
                       "chunk 1\n\nchunk 2\n\n\n\nchunk 3")
    }

    func testFencedCodeBlock() {
        XCTAssertEqual(FencedCodeBlock.consume("```\n<\n >\n```")?.contents, "<\n >")
    }

    func testTokenization() {
        let smd = Smarkdown()
        let tokens = smd.parse("# Heading\n    foo\nHeading\n------\n    foo\n----")
        let types: [LeafBlock.Type] = [ATXHeader.self, CodeBlock.self, SetextHeader.self,
                                       CodeBlock.self, ThematicBreak.self]

        for (idx, token) in tokens.enumerated() {
            let listedType = types[idx]
            XCTAssertTrue(type(of: token.block!) == listedType)
        }
    }

    static var allTests: [Any] = [
//        ("testExample", testATXHeader),
    ]
}
