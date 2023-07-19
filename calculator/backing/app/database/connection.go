package database

import (
	"log"
	"os"

	"github.com/joho/godotenv"
	"github.com/redis/go-redis/v9"
)

func Connect() (*redis.Client, error) {
	err := godotenv.Load("local.env")
	if err != nil {
		log.Fatalf("Some error occured. Err: %s", err)

		return nil, err;
	}

	var lb_url = os.Getenv("LB_URL");
	var pass = os.Getenv("PASS");

	client := redis.NewClient(&redis.Options{
        Addr:	  lb_url+":6379",
        Password: pass,
        DB:		  0,
    });

	return client, nil;
}