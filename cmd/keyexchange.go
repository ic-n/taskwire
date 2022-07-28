package main

import (
	"bytes"
	"context"
	"crypto/rand"
	"crypto/rsa"
	"crypto/x509"
	"encoding/asn1"
	"encoding/pem"
	"fmt"
	"os"
	"strings"
	"time"

	"golang.org/x/crypto/ssh"
	"mvdan.cc/sh/v3/interp"
	"mvdan.cc/sh/v3/syntax"
)

func handleError(err error) {
	if err != nil {
		panic(err)
	}
}

func main() {
	reader := rand.Reader
	bitSize := 2048

	key, err := rsa.GenerateKey(reader, bitSize)
	handleError(err)

	// pass := os.Args[1]
	pass := "os.Args[1]"

	private := privatePEMKey(key, pass)
	public := publicPEMKey(key.PublicKey, pass)

	fmt.Println(private)
	fmt.Println(public)

	sshPub, err := ssh.NewPublicKey(&key.PublicKey)
	handleError(err)

	sshPubBytes := sshPub.Marshal()
	parsed, err := ssh.ParsePublicKey(sshPubBytes)
	handleError(err)

	record := ssh.MarshalAuthorizedKey(parsed)

	shell, err := interp.New(interp.StdIO(os.Stdin, os.Stdout, os.Stderr))
	handleError(err)

	cmd := fmt.Sprintf("echo \"%s\" >> .ssh/authorized_keys", record)
	err = run(shell, cmd, "add to .ssh/authorized_keys")
	handleError(err)
}

func run(r *interp.Runner, command string, name string) error {
	prog, err := syntax.NewParser().Parse(strings.NewReader(command), name)
	if err != nil {
		return err
	}
	r.Reset()

	ctx, cancel := context.WithTimeout(context.Background(), 20*time.Second)
	defer cancel()

	return r.Run(ctx, prog)
}

func privatePEMKey(key *rsa.PrivateKey, pass string) string {
	buf := bytes.Buffer{}

	privateKey := &pem.Block{
		Type:  "RSA PRIVATE KEY",
		Bytes: x509.MarshalPKCS1PrivateKey(key),
	}

	block, err := x509.EncryptPEMBlock(rand.Reader, privateKey.Type, privateKey.Bytes, []byte(pass), x509.PEMCipherAES256)
	handleError(err)

	err = pem.Encode(&buf, block)
	handleError(err)

	return buf.String()
}

func publicPEMKey(pubkey rsa.PublicKey, pass string) string {
	buf := bytes.Buffer{}

	asn1Bytes, err := asn1.Marshal(pubkey)
	handleError(err)

	publicKey := &pem.Block{
		Type:  "RSA PUBLIC KEY",
		Bytes: asn1Bytes,
	}

	block, err := x509.EncryptPEMBlock(rand.Reader, publicKey.Type, publicKey.Bytes, []byte(pass), x509.PEMCipherAES256)
	handleError(err)

	err = pem.Encode(&buf, block)
	handleError(err)

	return buf.String()
}
