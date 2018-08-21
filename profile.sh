#!/bin/bash
stack install ghc-events
stack clean
stack build --profile
rm wc-l-exe.eventlog wc-l-exe.dashs wc-l-exe.prof wc-l-ghc-events.output
stack exec -- wc-l-exe ./tmp/ +RTS -l # generate eventlog
stack exec -- wc-l-exe ./tmp/ +RTS -p # generate profile
stack exec -- wc-l-exe ./tmp/ +RTS -s 2> wc-l-exe.dashs
stack exec -- wc-l-exe ./tmp/ > wc-l-exe.output
stack exec ghc-events show wc-l-exe.eventlog > wc-l-ghc-events.output
threadscope wc-l-exe.eventlog
