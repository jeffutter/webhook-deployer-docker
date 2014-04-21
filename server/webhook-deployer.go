package main

import (
	//"fmt"
	"encoding/json"
	"net/http"
	"os"
	"os/exec"
)

type Webhook struct {
	Repository struct {
		Url  string `json:"url"`
		Name string `json:"name"`
	} `json:"repository"`
}

func indexHandler(res http.ResponseWriter, req *http.Request) {
	hook := new(Webhook)
	json.NewDecoder(req.Body).Decode(hook)

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

	res.Header().Set("Content-Type", "application/json; charset=utf-8")
}

func main() {
	http.HandleFunc("/", indexHandler)
	http.ListenAndServe(":9001", nil)
}
