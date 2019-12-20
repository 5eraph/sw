#!/bin/sh
BASEDIR=$(dirname "$0")
WALLET="$BASEDIR/wallets/stage2"
SEQNO=$1
GRAMS=$2

. "$BASEDIR/util/wrappers.sh"

run_func "$BASEDIR/sw/sw.fc" -o "$BASEDIR/sw/sw.fif" -P
NEW_OUTPUT=$(run_fift "$BASEDIR/sw/new.fif" 0 "$BASEDIR/wallets/sw")

ADDR=$(printf "%s" "$NEW_OUTPUT" | grep "new validator address" | sed 's/.*= //g')
NON_BOUNCABLE=$(printf "%s" "$NEW_OUTPUT" | grep "Non-bounceable address" | sed 's/.*: //g')
BOUNCABLE=$(printf "%s" "$NEW_OUTPUT" | grep "Bounceable address" | sed 's/.*: //g')

printf "ADDR=%s\nNON_BOUNCABLE=%s\nBOUNCABLE=%s\n" "$ADDR" "$NON_BOUNCABLE" "$BOUNCABLE" > .sw-info

run_fift "$BASEDIR/tools/send-grams.fif" "$WALLET" $NON_BOUNCABLE $SEQNO $GRAMS
run_lite_cmd "sendfile $BASEDIR/queries/send-grams.boc"

sleep 10 # wait 10 s to credit the account
run_lite_cmd "sendfile $BASEDIR/queries/create-sw.boc"