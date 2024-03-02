package apis

import (
	"fmt"
	"os"

	chatbot "ai_speaker/golibs/chat_bot"

	"github.com/gin-gonic/gin"
)

type Server struct {
	router *gin.Engine

	// Large Language Model chatbot
	ChatBot chatbot.ChatBot
}

func NewServer(chatBot chatbot.ChatBot) (*Server, error) {
	server := &Server{
		ChatBot: chatBot,
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
