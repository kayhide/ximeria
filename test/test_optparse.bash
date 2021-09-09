#!/usr/bin/env bash

source "optparse.bash"

test_optparse_display_usage_with_nothing() {
    echo | assertTrue optparse.display_usage
}

test_optparse_display_usage_with_options() {
    local expected
    read -r -d '' expected <<EOF
Usage: prog [OPTIONS] COMMAND

Available options:
  --version
  --help
EOF
    read -r -d '' spec <<EOF
program: prog
opts: [version, help]
args: [COMMAND]
EOF

    assertEquals "$expected" "$(
      echo "$spec" | optparse.display_usage
    )"

}

test_optparse_display_usage_with_command() {
    local expected
    read -r -d '' expected <<EOF
Usage: prog COMMAND

Available command:
  list
  show
EOF
    read -r -d '' spec <<EOF
program: prog
args: [COMMAND]
types:
  COMMAND: [list, show]
EOF

    assertEquals "$expected" "$(
      echo "$spec" | optparse.display_usage
    )"

}

test_optparse_parse_with_only_opts() {
    local expected
    read -r -d '' expected <<EOF
version=
EOF
    read -r -d '' spec <<EOF
program: prog
opts: [version, help]
args: [COMMAND]
EOF

    assertEquals "$expected" "$(
      echo "$spec" | optparse.parse --version
    )"
}

test_optparse_parse_with_args() {
    local expected
    read -r -d '' expected <<EOF
command=create
args=(--help)
EOF
    read -r -d '' spec <<EOF
program: prog
opts: [version, help]
args: [COMMAND, ...ARGS]
EOF

    assertEquals "$expected" "$(
      echo "$spec" | optparse.parse create --help
    )"
}

test_optparse_parse_with_invalid_args() {
    read -r -d '' spec <<EOF
program: prog
opts: [version, help]
args: [COMMAND]
types:
  COMMAND: [create]
EOF

    assertFalse "$(echo "$spec" | optparse.parse hello 2>&1)"
    assertContains "$(
      echo "$spec" | optparse.parse hello 2>&1
    )" "invalid command: hello"
}


. shunit2
