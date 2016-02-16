package main

import (
	"fmt"
	"net"
	"os"
)

func main() {
	if len(os.Args) != 2 {
		printUsage()
	}

	ipToBindTo := net.ParseIP(os.Args[1])
	if ipToBindTo == nil {
		fmt.Printf("%s is not an ip address", os.Args[1])
		printUsage()
	}

	tcpAddr := &net.TCPAddr{IP: ipToBindTo, Port: 0}
	tcpLn, err := net.ListenTCP("tcp", tcpAddr)
	if err != nil {
		fmt.Printf("Failed to start TCP listener. Err: %s\n", err)
		os.Exit(1)
	} else {
		fmt.Printf("%d\n", tcpLn.Addr().(*net.TCPAddr).Port)
		os.Exit(0)
	}
}

func printUsage() {
	fmt.Printf("\nUsage: portland <ip-address-to-bind-to>\n\n")
	os.Exit(1)
}
