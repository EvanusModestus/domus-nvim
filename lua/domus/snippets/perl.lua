-- Perl snippets -- regex-forward, since Perl is the default PCRE engine here.
-- Registered from the single LuaSnip spec (plugins/specs/coding.lua), same as the C set.
-- NOTE: regex backslashes are doubled (\\w, \\d) -- a single backslash is an invalid
-- Lua string escape under LuaJIT and would fail to load.

return function(ls)
    local s = ls.snippet
    local t = ls.text_node
    local i = ls.insert_node
    local c = ls.choice_node

    ls.add_snippets("perl", {
        -- ---- HEADER / PRAGMAS ----------------------------------------------
        -- The always-on safety net (strict + warnings catch most footguns)
        s("perlscript", {
            t({ "#!/usr/bin/env perl", "use strict;", "use warnings;", "", "" }), i(1),
        }),
        s("use",    { t({ "use strict;", "use warnings;" }) }),
        s("usev",   { t("use v5."), i(1, "36"), t(";") }),
        s("usemod", { t("use "), i(1, "Module::Name"), t(";") }),

        -- ---- SUBROUTINES / FLOW --------------------------------------------
        s("sub", {
            t("sub "), i(1, "name"), t({ " {", "    my (" }), i(2, "$self"),
            t({ ") = @_;", "    " }), i(3), t({ "", "}" }),
        }),
        -- The classic filter loop: read handle line by line
        s("while", {
            t("while (my $line = <"), i(1, "STDIN"), t({ ">) {", "    chomp $line;", "    " }),
            i(2), t({ "", "}" }),
        }),
        s("foreach", {
            t("foreach my "), i(1, "$item"), t(" ("), i(2, "@list"), t({ ") {", "    " }),
            i(3), t({ "", "}" }),
        }),

        -- ---- FILE I/O (3-arg open + lexical handle + die; never 2-arg) -----
        s("open", {
            t("open(my $"), i(1, "fh"), t(", '"), c(2, { t("<"), t(">"), t(">>") }),
            t("', "), i(3, "$file"), t(") or die \"Cannot open "), i(4, "$file"), t(": $!\";"),
        }),
        s("slurp", {
            t({ "my $content = do {", "    local $/;", "    open(my $fh, '<', " }), i(1, "$file"),
            t({ ") or die \"$!\";", "    <$fh>;", "};" }),
        }),

        -- ---- REGEX (the main event) ----------------------------------------
        -- Match with capture
        s("m", {
            i(1, "$str"), t(" =~ /"), i(2, "pattern"), t("/"), i(3, ""),
        }),
        -- Match in an if-block
        s("mif", {
            t("if ("), i(1, "$str"), t(" =~ /"), i(2, "pattern"), t({ "/) {", "    " }), i(3), t({ "", "}" }),
        }),
        -- Named capture -> %+  (self-documenting field extraction)
        s("mnamed", {
            t("if ("), i(1, "$str"), t(" =~ /(?<"), i(2, "name"), t(">"), i(3, "\\w+"),
            t({ ")/) {", "    # value in $+{" }), i(4, "name"), t({ "}", "    " }), i(5), t({ "", "}" }),
        }),
        -- Extended /x regex: whitespace-insensitive + inline # comments (reviewable)
        s("mx", {
            t({ "my $re = qr/", "    " }), i(1, "\\d{3}"), t("   # "), i(2, "three digits"),
            t({ "", "/x;" }),
        }),
        -- Compiled pattern for reuse
        s("qr", { t("my $"), i(1, "re"), t(" = qr/"), i(2, "pattern"), t("/"), i(3, "x"), t(";") }),
        -- Substitution (in place)
        s("subst", { i(1, "$str"), t(" =~ s/"), i(2, "pattern"), t("/"), i(3, "replacement"), t("/"), i(4, "g"), t(";") }),
        -- Non-destructive substitution (/r) -> new string, source untouched
        s("substr", { t("my $"), i(1, "new"), t(" = "), i(2, "$str"), t(" =~ s/"), i(3, "pat"), t("/"), i(4, "repl"), t("/"), i(5, "gr"), t(";") }),
        -- Global match -> list of all captures
        s("mg", { t("my @matches = "), i(1, "$str"), t(" =~ /"), i(2, "(\\S+)"), t("/g;") }),
        -- Transliterate / count
        s("tr", { i(1, "$str"), t(" =~ tr/"), i(2, "a-z"), t("/"), i(3, "A-Z"), t("/;") }),

        -- ---- DATA STRUCTURES -----------------------------------------------
        s("split", { t("my @"), i(1, "parts"), t(" = split /"), i(2, ","), t("/, "), i(3, "$str"), t(";") }),
        s("join",  { t("my $"), i(1, "str"), t(" = join '"), i(2, ","), t("', "), i(3, "@list"), t(";") }),
        s("map",   { t("my @"), i(1, "out"), t(" = map { "), i(2, "$_"), t(" } "), i(3, "@in"), t(";") }),
        s("grep",  { t("my @"), i(1, "out"), t(" = grep { /"), i(2, "pattern"), t("/ } "), i(3, "@in"), t(";") }),
        s("sortn", { t("my @"), i(1, "sorted"), t(" = sort { $a <=> $b } "), i(2, "@list"), t(";") }),
        s("each",  { t("while (my ($"), i(1, "key"), t(", $"), i(2, "val"), t(") = each %"), i(3, "hash"), t({ ") {", "    " }), i(4), t({ "", "}" }) }),
        s("keys",  { t("foreach my $"), i(1, "key"), t(" (sort keys %"), i(2, "hash"), t({ ") {", "    " }), i(3), t({ "", "}" }) }),

        -- ---- DEBUG / OUTPUT / DOC ------------------------------------------
        s("dd",  { t("use Data::Dumper; print Dumper("), i(1, "$ref"), t(");") }),
        s("die", { t("die \""), i(1, "message"), t(": $!\";") }),
        s("say", { t("say "), i(1, "$var"), t(";") }),
        s("pod", { t("=head1 "), i(1, "NAME"), t({ "", "", "" }), i(2), t({ "", "", "=cut" }) }),
    }, { key = "perl-domus" })
end
