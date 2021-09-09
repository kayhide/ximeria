#!/usr/bin/env bash

testUsage() {
    assertFalse ximeria 2>&1
    assertContains "$(ximeria 2>&1)" Usage
}

testHelp() {
    assertContains "$(ximeria --help)" Usage
}

testList() {
    assertContains "$(ximeria list --help)" Usage
}

. shunit2
