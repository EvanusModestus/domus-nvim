-- AsciiDoc Language Configuration
-- Comprehensive AsciiDoc editing: snippets, navigation, keymaps, commands
-- Supports: AsciiDoc/Asciidoctor, Antora, D2, Mermaid, PlantUML, Graphviz, BPMN

local M = {}

-- ============================================================================
-- SNIPPET SETUP
-- ============================================================================

function M.setup()
    local ls = require("luasnip")
    local s = ls.snippet
    local t = ls.text_node
    local i = ls.insert_node
    local f = ls.function_node
    local c = ls.choice_node

    ls.add_snippets("asciidoc", {}, { key = "asciidoc-domus" })  -- Clear previous on reload
    ls.add_snippets("asciidoc", {

        -- ----------------------------------------------------------------
        -- CODE BLOCKS: General
        -- ----------------------------------------------------------------

        s("code",    { t("[source,"), i(1, "bash"), t({"]", "----", ""}), i(2), t({"", "----"}) }),
        s("codea",   { t("[source,"), i(1, "bash"), t({",subs=attributes+]", "----", ""}), i(2), t({"", "----"}) }),
        s("bash",    { t({"[source,bash]", "----", ""}), i(1), t({"", "----"}) }),
        s("python",  { t({"[source,python]", "----", ""}), i(1), t({"", "----"}) }),
        s("lua",     { t({"[source,lua]", "----", ""}), i(1), t({"", "----"}) }),
        s("yaml",    { t({"[source,yaml]", "----", ""}), i(1), t({"", "----"}) }),
        s("json",    { t({"[source,json]", "----", ""}), i(1), t({"", "----"}) }),
        s("sql",     { t({"[source,sql]", "----", ""}), i(1), t({"", "----"}) }),
        s("toml",    { t({"[source,toml]", "----", ""}), i(1), t({"", "----"}) }),
        s("rust",    { t({"[source,rust]", "----", ""}), i(1), t({"", "----"}) }),
        s("go",      { t({"[source,go]", "----", ""}), i(1), t({"", "----"}) }),
        s("xml",     { t({"[source,xml]", "----", ""}), i(1), t({"", "----"}) }),
        s("nix",     { t({"[source,nix]", "----", ""}), i(1), t({"", "----"}) }),
        s("vyos",    { t({"[source,vyos]", "----", ""}), i(1), t({"", "----"}) }),
        s("cisco",   { t({"[source,cisco]", "----", ""}), i(1), t({"", "----"}) }),
        s("nginx",   { t({"[source,nginx]", "----", ""}), i(1), t({"", "----"}) }),

        -- Code block with title
        s("codet", {
            t("."), i(1, "Title"),
            t({"", "[source,"}), i(2, "bash"), t({"]", "----", ""}),
            i(3),
            t({"", "----"}),
        }),

        -- Code callout block
        s("callout", {
            t({"[source,"}), i(1, "bash"), t({"]", "----", ""}),
            i(2, "command  <1>"),
            t({"", "----", ""}),
            t("<1> "), i(3, "Explanation"),
        }),

        -- Passthrough block (raw HTML for Antora/Asciidoctor)
        s("pass", { t({"[pass]", "++++", ""}), i(1), t({"", "++++"}) }),
        s("passhtml", {
            t({"[pass]", "++++", "<div class=\""}), i(1, "custom"), t({"\">", ""}),
            i(2),
            t({"", "</div>", "++++"}),
        }),

        -- Literal block (no processing)
        s("literal", { t({"....", ""}), i(1), t({"", "...."}) }),

        -- ----------------------------------------------------------------
        -- DIAGRAM BLOCKS: D2
        -- Requires: asciidoctor-diagram + d2 binary
        -- ----------------------------------------------------------------

        s("d2", {
            t({"."}), i(1, "Diagram Title"),
            t({"", "[d2,format=svg,theme="}), i(2, "0"), t({"]", "----", ""}),
            i(3, "# D2 diagram here"),
            t({"", "----"}),
        }),

        -- D2 flowchart stub
        s("d2flow", {
            t({"."}), i(1, "Flow Title"),
            t({"", "[d2,format=svg]", "----", ""}),
            i(2, "direction: right"),
            t({"", "", "start -> "}), i(3, "step1"), t({" -> end: "}), i(4, "label"),
            t({"", "----"}),
        }),

        -- D2 network/ISE topology stub
        s("d2net", {
            t({"."}), i(1, "Network Diagram"),
            t({"", "[d2,format=svg]", "----", ""}),
            t({"direction: right", ""}),
            t({"", "# Nodes"}),
            t({"", ""}), i(2, "client"), t({": {shape: rectangle}", ""}),
            i(3, "switch"), t({": {shape: rectangle}", ""}),
            t({"", "# Edges", ""}),
            i(4, "client -> switch: 802.1X"),
            t({"", "----"}),
        }),

        -- D2 sequence diagram stub
        s("d2seq", {
            t({"."}), i(1, "Sequence Title"),
            t({"", "[d2,format=svg]", "----", ""}),
            t({"direction: right", ""}),
            i(2, "Client"), t({" -> "}), i(3, "Server"), t({": "}), i(4, "Request"),
            t({"", ""}), i(5, "Server"), t({" -> "}), i(6, "Client"), t({": "}), i(7, "Response"),
            t({"", "----"}),
        }),

        -- D2 class diagram stub
        s("d2class", {
            t({"."}), i(1, "Class Diagram"),
            t({"", "[d2,format=svg]", "----", ""}),
            i(2, "MyClass"), t({": {", "  shape: class", "  fields: {", "    "}),
            i(3, "field: type"),
            t({"", "  }", "  methods: {", "    "}),
            i(4, "method(): return"),
            t({"", "  }", "}", ""}),
            t({"----"}),
        }),

        -- ----------------------------------------------------------------
        -- DIAGRAM BLOCKS: Mermaid (mmd)
        -- Requires: asciidoctor-diagram + mermaid-js/mmdc
        -- ----------------------------------------------------------------

        s("mmd", {
            t({"."}), i(1, "Diagram Title"),
            t({"", "[mermaid,format=svg]", "----", ""}),
            i(2, "flowchart LR"),
            t({"", "  "}), i(3, "A[Start] --> B[End]"),
            t({"", "----"}),
        }),

        -- Mermaid flowchart
        s("mmdflow", {
            t({"."}), i(1, "Flowchart Title"),
            t({"", "[mermaid,format=svg]", "----", ""}),
            t({"flowchart "}), i(2, "LR"),
            t({"", "  "}), i(3, "A"), t({"["}), i(4, "Start"), t({"] --> "}),
            i(5, "B"), t({"["}), i(6, "End"), t({"]"}),
            t({"", "----"}),
        }),

        -- Mermaid sequence
        s("mmdseq", {
            t({"."}), i(1, "Sequence Title"),
            t({"", "[mermaid,format=svg]", "----", ""}),
            t({"sequenceDiagram", "  "}),
            i(2, "Client"), t({"->>"}), i(3, "Server"), t({": "}), i(4, "Request"),
            t({"", "  "}), i(5, "Server"), t({"-->>"}), i(6, "Client"), t({": "}), i(7, "Response"),
            t({"", "----"}),
        }),

        -- Mermaid ER diagram
        s("mmder", {
            t({"."}), i(1, "ER Diagram"),
            t({"", "[mermaid,format=svg]", "----", ""}),
            t({"erDiagram", "  "}),
            i(2, "ENTITY1"), t({" ||--o{ "}), i(3, "ENTITY2"), t({" : "}), i(4, "has"),
            t({"", "  "}), i(5, "ENTITY1"), t({" {", "    string "}), i(6, "field"),
            t({"", "  }"}),
            t({"", "----"}),
        }),

        -- Mermaid Gantt
        s("mmdgantt", {
            t({"."}), i(1, "Project Timeline"),
            t({"", "[mermaid,format=svg]", "----", ""}),
            t({"gantt", "  title "}), i(2, "Project"),
            t({"", "  dateFormat YYYY-MM-DD", "  section "}), i(3, "Phase 1"),
            t({"", "  "}), i(4, "Task 1"), t({"  :"}), i(5, "2024-01-01"), t({", "}), i(6, "7d"),
            t({"", "----"}),
        }),

        -- Mermaid state diagram
        s("mmdstate", {
            t({"."}), i(1, "State Diagram"),
            t({"", "[mermaid,format=svg]", "----", ""}),
            t({"stateDiagram-v2", "  [*] --> "}), i(2, "State1"),
            t({"", "  "}), i(3, "State1"), t({" --> "}), i(4, "State2"), t({" : "}), i(5, "event"),
            t({"", "  "}), i(6, "State2"), t({" --> [*]"}),
            t({"", "----"}),
        }),

        -- Mermaid pie chart
        s("mmdpie", {
            t({"."}), i(1, "Pie Chart Title"),
            t({"", "[mermaid,format=svg]", "----", ""}),
            t({"pie title "}), i(2, "Distribution"),
            t({"", '  "'}), i(3, "Category A"), t({'" : '}), i(4, "40"),
            t({"", '  "'}), i(5, "Category B"), t({'" : '}), i(6, "60"),
            t({"", "----"}),
        }),

        -- Mermaid class diagram
        s("mmdclass", {
            t({"."}), i(1, "Class Diagram"),
            t({"", "[mermaid,format=svg]", "----", ""}),
            t({"classDiagram", "  class "}), i(2, "MyClass"),
            t({"", "  "}), i(3, "MyClass"), t({" : +"}), i(4, "field type"),
            t({"", "  "}), i(5, "MyClass"), t({" : +"}), i(6, "method()"),
            t({"", "----"}),
        }),

        -- Mermaid C4 context
        s("mmdc4", {
            t({"."}), i(1, "C4 Context"),
            t({"", "[mermaid,format=svg]", "----", ""}),
            t({"C4Context", '  title "'}), i(2, "System Context"), t({'"'}),
            t({"", '  Person(user, "'}), i(3, "User"), t({'")', ""}),
            t({'  System(sys, "'}), i(4, "System"), t({'")', ""}),
            t({'  Rel(user, sys, "'}), i(5, "Uses"), t({'")', ""}),
            t({"----"}),
        }),

        -- ----------------------------------------------------------------
        -- DIAGRAM BLOCKS: PlantUML
        -- Requires: asciidoctor-diagram + plantuml.jar or plantuml binary
        -- ----------------------------------------------------------------

        s("puml", {
            t({"."}), i(1, "Diagram Title"),
            t({"", "[plantuml,format=svg]", "----", ""}),
            t({"@startuml", ""}),
            i(2, "A -> B : message"),
            t({"", "@enduml", "----"}),
        }),

        -- PlantUML sequence
        s("pumlseq", {
            t({"."}), i(1, "Sequence Diagram"),
            t({"", "[plantuml,format=svg]", "----", ""}),
            t({"@startuml", ""}),
            t({"participant "}), i(2, "Client"),
            t({"", "participant "}), i(3, "Server"),
            t({"", ""}),
            i(4, "Client"), t({" -> "}), i(5, "Server"), t({" : "}), i(6, "Request"),
            t({"", ""}), i(7, "Server"), t({" --> "}), i(8, "Client"), t({" : "}), i(9, "Response"),
            t({"", "@enduml", "----"}),
        }),

        -- PlantUML component diagram
        s("pumlcomp", {
            t({"."}), i(1, "Component Diagram"),
            t({"", "[plantuml,format=svg]", "----", ""}),
            t({"@startuml", ""}),
            t({"component ["}), i(2, "Component A"), t({"] as "}), i(3, "A"),
            t({"", "component ["}), i(4, "Component B"), t({"] as "}), i(5, "B"),
            t({"", ""}),
            i(6, "A"), t({" --> "}), i(7, "B"), t({" : "}), i(8, "uses"),
            t({"", "@enduml", "----"}),
        }),

        -- PlantUML activity
        s("pumlact", {
            t({"."}), i(1, "Activity Diagram"),
            t({"", "[plantuml,format=svg]", "----", ""}),
            t({"@startuml", ""}),
            t({"start", ""}),
            t({":"}), i(2, "Step 1"), t({";", ""}),
            t({"if ("}), i(3, "condition"), t({") then (yes)", ""}),
            t({"  :"}), i(4, "Branch A"), t({";", ""}),
            t({"else (no)", ""}),
            t({"  :"}), i(5, "Branch B"), t({";", ""}),
            t({"endif", ""}),
            t({"stop", "@enduml", "----"}),
        }),

        -- PlantUML class
        s("pumlclass", {
            t({"."}), i(1, "Class Diagram"),
            t({"", "[plantuml,format=svg]", "----", ""}),
            t({"@startuml", ""}),
            t({"class "}), i(2, "MyClass"), t({" {", "  +"}), i(3, "field : type"),
            t({"", "  +"}), i(4, "method() : return"),
            t({"", "}", ""}),
            t({"@enduml", "----"}),
        }),

        -- PlantUML network (nwdiag)
        s("pumlnet", {
            t({"."}), i(1, "Network Diagram"),
            t({"", "[plantuml,format=svg]", "----", ""}),
            t({"@startuml", ""}),
            t({"nwdiag {", "  network "}), i(2, "dmz"), t({" {", "    address = \""}), i(3, "10.0.0.0/24"), t({"\""}),
            t({"", "    "}), i(4, "server"), t({" [address = \""}), i(5, "10.0.0.1"), t({"\"]" .. "}"}),
            t({"", "  }", "}", "@enduml", "----"}),
        }),

        -- ----------------------------------------------------------------
        -- DIAGRAM BLOCKS: Graphviz / DOT
        -- Requires: asciidoctor-diagram + graphviz package
        -- ----------------------------------------------------------------

        s("dot", {
            t({"."}), i(1, "Graph Title"),
            t({"", "[graphviz,format=svg]", "----", ""}),
            t({"digraph G {", "  rankdir="}), i(2, "LR"), t({";", ""}),
            t({"  node [shape="}), i(3, "rectangle"), t({"];", ""}),
            t({"  "}), i(4, "A"), t({" -> "}), i(5, "B"), t({" [label=\""}), i(6, "edge"), t({"\"];"}),
            t({"", "}", "----"}),
        }),

        -- Graphviz undirected graph
        s("dotg", {
            t({"."}), i(1, "Graph Title"),
            t({"", "[graphviz,format=svg]", "----", ""}),
            t({"graph G {", "  "}),
            i(2, "A"), t({" -- "}), i(3, "B"), t({";"}),
            t({"", "}", "----"}),
        }),

        -- Graphviz network topology (directed, layered)
        s("dotnet", {
            t({"."}), i(1, "Network Topology"),
            t({"", "[graphviz,format=svg]", "----", ""}),
            t({"digraph network {", "  rankdir=TB;", "  node [shape=box, style=filled, fillcolor=lightblue];", ""}),
            t({"  // Nodes", "  "}), i(2, "fw [label=\"Firewall\"]"),
            t({"", "  "}), i(3, "sw [label=\"Switch\"]"),
            t({"", "  "}), i(4, "host [label=\"Host\"]"),
            t({"", "", "  // Edges", "  "}), i(5, "fw -> sw -> host;"),
            t({"", "}", "----"}),
        }),

        -- Graphviz cluster/subgraph (useful for ISE PSN/PAN/MnT topology)
        s("dotcluster", {
            t({"."}), i(1, "Cluster Diagram"),
            t({"", "[graphviz,format=svg]", "----", ""}),
            t({"digraph G {", "  rankdir=LR;", ""}),
            t({"  subgraph cluster_"}), i(2, "0"), t({" {", "    label=\""}), i(3, "Group A"), t({"\";" }),
            t({"", "    color=blue;", "    "}), i(4, "a1; a2;"),
            t({"", "  }", ""}),
            t({"  subgraph cluster_"}), i(5, "1"), t({" {", "    label=\""}), i(6, "Group B"), t({"\";" }),
            t({"", "    color=red;", "    "}), i(7, "b1; b2;"),
            t({"", "  }", ""}),
            t({"  "}), i(8, "a1 -> b1;"),
            t({"", "}", "----"}),
        }),

        -- Graphviz state machine
        s("dotstate", {
            t({"."}), i(1, "State Machine"),
            t({"", "[graphviz,format=svg]", "----", ""}),
            t({"digraph states {", "  rankdir=LR;", "  node [shape=circle];", ""}),
            t({"  "}), i(2, "init"), t({" [shape=point];"}),
            t({"", "  "}), i(3, "init -> S0 [label=\"start\"];"),
            t({"", "  "}), i(4, "S0 -> S1 [label=\"event\"];"),
            t({"", "  "}), i(5, "S1 -> S0 [label=\"reset\"];"),
            t({"", "}", "----"}),
        }),

        -- ----------------------------------------------------------------
        -- DIAGRAM BLOCKS: Kroki (multi-format gateway)
        -- Requires: asciidoctor-kroki gem or kroki.io endpoint
        -- ----------------------------------------------------------------

        s("kroki", {
            t({"."}), i(1, "Diagram Title"),
            t({"", "[kroki,"}),
            c(2, {
                t("d2"),
                t("mermaid"),
                t("graphviz"),
                t("plantuml"),
                t("bpmn"),
                t("excalidraw"),
                t("vega"),
            }),
            t({",svg]", "----", ""}),
            i(3, "# diagram content here"),
            t({"", "----"}),
        }),

        -- BPMN via Kroki
        s("bpmn", {
            t({"."}), i(1, "Process Title"),
            t({"", "[kroki,bpmn,svg]", "----", ""}),
            t({"<?xml version=\"1.0\" encoding=\"UTF-8\"?>", ""}),
            t({"<definitions xmlns=\"http://www.omg.org/spec/BPMN/20100524/MODEL\">", ""}),
            t({"  <!-- BPMN XML here -->", ""}),
            t({"</definitions>", "----"}),
        }),

        -- ----------------------------------------------------------------
        -- ANTORA-SPECIFIC
        -- ----------------------------------------------------------------

        s("xref",    { t("xref:"), i(1, "page.adoc"), t("["), i(2, "Link text"), t("]") }),
        s("xrefc",   { t("xref:"), i(1, "component"), t("::"), i(2, "page.adoc"), t("["), i(3, "text"), t("]") }),
        s("xrefcm",  { t("xref:"), i(1, "component"), t("::"), i(2, "module"), t(":"), i(3, "page.adoc"), t("["), i(4, "text"), t("]") }),
        s("include", { t("include::"), i(1, "path/file.adoc"), t("[]") }),
        s("partial", { t("include::partial$"), i(1, "file.adoc"), t("[]") }),
        s("example", { t("include::example$"), i(1, "file.adoc"), t("[]") }),
        s("attach",  { t("link:{attachmentsdir}/"), i(1, "file.pdf"), t("["), i(2, "Download"), t("]") }),

        -- Antora page header (full)
        s("antorapage", {
            t("= "), i(1, "Title"),
            t({"", ":description: "}), i(2, "Page description"),
            t({"", ":navtitle: "}), i(3, "Nav Title"),
            t({"", ":keywords: "}), i(4, "keyword1, keyword2"),
            t({"", ":page-tags: "}), i(5, "tag1, tag2"),
            t({"", ":page-aliases: "}), i(6, "old-page.adoc"),
            t({"", ":icons: font", ""}),
        }),

        -- Antora component descriptor hint
        s("antoraidx", {
            t({"= "}), i(1, "Module Index Title"),
            t({"", ":navtitle: "}), i(2, "Nav Title"),
            t({"", "", ""}),
            i(3, "Introduction paragraph."),
        }),

        -- Antora conditional (env-site = Antora build, not local)
        s("ifsite", {
            t({"ifdef::env-site[]", ""}),
            i(1, "Antora-only content"),
            t({"", "endif::env-site[]"}),
        }),

        s("iflocal", {
            t({"ifndef::env-site[]", ""}),
            i(1, "Local/IDE-only content"),
            t({"", "endif::env-site[]"}),
        }),

        -- ifdef generic
        s("ifdef", { t("ifdef::"), i(1, "attribute"), t({"[]", ""}), i(2), t({"", "endif::[]"}) }),
        s("ifndef", { t("ifndef::"), i(1, "attribute"), t({"[]", ""}), i(2), t({"", "endif::[]"}) }),

        -- ----------------------------------------------------------------
        -- ADMONITIONS
        -- ----------------------------------------------------------------

        s("note",      { t("NOTE: "), i(1) }),
        s("tip",       { t("TIP: "), i(1) }),
        s("warning",   { t("WARNING: "), i(1) }),
        s("caution",   { t("CAUTION: "), i(1) }),
        s("important", { t("IMPORTANT: "), i(1) }),

        -- Block admonitions
        s("noteb",     { t({"[NOTE]", "====", ""}), i(1), t({"", "===="}) }),
        s("tipb",      { t({"[TIP]", "====", ""}), i(1), t({"", "===="}) }),
        s("warnb",     { t({"[WARNING]", "====", ""}), i(1), t({"", "===="}) }),
        s("cautb",     { t({"[CAUTION]", "====", ""}), i(1), t({"", "===="}) }),
        s("impb",      { t({"[IMPORTANT]", "====", ""}), i(1), t({"", "===="}) }),

        -- Titled block admonition
        s("notet", {
            t({"."}), i(1, "Admonition Title"),
            t({"", "[NOTE]", "====", ""}), i(2), t({"", "===="}),
        }),

        -- ----------------------------------------------------------------
        -- HEADERS
        -- ----------------------------------------------------------------

        s("h1", { t("= "), i(1, "Title") }),
        s("h2", { t("== "), i(1, "Section") }),
        s("h3", { t("=== "), i(1, "Subsection") }),
        s("h4", { t("==== "), i(1, "Sub-subsection") }),
        s("h5", { t("===== "), i(1, "Detail") }),

        -- Discrete heading (not in TOC)
        s("discrete", { t({"[discrete]", "==== "}), i(1, "Heading (not in TOC)") }),

        -- Document header (minimal)
        s("docheader", {
            t("= "), i(1, "Title"),
            t({"", ":description: "}), i(2, "Description"),
            t({"", ":navtitle: "}), i(3, "Nav"),
            t({"", ":icons: font", ""}),
        }),

        -- Document header with TOC
        s("docheadertoc", {
            t("= "), i(1, "Title"),
            t({"", ":description: "}), i(2, "Description"),
            t({"", ":toc: left"}),
            t({"", ":toclevels: "}), i(3, "3"),
            t({"", ":toc-title: "}), i(4, "Contents"),
            t({"", ":icons: font", ""}),
        }),

        -- ----------------------------------------------------------------
        -- LINKS, IMAGES, MEDIA
        -- ----------------------------------------------------------------

        s("link",    { t("link:"), i(1, "https://"), t("["), i(2, "text"), t("]") }),
        s("image",   { t("image::"), i(1, "path.png"), t("["), i(2, "alt"), t("]") }),
        s("imagei",  { t("image:"), i(1, "path.png"), t("["), i(2, "alt"), t("]") }),
        s("video",   { t("video::"), i(1, "path.mp4"), t("["), i(2, "options"), t("]") }),
        s("audio",   { t("audio::"), i(1, "path.mp3"), t("["), i(2, "options"), t("]") }),

        -- Image with title and width
        s("imagef", {
            t("."), i(1, "Figure Title"),
            t({"", "image::"}), i(2, "images/file.png"),
            t("["), i(3, "alt text"), t(","), i(4, "600"), t("]"),
        }),

        -- ----------------------------------------------------------------
        -- TABLES
        -- ----------------------------------------------------------------

        s("table", {
            t({"|===", "| "}), i(1, "H1"), t(" | "), i(2, "H2"),
            t({"", "", "| "}), i(3), t(" | "), i(4),
            t({"", "|==="}),
        }),

        -- AsciiDoc cell table (for complex content in cells)
        s("atable", {
            t({'[cols="'}), i(1, "1h,3a"), t({'"]', "|===", "| "}),
            i(2, "Header"), t(" | "), i(3, "Header"),
            t({"", "", "| "}), i(4), t({"", "a| "}), i(5),
            t({"", "|==="}),
        }),

        -- CSV table
        s("csvtable", {
            t({"[%header,format=csv]", "|===", ""}),
            i(1, "Col1,Col2,Col3"),
            t({"", ""}), i(2, "a,b,c"),
            t({"", "|==="}),
        }),

        -- ----------------------------------------------------------------
        -- LISTS
        -- ----------------------------------------------------------------

        s("ul",     { t("* "), i(1) }),
        s("ol",     { t(". "), i(1) }),
        s("dl",     { i(1, "Term"), t(":: "), i(2, "Definition") }),
        s("dlh",    { t({"[horizontal]", ""}), i(1, "Term"), t(":: "), i(2, "Definition") }),
        s("check",  { t("* ["), c(1, { t(" "), t("x") }), t("] "), i(2) }),
        s("qanda",  { t({"[qanda]", ""}), i(1, "Question"), t({"::"}), t({"", ""}), i(2, "Answer") }),

        -- ----------------------------------------------------------------
        -- BLOCKS: Collapsible, Sidebar, Quote, Example
        -- ----------------------------------------------------------------

        s("collapse",  {
            t({"."}), i(1, "Click to expand"),
            t({"", "[%collapsible]", "====", ""}), i(2), t({"", "===="}),
        }),
        s("collapseo", {
            t({"."}), i(1, "Click to expand"),
            t({"", "[%collapsible%open]", "====", ""}), i(2), t({"", "===="}),
        }),

        s("sidebar", { t({"."}), i(1, "Sidebar Title"), t({"", "****", ""}), i(2), t({"", "****"}) }),

        s("quote", {
            t({"[quote, "}), i(1, "Author"), t({", "}), i(2, "Source"),
            t({"]", "____", ""}), i(3), t({"", "____"}),
        }),

        s("example", { t({"====", ""}), i(1), t({"", "===="}) }),

        -- ----------------------------------------------------------------
        -- FORMATTING INLINE
        -- ----------------------------------------------------------------

        s("bold",    { t("*"), i(1), t("*") }),
        s("italic",  { t("_"), i(1), t("_") }),
        s("mono",    { t("`"), i(1), t("`") }),
        s("mark",    { t("#"), i(1), t("#") }),
        s("sub",     { t("~"), i(1), t("~") }),
        s("sup",     { t("^"), i(1), t("^") }),
        s("role",    { t("[."), i(1, "role"), t("]#"), i(2, "text"), t("#") }),
        s("fn",      { t("footnote:["), i(1, "Footnote text"), t("]") }),

        -- ----------------------------------------------------------------
        -- ATTRIBUTES
        -- ----------------------------------------------------------------

        s("attr",    { t("{"), i(1, "attribute"), t("}") }),
        s("attrd",   { t(":"), i(1, "attr"), t(": "), i(2, "value") }),
        s("counter", { t("{counter:"), i(1, "step"), t("}") }),

        -- ----------------------------------------------------------------
        -- KEYBOARD / UI MACROS
        -- ----------------------------------------------------------------

        s("kbd",   { t("kbd:["), i(1, "Ctrl+C"), t("]") }),
        s("btn",   { t("btn:["), i(1, "Submit"), t("]") }),
        s("menu",  { t("menu:"), i(1, "File"), t("["), i(2, "Save"), t("]") }),

        -- ----------------------------------------------------------------
        -- LEAD PARAGRAPH
        -- ----------------------------------------------------------------

        s("lead", { t({"[.lead]", ""}), i(1, "Lead paragraph text") }),

        -- ----------------------------------------------------------------
        -- DATE / TIME
        -- ----------------------------------------------------------------

        s("date",     { f(function() return os.date("%Y-%m-%d") end) }),
        s("datetime", { f(function() return os.date("%Y-%m-%d %H:%M") end) }),

        -- ----------------------------------------------------------------
        -- TOC MACRO (inline placement)
        -- ----------------------------------------------------------------

        s("toc", { t("toc::[]") }),
        s("tocl", { t("toc::[leveloffset="), i(1, "1"), t("]") }),

        -- ----------------------------------------------------------------
        -- PAGE BREAK / HORIZONTAL RULE
        -- ----------------------------------------------------------------

        s("pagebreak", { t("<<<") }),
        s("hr",        { t("'''") }),

    })

    ls.filetype_extend("asciidoctor", { "asciidoc" })

    M.navigation()
    M.commands()
