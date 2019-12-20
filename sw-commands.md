

`fift -I fift-lib -s sw/new.fif 0 wallets/stage2`

`fift -I fift-lib -s tools/send-grams.fif wallets/stage2 0QAiVSE0w_RdWT23IAzUQdGT65JE6eqGoXIZDLs_mf-MtsGL 7 10`

# General

## Lite Client
`lite-client -a <address> -p  liteserver.pub`

### Commands 
`runmethod <contract addr> seqno` - returns seqno method
`sendfile queries/send-grams.boc` - sends file queries/send-grams.boc
`getaccount <contract address>` - gets contract account details

# SW

*Hashes are passed as integers to all commands and scripts.*

## Deploy SW
`func stdlib.fc sw/sw.fc -o sw/sw.fif -P`
`fift -I fift-lib -s sw/new.fif <workchain id> wallets/sw`
`lite-client -a <address> -p  liteserver.pub --cmd " sendfile queries/create-sw.boc"`

## Methods

`runmethod <contract address> seqno`
`runmethod <contract address> validate 200`
`runmethod <contract address> get_timeout 200`
`runmethod <contract address> get_info 200`

*Sample contract address: `0:54f31b12814165f64b564e51d351e4e04ac0a990a764c3ac0315221cbdda8f82 `.*

## Set Hash
`fift -I fift-lib -s sw/scripts/set-hash.fif wallets/sw <contract address> <hash> <timeout> <seqno> <information>`
`lite-client -a <address> -p  liteserver.pub --cmd "sendfile queries/sw-sethash.boc"`

## Remove Hash
`fift -I fift-lib -s sw/scripts/rm-hash.fif wallets/sw <contract address> <hash> <seqno>`
`lite-client -a <address> -p  liteserver.pub --cmd "sendfile queries/sw-rmhash.boc"`

# Scripts
`./sw-test-init.sh 1 10`
`./sw-test.sh 1 10`