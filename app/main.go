package main

import (
	"html/template"
	"log"
	"net/http"
	"net/url"
	"os"
	"time"

	client "github.com/influxdata/influxdb1-client"
)

type App struct {
	Version string
}

func InsertInfluxDB(version string, request *http.Request, value int) {

	var (
		sampleSize = 1000
		pts        = make([]client.Point, sampleSize)
		influxUrl  = "http://localhost:8086"
	)

	if os.Getenv("ENV") == "PROD" {
		influxUrl = "http://influxdb.monitoring.svc.cluster.local:8086"
	}

	host, err := url.Parse(influxUrl)
	if err != nil {
		log.Print(err)
	}
	con, err := client.NewClient(client.Config{URL: *host})
	if err != nil {
		log.Print(err)
	}

	pts[1] = client.Point{
		Measurement: "response",
		Tags: map[string]string{
			"version": version,
			"ip":      request.RemoteAddr,
		},
		Fields: map[string]interface{}{
			"http_response": value,
		},
		Time:      time.Now(),
		Precision: "n",
	}

	bps := client.BatchPoints{
		Points:   pts,
		Database: "response",
	}
	_, err = con.Write(bps)
	if err != nil {
		log.Print(err)
	}
}

func WelcomeHandler(response http.ResponseWriter, request *http.Request) {
	tmplt := template.New("index.html")
	tmplt, _ = tmplt.ParseFiles("templates/index.html")
	responseCode := 200
	version := os.Getenv("APP_VERSION")
	r := App{Version: version}

	InsertInfluxDB(version, request, responseCode)

	response.WriteHeader(responseCode)
	tmplt.Execute(response, r)
}

func ErrorHandler(response http.ResponseWriter, request *http.Request) {
	tmplt := template.New("error.html")
	tmplt, _ = tmplt.ParseFiles("templates/error.html")
	responseCode := 500
	version := os.Getenv("APP_VERSION")
	r := App{Version: version}

	InsertInfluxDB(version, request, responseCode)

	response.WriteHeader(responseCode)
	tmplt.Execute(response, r)
}

func HealthCheck(w http.ResponseWriter, r *http.Request) {
	w.WriteHeader(200)
}

func main() {
	http.HandleFunc("/", WelcomeHandler)
	http.HandleFunc("/status", HealthCheck)

	http.ListenAndServe(":80", nil)
}
