package structs

import "time"

type Operation struct {
	Time time.Time `json:"time"`
	Result string `json:"result"`
	Operation string `json:"operation"`
}

type ResponseSuccess struct {
	Result float64 `json:"result"`
}

type ResponseError struct {
	Error string `json:"error"`
}