//===-- SymbolDocumentationTests.cpp --------------------------------------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
#include "SymbolDocumentation.h"

#include "support/Markup.h"
#include "clang/Basic/CommentOptions.h"
#include "llvm/ADT/StringRef.h"
#include "gtest/gtest.h"

namespace clang {
namespace clangd {

TEST(SymbolDocumentation, UnhandledDocs) {

  CommentOptions CommentOpts;

  struct Case {
    llvm::StringRef Documentation;
    llvm::StringRef ExpectedRenderEscapedMarkdown;
    llvm::StringRef ExpectedRenderMarkdown;
    llvm::StringRef ExpectedRenderPlainText;
  } Cases[] = {
      {
          "foo bar",
          "foo bar",
          "foo bar",
          "foo bar",
      },
      {
          "foo\nbar\n",
          "foo\nbar",
          "foo\nbar",
          "foo bar",
      },
      {
          "foo\n\nbar\n",
          "foo\n\nbar",
          "foo\n\nbar",
          "foo\n\nbar",
      },
      {
          "foo \\p bar baz",
          "foo `bar` baz",
          "foo `bar` baz",
          "foo bar baz",
      },
      {
          "foo \\e bar baz",
          "foo \\*bar\\* baz",
          "foo *bar* baz",
          "foo *bar* baz",
      },
      {
          "foo \\b bar baz",
          "foo \\*\\*bar\\*\\* baz",
          "foo **bar** baz",
          "foo **bar** baz",
      },
      {
          "foo \\ref bar baz",
          "foo \\*\\*\\\\ref\\*\\* \\*bar\\* baz",
          "foo **\\ref** *bar* baz",
          "foo **\\ref** *bar* baz",
      },
      {
          "foo @ref bar baz",
          "foo \\*\\*@ref\\*\\* \\*bar\\* baz",
          "foo **@ref** *bar* baz",
          "foo **@ref** *bar* baz",
      },
      {
          "\\brief this is a \\n\nbrief description",
          "",
          "",
      },
      {
          "\\throw exception foo",
          "\\*\\*\\\\throw\\*\\* \\*exception\\* foo",
          "**\\throw** *exception* foo",
          "**\\throw** *exception* foo",
      },
      {
          R"(\brief this is a brief description

\li item 1
\li item 2
\arg item 3)",
          "- item 1\n\n- item 2\n\n- item 3",
          "- item 1\n\n- item 2\n\n- item 3",
      },
      {
          "\\defgroup mygroup this is a group\nthis is not a group description",
          "\\*\\*@defgroup\\*\\* `mygroup this is a group`\n\nthis is not a "
          "group "
          "description",
          "**@defgroup** `mygroup this is a group`\n\nthis is not a group "
          "description",
          "**@defgroup** `mygroup this is a group`\n\nthis is not a group "
          "description",
      },
      {
          R"(\verbatim
this is a
verbatim block containing
some verbatim text
\endverbatim)",

          R"(**@verbatim**

```
this is a
verbatim block containing
some verbatim text
```

**@endverbatim**)",

          R"(**@verbatim**

this is a
verbatim block containing
some verbatim text

**@endverbatim**)",
      },
      {
          "@param foo this is a parameter\n@param bar this is another "
          "parameter",
          "",
          "",
          "",
      },
      {
<<<<<<< HEAD
          "@brief brief docs\n\n@param foo this is a parameter\n\nMore "
          "description\ndocumentation",
          "\\*\\*@brief\\*\\* brief docs\n\nMore description\ndocumentation",
          "**@brief** brief docs\n\nMore description\ndocumentation",
          "**@brief** brief docs\n\nMore description documentation",
      },
      {
          "<b>this is a bold text</b>\nnormal text\n<i>this is an italic "
          "text</i>\n<code>this is a code block</code>",
          "\\<b>this is a bold text\\</b>\nnormal text\n\\<i>this is an italic "
          "text\\</i>\n\\<code>this is a code block\\</code>",
          "\\<b>this is a bold text\\</b>\nnormal text\n\\<i>this is an italic "
          "text\\</i>\n\\<code>this is a code block\\</code>",
          "<b>this is a bold text</b> normal text <i>this is an italic "
          "text</i> <code>this is a code block</code>",
=======
          R"(@brief brief docs

@param foo this is a parameter

\brief another brief?

\details these are details

More description
documentation)",
          R"(**\brief** another brief?

