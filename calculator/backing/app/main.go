package main

import (
	"fmt"
	"devops/calculator/handlers"
	"devops/calculator/services"
	"github.com/gin-gonic/gin"
)

func main() {
	services.CreateLogDirectory()
	services.InfoLog("Application started. Running at port 8000")

	router := gin.Default()
	router.GET("/calc/sum/:num1/:num2", handlers.HandlerSum)
	router.GET("/calc/sub/:num1/:num2", handlers.HandlerSub)
	router.GET("/calc/mult/:num1/:num2", handlers.HandlerMult)
	router.GET("/calc/div/:num1/:num2", handlers.HandlerDiv)
	router.GET("/calc/historic", handlers.HandlerHistoric)

	err := router.Run(":8000")
	if err != nil {
		services.FatalLog(fmt.Sprintf("Error on starting application: err: %v", err))
	} 

	

}
