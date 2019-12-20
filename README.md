# SW - Software Validation TON Smart Contract

## Scenario

From time to time we face compromising of software distribution channels. Usage of distributed and cryptographically proven technology would benefit consumer protection.  

## Core Idea 

The core idea is to create blockchain based and distributor specific registry to provide hash validation of obtained binaries. This way we make sure that in case of servers being compromised consumers will be able to verify software securely and independently. (*We assume use of specialized hardware to store contract keys to make sure contract ownership is protected in case of infrastructure being compromised.*)

## Implementation

SW is implemented as a single company/provider registry of hashes. SC can operate in two modes - plain hash registry or hash and hash information registry. In second mode we store additional information for each hash record. Each operation mode stores timeout for each hash. Timeout 0 means infinite validity.

Code: `sw/sw.fc`

### Storage 

We store TS data in following structure:
- 256 bit - public key of the contract owner
- 16 bit - seqno - automatically resets to 0 after reaching 65535
- 1 bit - SC operation mode (0 = hash only, 1 = hash and information)
- dict - dictionary containing hash records - 256 bit keys representing hashes.
    - value:
        - 32 bit timestamp - timeout
        - (mode 1 only) reference to cell containing information

### Internal Messages

None.

### External Messages

External messages allows contract owner to manipulate hash registry. It is possible to set or remove hash record.

#### External Messages Body' Structure

512 bit - contract owner signature
64 bit - query id - also provides replay protection - holds timeout timestamp
16 bit - seqno - replay protection within timeout window
2 bit - operation 
... operation specific data:
0 - init message - no additional data required
1 - set hash record
    - reference to cell containing 256 bit hash 
    - 32 bit - timeout
    - (mode 1 only) reference to cell containing information to store with the hash
2 - set end of refunds
    - reference to cell containing 256 bit hash 

### Public Methods

- `int proof_ownership(int owner, cell data, cell signatureC)` - Provides a way to verify the owner of tickets. The verifier gives one time code to the owner which has to sign it. One time code is passed as data along with owner and signature cell to the method. `proof_ownership` returns -1 if signature matches or 0 otherwise. *This method may be executed locally in VM as well. It is included in contract for cases when we would like to run without additional dependencies.*

- `int get_timeout(int hash)` - validates provided hash
- `cell get_info(int hash)` - returns cell containing information about the hash, in 0 mode returns empty cell
- `int seqno()` - If refunds are accepted returns -1, otherwise 0.
- `int get_owner()` - Returns owner of the contract.
- `int seqno()` - Returns seqno.

## Testing 

### Local 
Tests core functions of SW.
Requirements:
- comment out recv_internal and recv_external.
- uncomment main

Execute: `func stdlib.fc sw/sw.fc -o sw/sw.fif && fift -I fift-lib sw/test_local.fif`
Exit code 0 means tests passed successfully. Other exit codes means failures in specific tests.

### On Chain 

Use shell scripts provided.
Requirements:
- `stage2.addr` and `stage2.pk` - stage2 named wallet holding some grams for testing
  - use `create-wallet.sh` and then `sendfile queries/create-wallet-query.boc` through lite client (remember that wallet has to hold some grams before sending the file)
- set correct values of `LITE_CLIENT_BIN`, `LITE_SERVER_ADDR`, `LITE_SERVER_PUB`, `FIFT` and `FUNC` in `util/wrappers.sh`
- remove `wallets/sw.addr` and `wallets/sw.pk` (optional - do it if you want to test deployment)

`sw-test-init.sh` <source wallet seqno> <grams to send> - deploys contract (generated contract wallet is stored in `wallets/sw.*` and wallet info in `.sw-info`)
`sw-test.sh` <ts seqno> - tests external messages (after deployment seqno is 1)

*Test transfer uses sw wallet as the destination.*

### Test & Operation Notes 

To use smart contract in custom way you use `fif` scripts in `ts/scripts`. 

#### Creation

For manual TS creation use `sw/new.fif`.

#### Internal Messages

None.

#### External Messages

Use scripts in `sw/scripts` to generate external messages.

`sw/scripts/set-hash.fif` <contract control wallet> <contract addr> <hash> <hashTimeout> <seq> [<information>] - set hash record
`sw/scripts/rm-hash.fif`  <contract owner wallet> <contract addr> <hash> <seq> - sets number of available tickets

*For more examples check sw-test\* test scripts.*

After generating external message send it with `sendfile` command through lite client. 

## Notes
- all stored integers are stored as unsigned integers
- if you are looking for how should be specific commands executed - check commands.md or specific test shell scripts
- **All scripts and commands are expected to be run from root directory of this project.**