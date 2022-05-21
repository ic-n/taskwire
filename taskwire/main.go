package main

import "C"
import (
	"bytes"
	"fmt"
	"strconv"
	"strings"

	"golang.org/x/crypto/ssh"
)

func main() {
	Top()
}

//export Top
func Top() int64 {
	config := &ssh.ClientConfig{
		User: "root",
		Auth: []ssh.AuthMethod{
			ssh.Password("taskwire"),
		},
		HostKeyCallback: ssh.InsecureIgnoreHostKey(),
	}
	client, err := ssh.Dial("tcp", "127.0.0.1:2222", config)
	if err != nil {
		fmt.Print("Failed to dial: ", err)
		return 901
	}
	defer client.Close()

	// Each ClientConn can support multiple interactive sessions,
	// represented by a Session.
	session, err := client.NewSession()
	if err != nil {
		fmt.Print("Failed to create session: ", err)
		return 902
	}
	defer session.Close()

	// Once a Session is created, you can execute a single command on
	// the remote side using the Run method.
	var b bytes.Buffer
	session.Stdout = &b
	if err := session.Run(`bash -c "echo $RANDOM"`); err != nil {
		fmt.Print("Failed to run: " + err.Error())
		return 903
	}
	v, err := strconv.Atoi(strings.TrimSpace(b.String()))
	if err != nil {
		fmt.Print("Failed to convert to string: " + err.Error())
		return 904
	}
	return int64(v)
}