**\details** these are details

More description
documentation)",
          R"(**\brief** another brief?

**\details** these are details

More description documentation)",
      },
      {
          R"(<b>this is a bold text</b>
normal text<i>this is an italic text</i>
<code>this is a code block</code>)",

          R"(\<b>this is a bold text\</b>
normal text\<i>this is an italic text\</i>
\<code>this is a code block\</code>)",

          "<b>this is a bold text</b> normal text<i>this is an italic text</i> "
          "<code>this is a code block</code>",
>>>>>>> b4920eddb ([clangd] rearrange hover documentation)
      },
  };

  for (const auto &C : Cases) {
    markup::Document Doc;
    SymbolDocCommentVisitor SymbolDoc(C.Documentation, CommentOpts);

    SymbolDoc.docToMarkup(Doc);

    EXPECT_EQ(Doc.asPlainText(), C.ExpectedRenderPlainText);
    EXPECT_EQ(Doc.asMarkdown(), C.ExpectedRenderMarkdown);
    EXPECT_EQ(Doc.asEscapedMarkdown(), C.ExpectedRenderEscapedMarkdown);
  }
}

TEST(SymbolDocumentation, BriefDocs) {

  CommentOptions CommentOpts;

  struct Case {
    llvm::StringRef Documentation;
    llvm::StringRef ExpectedRenderMarkdown;
    llvm::StringRef ExpectedRenderPlainText;
  } Cases[] = {
      {
          R"(\brief this is a \n
brief description

\return it returns something)",
          "this is a   \nbrief description",
          "this is a\nbrief description",
      },
      {
          R"(@brief brief docs

@param foo this is a parameter

More description
documentation

\note this is a note

\return it returns something)",
          "brief docs",
          "brief docs",
      },
      {
          R"(@brief brief docs

@param foo this is a parameter

More description
documentation

\brief another brief?

\note this is a note

\return it returns something)",
          "brief docs",
          "brief docs",
      },
  };
  for (const auto &C : Cases) {
    markup::Document Doc;
    SymbolDocCommentVisitor SymbolDoc(C.Documentation, CommentOpts);

    SymbolDoc.briefToMarkup(Doc.addParagraph());

    EXPECT_EQ(Doc.asPlainText(), C.ExpectedRenderPlainText);
    EXPECT_EQ(Doc.asMarkdown(), C.ExpectedRenderMarkdown);
  }
}

TEST(SymbolDocumentation, ReturnsDocs) {

  CommentOptions CommentOpts;

  struct Case {
    llvm::StringRef Documentation;
    llvm::StringRef ExpectedRenderMarkdown;
    llvm::StringRef ExpectedRenderPlainText;
  } Cases[] = {
      {
          R"(\brief this is a \n
brief description

\return it returns something)",
          "it returns something",
          "it returns something",
      },
      {
          R"(@brief brief docs

@param foo this is a parameter

More description
documentation

\return it returns something

\note this is a note)",
          "it returns something",
          "it returns something",
      },
  };
  for (const auto &C : Cases) {
    markup::Document Doc;
    SymbolDocCommentVisitor SymbolDoc(C.Documentation, CommentOpts);

    SymbolDoc.returnToMarkup(Doc.addParagraph());

    EXPECT_EQ(Doc.asPlainText(), C.ExpectedRenderPlainText);
    EXPECT_EQ(Doc.asMarkdown(), C.ExpectedRenderMarkdown);
  }
}

} // namespace clangd
} // namespace clang
