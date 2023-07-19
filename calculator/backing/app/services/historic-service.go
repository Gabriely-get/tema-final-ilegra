package services

import (
	"fmt"
	"devops/calculator/structs"
	"devops/calculator/repositories"
)


func AddToHistoric(newOperation structs.Operation) error {
	var err = repositories.SaveHistoric(newOperation);

	return err;
}

func GetHistoric() ([]structs.Operation, error) {
	var historicList, err = repositories.GetHistoric();

	if err != nil {
		ErrorLog(fmt.Sprintf("Database error: err: %v", err))
		return nil, err
	}

	return historicList, nil;
}
