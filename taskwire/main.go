package main

import "C"
import (
	"bytes"
	"fmt"
	"strings"

	"golang.org/x/crypto/ssh"
)

// C.GoString(hello)
// C.CString("Hello")

func main() {
	_ = SingleCall
}

//export SingleCall
func SingleCall(user, passord, dial, command *C.char) *C.char {
	config := &ssh.ClientConfig{
		User: C.GoString(user),
		Auth: []ssh.AuthMethod{
			ssh.Password(C.GoString(passord)),
		},
		HostKeyCallback: ssh.InsecureIgnoreHostKey(),
	}
	client, err := ssh.Dial("tcp", C.GoString(dial), config)
	if err != nil {
		return C.CString(fmt.Sprint("Failed to dial: ", err))
	}
	defer client.Close()

	session, err := client.NewSession()
	if err != nil {
		return C.CString(fmt.Sprint("Failed to create session: ", err))
	}
	defer session.Close()

	var b bytes.Buffer
	session.Stdout = &b
	if err := session.Run(C.GoString(command)); err != nil {
		return C.CString(fmt.Sprint("Failed to run: " + err.Error()))
	}

	return C.CString(strings.TrimSpace(b.String()))
}
