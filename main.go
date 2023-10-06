package main

import (
	"encoding/xml"
	"fmt"
	"io/ioutil"
	"os"
	"path/filepath"
)

type Host struct {
	Addresses []Address `xml:"address"`
}

type Address struct {
	Addr string `xml:"addr,attr"`
}

type NmapRun struct {
	Hosts []Host `xml:"host"`
}

func main() {
	var files []string

	_ = filepath.Walk(".", func(path string, info os.FileInfo, err error) error {
		if filepath.Ext(path) == ".xml" {
			files = append(files, path)
		}
		return nil
	})

	for _, file := range files {
		xmlFile, err := os.Open(file)
		if err != nil {
			fmt.Println("Error opening file:", err)
			return
		}
		defer xmlFile.Close()

		byteValue, _ := ioutil.ReadAll(xmlFile)

		var nmapRun NmapRun
		xml.Unmarshal(byteValue, &nmapRun)

		fmt.Println("Xml File: ",file)
		for i := 0; i < len(nmapRun.Hosts); i++ {
			for j := 0; j < len(nmapRun.Hosts[i].Addresses); j++ {
				fmt.Println("IP Address: ", nmapRun.Hosts[i].Addresses[j].Addr)
			}
		}
		fmt.Println("\n")
	}
}
