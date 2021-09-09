#!/usr/bin/env bash

test_without_args() {
    assertFalse ximeria 2>&1
    assertContains "$(ximeria 2>&1)" Usage
}

test_help() {
    assertContains "$(ximeria --help)" Usage
}

test_list_help() {
    assertContains "$(ximeria list --help)" Usage
}

. shunit2
