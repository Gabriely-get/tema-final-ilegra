package handlers

import (
	"devops/calculator/services"
	"devops/calculator/utils"
	"devops/calculator/structs"
	"fmt"
	"net/http"
	"time"
	"github.com/gin-gonic/gin"
)

var addHistoricMessageError = "An error occurred on save calculator historic"

func HandlerSum(c *gin.Context) {
	floatNum1, err := utils.ConvertToFloat(c.Param("num1"))
	convertValueError(c, err, c.Param("num1"))

	floatNum2, err2 := utils.ConvertToFloat(c.Param("num2"))
	convertValueError(c, err2, c.Param("num2"))

	sumResult := services.Sum(floatNum1, floatNum2)

	newOperation := getNewOperation(floatNum1, floatNum2, sumResult, "ADDITION");

	addHistoric(c, newOperation)

	c.IndentedJSON(http.StatusOK, utils.ReturnSuccess(sumResult))
	services.LoggingRequest(c, 200, services.IL, " ")
}

func HandlerSub(c *gin.Context) {
	floatNum1, err := utils.ConvertToFloat(c.Param("num1"))
	convertValueError(c, err, c.Param("num1"))

	floatNum2, err2 := utils.ConvertToFloat(c.Param("num2"))
	convertValueError(c, err2, c.Param("num2"))

	subResult := services.Sub(floatNum1, floatNum2)

	newOperation := getNewOperation(floatNum1, floatNum2, subResult, "SUBTRACTION");

	addHistoric(c, newOperation)

	c.IndentedJSON(http.StatusOK, utils.ReturnSuccess(subResult))
	services.LoggingRequest(c, 200, services.IL, " ")
}

func HandlerMult(c *gin.Context) {
	floatNum1, err := utils.ConvertToFloat(c.Param("num1"))
	convertValueError(c, err, c.Param("num1"))

	floatNum2, err2 := utils.ConvertToFloat(c.Param("num2"))
	convertValueError(c, err2, c.Param("num2"))

	multResult := services.Mult(floatNum1, floatNum2)

	newOperation := getNewOperation(floatNum1, floatNum2, multResult, "MULTIPLICATION");
	
	addHistoric(c, newOperation)

	c.IndentedJSON(http.StatusOK, utils.ReturnSuccess(multResult))
	services.LoggingRequest(c, 200, services.IL, " ")
}

func HandlerDiv(c *gin.Context) {
	floatNum1, err := utils.ConvertToFloat(c.Param("num1"))
	convertValueError(c, err, c.Param("num1"))

	floatNum2, err2 := utils.ConvertToFloat(c.Param("num2"))
	convertValueError(c, err2, c.Param("num2"))

	if floatNum2 == 0 {
		message := "Mathematical indeterminacy: division by 0"

		returnBadRequest(c, message, nil)
		return
	}

	divResult := services.Div(floatNum1, floatNum2)

	newOperation := getNewOperation(floatNum1, floatNum2, divResult, "DIVISION");
	
	addHistoric(c, newOperation)

	c.IndentedJSON(http.StatusOK, utils.ReturnSuccess(divResult))
	services.LoggingRequest(c, 200, services.IL, " ")
}


func HandlerHistoric(c *gin.Context) {
	
	var list, err = services.GetHistoric()
	if err != nil {
		returnBadRequest(c, "Error on getting Historic", err);
		return;
	}

	c.IndentedJSON(http.StatusOK, list)
	services.LoggingRequest(c, 200, services.IL, " ")
}


func getNewOperation(num1 float64, num2 float64, result float64, operation string) structs.Operation {
	return structs.Operation{
		Time:      time.Now(),
		Operation: operation,
		Result:    utils.FormatResult(num1, num2, result),
	}
}

func returnBadRequest(c *gin.Context, message string, err error) {

	services.LoggingRequest(c, 400, services.WL, fmt.Sprintf(message + ": %s", err))
	
	c.IndentedJSON(http.StatusBadRequest, utils.ReturnError(message))

}

func convertValueError(c *gin.Context, err error, num string) {
	if err != nil {
		message := fmt.Sprintf("Could not convert value %s", num)
		returnBadRequest(c, message, err)
		return
	}
}

func addHistoric(c *gin.Context, newOperation structs.Operation) {
	var err = services.AddToHistoric(newOperation)
	if err != nil {
		services.LoggingRequest(c, 400, services.WL, fmt.Sprintf(addHistoricMessageError + ": %s", err))
	}
}

