package utils

import (
	"strconv"
	"devops/calculator/structs"
	"fmt"
)

func ConvertToFloat(num string) (float64, error) {
	floatNum, err := strconv.ParseFloat(num, 64)

	if err != nil {
		return 0, err
	}
	return floatNum, nil
}

func ReturnError(message string) structs.ResponseError {
	responseError := structs.ResponseError{
		Error: message,
	}

	return responseError
}

func ReturnSuccess(result float64) structs.ResponseSuccess {
	responseSuccess := structs.ResponseSuccess{
		Result: result,
	}

	return responseSuccess
}

func FormatResult(param1 float64, param2 float64, result float64) string {
	return fmt.Sprintf("%.2f / %.2f = %.2f", param1, param2, result)
}

