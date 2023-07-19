package repositories

import (
	"bytes"
	"context"
	"devops/calculator/database"
	"devops/calculator/structs"
	"encoding/json"
)


var client, connErr = database.Connect();
var ctx = context.TODO();

func SaveHistoric(newOperation structs.Operation) error {

	if connErr != nil {
		return connErr;
	}

	newOperationJson, err := json.Marshal(newOperation)
    if err != nil {
	   return err
    }

	err2 := client.RPush(ctx, "historic", newOperationJson).Err()
	if err2 != nil {
		return err2
	}

	return err;
}

func GetHistoric() ([]structs.Operation, error) {
	var historicList = []structs.Operation{};
	var historic structs.Operation;

	if connErr != nil {
		return nil, connErr;
	}

	historicListCache, err := client.LRange(ctx, "historic", 0, -1).Result()
	if err != nil {
		return nil, err;
	}

	for _, h := range historicListCache {
		historicDecoder := json.NewDecoder(bytes.NewReader([]byte(h)))

		for historicDecoder.Decode(&historic) == nil {
			historicList = append(historicList, historic)
		}
	}
	return historicList, nil;

}
