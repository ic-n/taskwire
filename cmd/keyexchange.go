package main

import (
	"context"
	"os"
	"strings"
	"time"

	"mvdan.cc/sh/v3/interp"
	"mvdan.cc/sh/v3/syntax"
)

func handleError(err error) {
	if err != nil {
		panic(err)
	}
}

func main() {
	shell, err := interp.New(interp.StdIO(os.Stdin, os.Stdout, os.Stderr))
	handleError(err)

	err = run(shell, "echo test me", "?")
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
