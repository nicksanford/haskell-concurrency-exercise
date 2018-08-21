#!/bin/bash
stack clean
stack build --profile
rm wc-l-exe.eventlog wc-l-exe.dashs wc-l-exe.prof
stack exec -- wc-l-exe ../concurrent-wc/tmp/ +RTS -l # generate eventlog
stack exec -- wc-l-exe ../concurrent-wc/tmp/ +RTS -p # generate profile
stack exec -- wc-l-exe ../concurrent-wc/tmp/ +RTS -s 2> wc-l-exe.dashs
stack exec -- wc-l-exe ../concurrent-wc/tmp/ > wc-l-exe.output