end

-- ============================================================================
-- NAVIGATION KEYMAPS
-- ============================================================================

function M.navigation()
    vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("DomusAsciidocNav", { clear = true }),
        pattern = { "asciidoc", "asciidoctor" },
        callback = function()
            local opts = { buffer = true, silent = true }
            local map = vim.keymap.set

            -- Capture source window before any float opens (used by outline)
            -- (stored per-buffer on BufEnter so outline <CR> can restore focus)
            vim.b.adoc_src_win = vim.api.nvim_get_current_win()
            vim.api.nvim_create_autocmd("BufEnter", {
                buffer = 0,
                callback = function() vim.b.adoc_src_win = vim.api.nvim_get_current_win() end,
            })

            -- ---- Block navigation -------------------------------------------
            -- Tighter patterns avoid matching inside code blocks
            map("n", "]-", function() vim.fn.search("^----$", "W") end,
                vim.tbl_extend("force", opts, { desc = "Next ---- block" }))
            map("n", "[-", function() vim.fn.search("^----$", "bW") end,
                vim.tbl_extend("force", opts, { desc = "Prev ---- block" }))
            map("n", "]=", function() vim.fn.search("^====$", "W") end,
                vim.tbl_extend("force", opts, { desc = "Next ==== block" }))
            map("n", "[=", function() vim.fn.search("^====$", "bW") end,
                vim.tbl_extend("force", opts, { desc = "Prev ==== block" }))

            -- Section jump: tighter regex avoids false positives inside blocks
            -- Matches lines like "== Title" but not "====" delimiters
            map("n", "]]", function() vim.fn.search("^=[= ]*[^=\n]", "W") end,
                vim.tbl_extend("force", opts, { desc = "Next section" }))
            map("n", "[[", function() vim.fn.search("^=[= ]*[^=\n]", "bW") end,
                vim.tbl_extend("force", opts, { desc = "Prev section" }))

            -- Jump to next/prev include directive
            map("n", "]i", function() vim.fn.search("^include::", "W") end,
                vim.tbl_extend("force", opts, { desc = "Next include::" }))
            map("n", "[i", function() vim.fn.search("^include::", "bW") end,
                vim.tbl_extend("force", opts, { desc = "Prev include::" }))

            -- Jump to next/prev xref
            map("n", "]x", function() vim.fn.search("xref:", "W") end,
                vim.tbl_extend("force", opts, { desc = "Next xref:" }))
            map("n", "[x", function() vim.fn.search("xref:", "bW") end,
                vim.tbl_extend("force", opts, { desc = "Prev xref:" }))

            -- Jump to next/prev diagram block (d2/mermaid/plantuml/graphviz)
            map("n", "]d", function() vim.fn.search("^\\[\\(d2\\|mermaid\\|plantuml\\|graphviz\\|kroki\\)", "W") end,
                vim.tbl_extend("force", opts, { desc = "Next diagram block" }))
            map("n", "[d", function() vim.fn.search("^\\[\\(d2\\|mermaid\\|plantuml\\|graphviz\\|kroki\\)", "bW") end,
                vim.tbl_extend("force", opts, { desc = "Prev diagram block" }))

            -- ---- Header insertion -------------------------------------------
            map("n", "<leader>a1", "I= <Esc>",    vim.tbl_extend("force", opts, { desc = "H1" }))
            map("n", "<leader>a2", "I== <Esc>",   vim.tbl_extend("force", opts, { desc = "H2" }))
            map("n", "<leader>a3", "I=== <Esc>",  vim.tbl_extend("force", opts, { desc = "H3" }))
            map("n", "<leader>a4", "I==== <Esc>", vim.tbl_extend("force", opts, { desc = "H4" }))

            -- ---- Formatting -------------------------------------------------
            map("n", "<leader>ab", "viw<Esc>a*<Esc>bi*<Esc>",
                vim.tbl_extend("force", opts, { desc = "Bold word" }))
            map("v", "<leader>ab", "<Esc>`>a*<Esc>`<i*<Esc>",
                vim.tbl_extend("force", opts, { desc = "Bold selection" }))
            map("n", "<leader>ai", "viw<Esc>a_<Esc>bi_<Esc>",
                vim.tbl_extend("force", opts, { desc = "Italic word" }))
            map("v", "<leader>ai", "<Esc>`>a_<Esc>`<i_<Esc>",
                vim.tbl_extend("force", opts, { desc = "Italic selection" }))
            map("n", "<leader>ac", "viw<Esc>a`<Esc>bi`<Esc>",
                vim.tbl_extend("force", opts, { desc = "Monospace word" }))
            map("v", "<leader>ac", "<Esc>`>a`<Esc>`<i`<Esc>",
                vim.tbl_extend("force", opts, { desc = "Monospace selection" }))

            -- ---- Lists ------------------------------------------------------
            map("n", "<leader>al", "I* <Esc>",    vim.tbl_extend("force", opts, { desc = "Bullet list item" }))
            map("n", "<leader>an", "I. <Esc>",    vim.tbl_extend("force", opts, { desc = "Numbered list item" }))
            map("n", "<leader>at", "I* [ ] <Esc>", vim.tbl_extend("force", opts, { desc = "Checklist item" }))

            -- Toggle checklist item done/undone
            map("n", "<leader>ax", function()
                local line = vim.api.nvim_get_current_line()
                if line:match("%* %[ %]") then
                    vim.api.nvim_set_current_line(line:gsub("%* %[ %]", "* [x]", 1))
                elseif line:match("%* %[x%]") then
                    vim.api.nvim_set_current_line(line:gsub("%* %[x%]", "* [ ]", 1))
                end
            end, vim.tbl_extend("force", opts, { desc = "Toggle checklist item" }))

            -- ---- Admonitions ------------------------------------------------
            map("n", "<leader>aN", "INOTE: <Esc>",    vim.tbl_extend("force", opts, { desc = "NOTE:" }))
            map("n", "<leader>aT", "ITIP: <Esc>",     vim.tbl_extend("force", opts, { desc = "TIP:" }))
            map("n", "<leader>aW", "IWARNING: <Esc>", vim.tbl_extend("force", opts, { desc = "WARNING:" }))
            map("n", "<leader>aC", "ICAUTION: <Esc>", vim.tbl_extend("force", opts, { desc = "CAUTION:" }))
            map("n", "<leader>aI", "IIMPORTANT: <Esc>", vim.tbl_extend("force", opts, { desc = "IMPORTANT:" }))

            -- ---- Commands via keymap ----------------------------------------
            map("n", "<leader>ao", ":AsciidocOutline<CR>",
                vim.tbl_extend("force", opts, { desc = "Outline" }))
            map("n", "<leader>aw", ":AsciidocWordCount<CR>",
                vim.tbl_extend("force", opts, { desc = "Word count" }))
            map("n", "<leader>aX", ":AsciidocFindBrokenXrefs<CR>",
                vim.tbl_extend("force", opts, { desc = "Find broken xrefs" }))
            map("n", "<leader>aA", ":AsciidocCheckAttrs<CR>",
                vim.tbl_extend("force", opts, { desc = "Check attributes" }))
            map("n", "<leader>ap", ":AsciidocPreviewAttrs<CR>",
                vim.tbl_extend("force", opts, { desc = "Preview attributes" }))
            map("n", "<leader>aD", ":AsciidocListDiagrams<CR>",
                vim.tbl_extend("force", opts, { desc = "List diagram blocks" }))

            -- ---- Insert mode helpers ----------------------------------------
            -- Note: <C-a> conflicts with terminal increment in some configs.
            -- Using <M-{> as a safer alternative.
            map("i", "<M-{>", "{}<Left>", vim.tbl_extend("force", opts, { desc = "Insert {attr}" }))
        end,
    })
