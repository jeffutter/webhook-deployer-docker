package main

import (
	//"fmt"
	"encoding/json"
	"log"
	"net/http"
	"os"
	"os/exec"
	"time"
)

type Webhook struct {
	Repository struct {
		Url  string `json:"url"`
		Name string `json:"name"`
	} `json:"repository"`
}

func runner(ch chan *Webhook) {
	for hook := range ch {
		log.Printf("Starting %v", hook.Repository.Name)

		time.Sleep(10 * time.Second)

		origDir, _ := os.Getwd()
		//fmt.Println(os.Getwd())
		os.Chdir("repos/" + hook.Repository.Name)

		cmd := exec.Command("git", "pull")
		cmd.Stdout = os.Stdout
		cmd.Stderr = os.Stderr
		cmd.Run()

		os.Chdir(origDir)
		//fmt.Println(os.Getwd())

		cmd = exec.Command("bash", "repos/"+hook.Repository.Name+".sh")
		cmd.Stdout = os.Stdout
		cmd.Stderr = os.Stderr
		cmd.Run()
		log.Printf("Finished %v", hook.Repository.Name)
	}
}

func main() {
	ch := make(chan *Webhook, 10)
	go runner(ch)

	http.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
		hook := new(Webhook)
		json.NewDecoder(r.Body).Decode(hook)

		ch <- hook
		log.Printf("Queued %v", hook.Repository.Name)

		w.WriteHeader(200)
	})
	http.ListenAndServe(":9001", nil)
}
