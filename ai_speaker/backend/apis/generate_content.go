package apis

import (
	chatbot "ai_speaker/golibs/chat_bot"
	"ai_speaker/golibs/tts"
	"fmt"

	"github.com/gin-gonic/gin"
)

type GenerateContentRequest struct {
	Prompt string `json:"prompt"`
}

func (s *Server) GenerateContent(c *gin.Context) {
	// Get prompt from body
	req := GenerateContentRequest{}
	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(400, gin.H{
			"error": err.Error(),
		})
		return
	}

	content, err := s.ChatBot.GenerateContent(c, req.Prompt)
	if err != nil {
		c.JSON(500, gin.H{
			"error": err.Error(),
		})
		return
	}

	c.JSON(200, gin.H{
		"content": content,
	})
}

type GenerateRealtimeContentRequest struct {
	Prompt string `json:"prompt"`
}

func (s *Server) GenerateRealtimeContent(c *gin.Context) {
	// Get prompt from body
	req := GenerateRealtimeContentRequest{}
	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(400, gin.H{
			"error": err.Error(),
		})
		return
	}

	contentChan, err := s.ChatBot.GenerateRealtimeContent(c, req.Prompt, chatbot.RealtimeContentOptions{
		MaxSentencesPerMessage: 1,
	})
	if err != nil {
		c.JSON(500, gin.H{
			"error": err.Error(),
		})
		return
	}

	// go func() {
	// 	// print content to console
	// 	for content := range contentChan {
	// 		fmt.Printf("Content: %s\n", content)
	// 	}
	// }()

	var respMessage string
	for content := range contentChan {
		fmt.Printf("Content: %s\n", content)
		respMessage = content
		break
	}

	// Use TTS to convert text to speech
	audioResp, err := s.TTS.CreateSpeech(c, &tts.CreateSpeechRequest{
		Input:          respMessage,
		ResponseFormat: "mp3", // TODO: Use enum
		Speed:          1.0,
	})
	if err != nil {
		c.JSON(500, gin.H{
			"error": err.Error(), // TODO: Use custom error
		})
		return
	}

	c.DataFromReader(200, -1, "audio/L16", audioResp, nil)
}