end

-- ============================================================================
-- COMMANDS
-- ============================================================================

function M.commands()

    -- -------------------------------------------------------------------------
    -- Outline: floating window with jump-to-section
    -- -------------------------------------------------------------------------
    vim.api.nvim_create_user_command("AsciidocOutline", function()
        local src_win = vim.b.adoc_src_win or vim.api.nvim_get_current_win()
        local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
        local outline = {}
        local line_numbers = {}

        for idx, line in ipairs(lines) do
            local level, title = line:match("^(=+)%s+(.+)$")
            if level and title and #level <= 5 then
                local indent = string.rep("  ", #level - 1)
                local entry = string.format("%s%s %s", indent, level, title)
                table.insert(outline, entry)
                table.insert(line_numbers, idx)
            end
        end

        if #outline == 0 then
            vim.notify("No headers found", vim.log.levels.WARN)
            return
        end

        local buf = vim.api.nvim_create_buf(false, true)
        vim.api.nvim_buf_set_lines(buf, 0, -1, false, outline)
        vim.bo[buf].modifiable = false
        vim.bo[buf].filetype = "asciidoc_outline"

        local width  = math.min(80, vim.o.columns - 10)
        local height = math.min(#outline + 2, vim.o.lines - 10)

        local win = vim.api.nvim_open_win(buf, true, {
            relative   = "editor",
            width      = width,
            height     = height,
            row        = math.floor((vim.o.lines - height) / 2),
            col        = math.floor((vim.o.columns - width) / 2),
            style      = "minimal",
            border     = "rounded",
            title      = " Document Outline ",
            title_pos  = "center",
        })

        local function close_outline()
            if vim.api.nvim_win_is_valid(win) then
                vim.api.nvim_win_close(win, true)
            end
        end

        vim.keymap.set("n", "q",     close_outline,          { buffer = buf, silent = true })
        vim.keymap.set("n", "<Esc>", close_outline,          { buffer = buf, silent = true })

        vim.keymap.set("n", "<CR>", function()
            local cursor_row = vim.api.nvim_win_get_cursor(win)[1]
            local target_line = line_numbers[cursor_row]
            if target_line then
                close_outline()
                -- Return focus to the source window, not just cursor position
                vim.api.nvim_set_current_win(src_win)
                vim.api.nvim_win_set_cursor(src_win, { target_line, 0 })
                vim.cmd("normal! zz")
            end
        end, { buffer = buf, silent = true })

        -- Preview on CursorMoved without closing
        vim.keymap.set("n", "p", function()
            local cursor_row = vim.api.nvim_win_get_cursor(win)[1]
            local target_line = line_numbers[cursor_row]
            if target_line and vim.api.nvim_win_is_valid(src_win) then
                vim.api.nvim_win_set_cursor(src_win, { target_line, 0 })
            end
        end, { buffer = buf, silent = true, desc = "Preview section without closing" })

    end, { desc = "Show AsciiDoc outline" })

    -- -------------------------------------------------------------------------
    -- Word count: excludes AsciiDoc syntax
    -- -------------------------------------------------------------------------
    vim.api.nvim_create_user_command("AsciidocWordCount", function()
        local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
        local word_count = 0
        local skip_patterns = {
            "^=+%s",          -- headers
            "^%-%-%-%-",      -- code block delimiters
            "^====",          -- example/admonition delimiters
            "^%+%+%+%+",      -- passthrough delimiters
            "^%[source",      -- source block annotations
            "^%[NOTE",        -- admonition annotations
            "^%[TIP",
            "^%[WARNING",
            "^%[CAUTION",
            "^%[IMPORTANT",
            "^%[d2",          -- diagram blocks
            "^%[mermaid",
            "^%[plantuml",
            "^%[graphviz",
            "^%[kroki",
            "^include::",     -- include directives
            "^:[%w%-_]+:",    -- attribute definitions
            "^//"             -- comments
        }
        local in_code_block = false

        for _, line in ipairs(lines) do
            if line:match("^%-%-%-%-$") then
                in_code_block = not in_code_block
            end

            if not in_code_block then
                local skip = false
                for _, pat in ipairs(skip_patterns) do
                    if line:match(pat) then skip = true; break end
                end

                if not skip then
                    local clean = line
                        :gsub("xref:[^%[]*%[([^%]]*)%]", "%1")  -- xref -> link text
                        :gsub("link:[^%[]*%[([^%]]*)%]", "%1")  -- link -> link text
                        :gsub("image::[^%[]*%[[^%]]*%]", "")    -- images
                        :gsub("{[%w%-_]+}", "")                  -- attributes
                        :gsub("[*_`#^~]", "")                    -- inline formatting
                        :gsub("kbd:%[[^%]]*%]", "")             -- kbd macros
                        :gsub("btn:%[[^%]]*%]", "")             -- btn macros
                    for _ in clean:gmatch("%S+") do
                        word_count = word_count + 1
                    end
                end
            end
        end

        vim.notify(string.format("Word count (excl. syntax): %d", word_count), vim.log.levels.INFO)
    end, { desc = "Count words excluding AsciiDoc syntax" })

    -- -------------------------------------------------------------------------
    -- Find broken xrefs: check xref targets against files on disk
    -- -------------------------------------------------------------------------
    vim.api.nvim_create_user_command("AsciidocFindBrokenXrefs", function()
        local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
        local buf_dir = vim.fn.expand("%:p:h")
        local broken = {}

        for idx, line in ipairs(lines) do
            -- Match xref:page.adoc[] and xref:component::page.adoc[]
            for ref in line:gmatch("xref:([^%[]+)%[") do
                -- Strip component:: and module: prefixes to get file portion
                local file = ref:match(".*::(.+)$") or ref:match(".*:(.+)$") or ref
                -- Resolve relative to buffer directory
                local resolved = buf_dir .. "/" .. file
                if vim.fn.filereadable(resolved) == 0 then
                    table.insert(broken, string.format("Line %d: xref:%s (not found: %s)", idx, ref, resolved))
                end
            end
        end

        if #broken == 0 then
            vim.notify("All xref targets resolved on disk", vim.log.levels.INFO)
            return
        end

        -- Show in a floating window
        local buf = vim.api.nvim_create_buf(false, true)
        vim.api.nvim_buf_set_lines(buf, 0, -1, false, broken)
        vim.bo[buf].modifiable = false

        local width  = math.min(100, vim.o.columns - 10)
        local height = math.min(#broken + 2, vim.o.lines - 10)

        vim.api.nvim_open_win(buf, true, {
            relative  = "editor",
            width     = width,
            height    = height,
            row       = math.floor((vim.o.lines - height) / 2),
            col       = math.floor((vim.o.columns - width) / 2),
            style     = "minimal",
            border    = "rounded",
            title     = string.format(" Broken xrefs: %d ", #broken),
            title_pos = "center",
        })

        vim.keymap.set("n", "q",     ":close<CR>", { buffer = buf, silent = true })
        vim.keymap.set("n", "<Esc>", ":close<CR>", { buffer = buf, silent = true })
    end, { desc = "Find broken xref targets" })

    -- -------------------------------------------------------------------------
    -- Attribute checker: undefined {attr} references
    -- -------------------------------------------------------------------------
    vim.api.nvim_create_user_command("AsciidocCheckAttrs", function()
        local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
        local defined = {}
        local used = {}

        for idx, line in ipairs(lines) do
            for attr in line:gmatch(":([%w%-_]+):") do
                defined[attr] = true
            end
            for attr in line:gmatch("{([%w%-_]+)}") do
                if not used[attr] then used[attr] = {} end
                table.insert(used[attr], idx)
            end
        end

        local builtins = {
            "nbsp", "zwsp", "apos", "quot", "ldquo", "rdquo",
            "deg", "plus", "amp", "lt", "gt", "sp", "empty",
            -- Antora built-ins
            "page", "page-title", "page-component-name", "page-component-version",
            "page-module", "page-relative-src-path",
        }

        local undefined = {}
        for attr, lines_used in pairs(used) do
            if not defined[attr] and not vim.tbl_contains(builtins, attr) then
                table.insert(undefined, string.format("{%s}  line(s): %s", attr, table.concat(lines_used, ", ")))
            end
        end

        table.sort(undefined)

        if #undefined == 0 then
            vim.notify("All attributes defined", vim.log.levels.INFO)
        else
            vim.notify("Undefined attributes:\n" .. table.concat(undefined, "\n"), vim.log.levels.WARN)
        end
    end, { desc = "Check undefined AsciiDoc attributes" })

    -- -------------------------------------------------------------------------
    -- Preview attrs: show all :attr: value definitions in a float
    -- -------------------------------------------------------------------------
    vim.api.nvim_create_user_command("AsciidocPreviewAttrs", function()
        local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
        local attrs = {}

        for _, line in ipairs(lines) do
            local attr, value = line:match("^:([%w%-_]+):%s*(.*)$")
            if attr then
                table.insert(attrs, string.format("  %-30s %s", ":" .. attr .. ":", value))
            end
        end

        if #attrs == 0 then
            vim.notify("No attribute definitions found", vim.log.levels.WARN)
            return
        end

        table.sort(attrs)

        local buf = vim.api.nvim_create_buf(false, true)
        vim.api.nvim_buf_set_lines(buf, 0, -1, false, attrs)
        vim.bo[buf].modifiable = false

        local width  = math.min(80, vim.o.columns - 10)
        local height = math.min(#attrs + 2, vim.o.lines - 10)

        vim.api.nvim_open_win(buf, true, {
            relative  = "editor",
            width     = width,
            height    = height,
            row       = math.floor((vim.o.lines - height) / 2),
            col       = math.floor((vim.o.columns - width) / 2),
            style     = "minimal",
            border    = "rounded",
            title     = " Document Attributes ",
            title_pos = "center",
        })

        vim.keymap.set("n", "q",     ":close<CR>", { buffer = buf, silent = true })
        vim.keymap.set("n", "<Esc>", ":close<CR>", { buffer = buf, silent = true })
    end, { desc = "Preview all attribute definitions" })

    -- -------------------------------------------------------------------------
    -- List diagram blocks: summary of all diagram blocks in buffer
    -- -------------------------------------------------------------------------
    vim.api.nvim_create_user_command("AsciidocListDiagrams", function()
        local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
        local diagrams = {}
        local diagram_types = { "d2", "mermaid", "plantuml", "graphviz", "kroki", "bpmn" }
        local line_numbers = {}

        for idx, line in ipairs(lines) do
            for _, dtype in ipairs(diagram_types) do
                if line:match("^%[" .. dtype) then
                    local prev_title = ""
                    if idx > 1 then
                        local prev = lines[idx - 1]
                        local t = prev:match("^%.(.+)$")
                        if t then prev_title = " — " .. t end
                    end
                    table.insert(diagrams, string.format("  Line %-5d [%s]%s", idx, dtype, prev_title))
                    table.insert(line_numbers, idx)
                    break
                end
            end
        end

        if #diagrams == 0 then
            vim.notify("No diagram blocks found", vim.log.levels.INFO)
            return
        end

        local src_win = vim.b.adoc_src_win or vim.api.nvim_get_current_win()
        local buf = vim.api.nvim_create_buf(false, true)
        vim.api.nvim_buf_set_lines(buf, 0, -1, false, diagrams)
        vim.bo[buf].modifiable = false

        local width  = math.min(80, vim.o.columns - 10)
        local height = math.min(#diagrams + 2, vim.o.lines - 10)

        local win = vim.api.nvim_open_win(buf, true, {
            relative  = "editor",
            width     = width,
            height    = height,
            row       = math.floor((vim.o.lines - height) / 2),
            col       = math.floor((vim.o.columns - width) / 2),
            style     = "minimal",
            border    = "rounded",
            title     = string.format(" Diagram Blocks: %d ", #diagrams),
            title_pos = "center",
        })

        local function close_win()
            if vim.api.nvim_win_is_valid(win) then
                vim.api.nvim_win_close(win, true)
            end
        end

        vim.keymap.set("n", "q",     close_win, { buffer = buf, silent = true })
        vim.keymap.set("n", "<Esc>", close_win, { buffer = buf, silent = true })

        vim.keymap.set("n", "<CR>", function()
            local cursor_row = vim.api.nvim_win_get_cursor(win)[1]
            local target_line = line_numbers[cursor_row]
            if target_line then
                close_win()
                vim.api.nvim_set_current_win(src_win)
                vim.api.nvim_win_set_cursor(src_win, { target_line, 0 })
                vim.cmd("normal! zz")
            end
        end, { buffer = buf, silent = true })

    end, { desc = "List all diagram blocks in buffer" })

end

return M
