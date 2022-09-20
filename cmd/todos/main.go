package main

import (
	"net/http"

	"github.com/gin-gonic/gin"
)

type todo struct {
    ID int64    `json:"id"`
    Task string `json:"task"`
    Done bool   `json:"done"`
}

func main() {
    todos := []todo{
        // Update this later
        {
            ID: 1,
            Task: "update the TODO service deployment in a super slick way using Nix",
            Done: false,
            //Done: true,
        },
        /*{
            ID: 2,
            Task: "continue exploring Nix and DevOps",
            Done: false,
        },*/
    }

    r := gin.Default()
    r.GET("/todos", func(c *gin.Context) {
	    c.JSON(http.StatusOK, todos)
    })
    r.Run()
}
