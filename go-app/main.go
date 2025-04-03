package main

import (
	"fmt"

    "github.com/gnolang/gno/gno.land/pkg/gnoclient"
    "github.com/gnolang/gno/tm2/pkg/crypto/keys"
	rpcclient "github.com/gnolang/gno/tm2/pkg/bft/rpc/client"
	"github.com/gnolang/gno/tm2/pkg/crypto"

)

func main() {
    // Initialize keybase from a directory
    keybase, _ := keys.NewKeyBaseFromDir("path/to/keybase/dir")

    // Create signer
    signer := gnoclient.SignerFromKeybase{
        Keybase:  keybase,
        Account:  "MyKey",     // Name of your keypair in keybase
        Password: "", // Password to decrypt your keypair
        ChainID:  "dev",      // id of gno.land chain
    }

	// Initialize the RPC client
    rpc, err := rpcclient.NewHTTPClient("https://rpc.gno.land:443")
    if err != nil {
        panic(err)
    }

    // Initialize the gnoclient
    client := gnoclient.Client{
        Signer:    signer,
        RPCClient: rpc,
    }

	// Convert Gno address string to `crypto.Address`
	addr, err := crypto.AddressFromBech32("g1g37jpfcnnvmpfajhcdv9syvdy7w2kr47frss90") // your Gno address
	if err != nil {
		panic(err)
	}

	accountRes, _, err := client.QueryAccount(addr)
	if err != nil {
		panic(err)
	}

	fmt.Println(accountRes)
}