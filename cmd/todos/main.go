package main

import (
	"net/http"

	"github.com/gin-gonic/gin"
)

func main() {
    r := gin.Default()
    r.GET("/", func(c *gin.Context) {
	    c.String(http.StatusOK, "Hello to the Summer of Nix folks!")
    })
    r.Run()
}
