package apis

import (
	"ai_speaker/golibs/ai/gemini"
	"fmt"
	"os"

	"github.com/gin-gonic/gin"
)

type Server struct {
	router *gin.Engine

	// gemini is a AI model
	gemini *gemini.Gemini // TODO: should be interface to make it testable & replaceable
}

func NewServer(gemini *gemini.Gemini) (*Server, error) {
	server := &Server{
		gemini: gemini,
	}

	server.SetupREST()

	return server, nil
}

func (s *Server) SetupREST() {
	router := gin.Default()

	router.GET("/ping", s.Ping)

	s.router = router
}

// Run http server on address
func (server *Server) Start() error {
	port := os.Getenv("PORT")
	if port == "" {
		port = "8080" // Use a default port if not provided by Heroku
	}

	return server.router.Run(fmt.Sprintf(":%s", port))
}
