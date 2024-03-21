package apis

import (
	"fmt"
	"os"

	chatbot "ai_speaker/golibs/chat_bot"
	"ai_speaker/golibs/tts"

	"github.com/gin-gonic/gin"
)

type Server struct {
	router *gin.Engine

	// Large Language Model chatbot
	ChatBot chatbot.ChatBot

	// Text-to-Speech
	TTS tts.TTS
}

func NewServer(chatBot chatbot.ChatBot, tts tts.TTS) (*Server, error) {
	server := &Server{
		ChatBot: chatBot,
		TTS:     tts,
	}

	server.SetupREST()

	return server, nil
}

func (s *Server) SetupREST() {
	router := gin.Default()

	router.GET("/ping", s.Ping)
	router.POST("/v1/chat/text/generate", s.GenerateContent)
	router.POST("/v1/chat/text/realtime", s.GenerateRealtimeContent)

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
