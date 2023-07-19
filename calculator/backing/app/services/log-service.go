package services

import (
	"fmt"
	"log"
	"os"
	"errors"
	"github.com/gin-gonic/gin"
)

var (
	WarningLogger *log.Logger
	InfoLogger    *log.Logger
	ErrorLogger   *log.Logger
	FatalLogger   *log.Logger
)

const (
	WL string = "w"
	IL string = "i"
	EL string = "e"
	FL string = "f"
)

func InfoLog(message string) {
	file, err := os.OpenFile(GetLogFile(), os.O_APPEND|os.O_CREATE|os.O_WRONLY, 0666)
	if err != nil {
		log.Fatal(LogFileError(err))
	}

	InfoLogger = log.New(file, "INFO: ", log.Ldate|log.Ltime|log.Lshortfile)
	InfoLogger.Println(message)
}

func WarningLog(message string) {
	file, err := os.OpenFile(GetLogFile(), os.O_APPEND|os.O_CREATE|os.O_WRONLY, 0666)
	if err != nil {
		log.Fatal(LogFileError(err))
	}

	WarningLogger = log.New(file, "WARN: ", log.Ldate|log.Ltime|log.Lshortfile)
	WarningLogger.Println(message)
}

func ErrorLog(message string) {
	file, err := os.OpenFile(GetLogFile(), os.O_APPEND|os.O_CREATE|os.O_WRONLY, 0666)
	if err != nil {
		log.Fatal(LogFileError(err))
	}

	ErrorLogger = log.New(file, "ERROR: ", log.Ldate|log.Ltime|log.Lshortfile)
	ErrorLogger.Println(message)
}

func FatalLog(message string) {
	file, err := os.OpenFile(GetLogFile(), os.O_APPEND|os.O_CREATE|os.O_WRONLY, 0666)
	if err != nil {
		log.Fatal(LogFileError(err))
	}

	FatalLogger = log.New(file, "FATAL: ", log.Ldate|log.Ltime|log.Lshortfile)
	FatalLogger.Println(message)
}

func LogFileError(err error) string {
	return fmt.Sprintf("Could not access calculator.log file: err: %v", err)
}

func GetLogFile() string {
	return "./log/calculator.log"
}

func CreateLogDirectory() {
	if _, err := os.Stat("log"); errors.Is(err, os.ErrNotExist) {
		err := os.Mkdir("log", os.ModePerm)
		if err != nil {
			WarningLogger.Println(err)
		}
	}
}

func LoggingRequest(c *gin.Context, status int, logger string, message string) {

	message = fmt.Sprintf("%s %s %s %s", c.Request.Method, fmt.Sprint(status), c.Request.Host+c.Request.URL.Path, message)

	if logger == IL {
		InfoLog(message)
	}

	if logger == WL {
		WarningLog(message)
	}

	if logger == EL {
		ErrorLog(message)
	}

	if logger == FL {
		FatalLog(message)
	}

}