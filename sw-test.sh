#!/bin/sh

. "util/wrappers.sh"

SEQNO_SHIFT=${1:-1}

# load address
if ! grep "ADDR=" ".sw-info" > /dev/null; then 
    printf "%s\n" ".sw-info file not found, please run sw-test-init.sh first."
    exit 2
fi
ADDR=$(grep "ADDR=" ".sw-info" | sed "s/ADDR=//g")

run_fift sw/scripts/set-hash.fif wallets/sw $ADDR 200 0 $(sum $SEQNO_SHIFT 0)
run_lite_cmd "sendfile queries/sw-sethash.boc"
run_fift sw/scripts/set-hash.fif wallets/sw $ADDR 300 1586590978 $(sum $SEQNO_SHIFT 1)
run_lite_cmd "sendfile queries/sw-sethash.boc"
run_fift sw/scripts/set-hash.fif wallets/sw $ADDR 400 1566590978 $(sum $SEQNO_SHIFT 2)
run_lite_cmd "sendfile queries/sw-sethash.boc"
run_fift sw/scripts/set-hash.fif wallets/sw $ADDR 500 1586590978 $(sum $SEQNO_SHIFT 3) 11111111111111
run_lite_cmd "sendfile queries/sw-sethash.boc"

run_fift sw/scripts/rm-hash.fif wallets/sw $ADDR 500 $(sum $SEQNO_SHIFT 4)
run_lite_cmd "sendfile queries/sw-rmhash.boc"
