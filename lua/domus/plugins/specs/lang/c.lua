-- C Language Specs
-- clangd configured in lsp/init.lua, clang-format in conform.lua, codelldb in dap/init.lua
-- Snippets loaded here via LuaSnip

return {
    {
        "L3MON4D3/LuaSnip",
        ft = { "c", "cpp" },
        config = function()
            local ls = require("luasnip")
            local s = ls.snippet
            local t = ls.text_node
            local i = ls.insert_node
            local c = ls.choice_node

            ls.add_snippets("c", {}, { key = "c-domus" })

            ls.add_snippets("c", {
                -- Main function
                s("main", {
                    t({ "#include <stdio.h>", "#include <stdlib.h>", "", "int main(int argc, char *argv[])", "{", "    " }),
                    i(1),
                    t({ "", "    return 0;", "}" }),
                }),

                -- Main (minimal)
                s("mainm", {
                    t({ "int main(void)", "{", "    " }),
                    i(1),
                    t({ "", "    return 0;", "}" }),
                }),

                -- Include guard
                s("guard", {
                    t("#ifndef "), i(1, "HEADER_H"),
                    t({ "", "#define " }), i(2, "HEADER_H"),
                    t({ "", "", "" }),
                    i(3),
                    t({ "", "", "#endif" }),
                }),

                -- #include system header
                s("incs", {
                    t("#include <"), i(1, "stdio.h"), t(">"),
                }),

                -- #include local header
                s("incl", {
                    t('#include "'), i(1, "header.h"), t('"'),
                }),

                -- Syscall includes
                s("syscall", {
                    t({
                        "#define _GNU_SOURCE",
                        "#include <unistd.h>",
                        "#include <sys/syscall.h>",
                        "#include <stdio.h>",
                        "#include <stdlib.h>",
                        "",
                        "int main(void)",
                        "{",
                        "    ",
                    }),
                    i(1, "long ret = syscall(SYS_getpid);"),
                    t({ "", "    printf(\"%ld\\n\", ret);", "    return 0;", "}" }),
                }),

                -- POSIX file I/O
                s("fileio", {
                    t({
                        "#include <fcntl.h>",
                        "#include <unistd.h>",
                        "#include <stdio.h>",
                        "#include <stdlib.h>",
                        "",
                        "int main(void)",
                        "{",
                        '    int fd = open("',
                    }),
                    i(1, "file.txt"),
                    t({ '", ' }),
                    c(2, {
                        t("O_RDONLY"),
                        t("O_WRONLY | O_CREAT | O_TRUNC, 0644"),
                        t("O_RDWR | O_CREAT, 0644"),
                    }),
                    t({
                        ");",
                        "    if (fd == -1) {",
                        '        perror("open");',
                        "        exit(EXIT_FAILURE);",
                        "    }",
                        "",
                        "    ",
                    }),
                    i(3),
                    t({ "", "", "    close(fd);", "    return 0;", "}" }),
                }),

                -- fork
                s("fork", {
                    t({
                        "#include <unistd.h>",
                        "#include <stdio.h>",
                        "#include <stdlib.h>",
                        "#include <sys/wait.h>",
                        "",
                        "int main(void)",
                        "{",
                        "    pid_t pid = fork();",
                        "",
                        "    if (pid == -1) {",
                        '        perror("fork");',
                        "        exit(EXIT_FAILURE);",
                        "    }",
                        "",
                        "    if (pid == 0) {",
                        "        // Child process",
                        "        ",
                    }),
                    i(1, 'printf("child: %d\\n", getpid());'),
                    t({
                        "",
                        "        _exit(0);",
                        "    }",
                        "",
                        "    // Parent process",
                        "    ",
                    }),
                    i(2, "wait(NULL);"),
                    t({ "", "    return 0;", "}" }),
                }),

                -- mmap
                s("mmap", {
                    t({
                        "#include <sys/mman.h>",
                        "#include <fcntl.h>",
                        "#include <unistd.h>",
                        "#include <stdio.h>",
                        "#include <stdlib.h>",
                        "#include <string.h>",
                        "",
                    }),
                    i(1),
                }),

                -- struct definition
                s("struct", {
                    t("typedef struct {"),
                    t({ "", "    " }),
                    i(1, "int field;"),
                    t({ "", "} " }),
                    i(2, "name_t"),
                    t(";"),
                }),

                -- Error check pattern
                s("errchk", {
                    t("if ("),
                    i(1, "ret"),
                    t(" == -1) {"),
                    t({ "", '    perror("' }),
                    i(2, "operation"),
                    t({ '");', "    exit(EXIT_FAILURE);", "}" }),
                }),

                -- printf debug
                s("prd", {
                    t('fprintf(stderr, "DEBUG %s:%d: '),
                    i(1, "%d"),
                    t('\\n", __FILE__, __LINE__, '),
                    i(2, "var"),
                    t(");"),
                }),

                -- Function definition
                s("func", {
                    i(1, "void"),
                    t(" "),
                    i(2, "function_name"),
                    t("("),
                    i(3, "void"),
                    t(")"),
                    t({ "", "{", "    " }),
                    i(4),
                    t({ "", "}" }),
                }),

                -- Socket (TCP client)
                s("socket", {
                    t({
                        "#include <sys/socket.h>",
                        "#include <netinet/in.h>",
                        "#include <arpa/inet.h>",
                        "#include <unistd.h>",
                        "#include <stdio.h>",
                        "#include <stdlib.h>",
                        "#include <string.h>",
                        "",
                    }),
                    i(1),
                }),

                -- Signal handler
                s("signal", {
                    t({
                        "#include <signal.h>",
                        "#include <stdio.h>",
                        "#include <stdlib.h>",
                        "",
                        "static volatile sig_atomic_t got_signal = 0;",
                        "",
                        "static void handler(int sig)",
                        "{",
                        "    got_signal = 1;",
                        "}",
                        "",
                    }),
                    i(1),
                }),

                -- Thread (pthread)
                s("pthread", {
                    t({
                        "#include <pthread.h>",
                        "#include <stdio.h>",
                        "#include <stdlib.h>",
                        "",
                        "static void *thread_fn(void *arg)",
                        "{",
                        "    ",
                    }),
                    i(1, '(void)arg;'),
                    t({
                        "",
                        "    return NULL;",
                        "}",
                        "",
                    }),
                    i(2),
                }),
            }, { key = "c-domus" })

            -- Share snippets with C++
            ls.filetype_extend("cpp", { "c" })
        end,
    },
}
