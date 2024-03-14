package apis

import (
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

	contentChan, err := s.ChatBot.GenerateRealtimeContent(c, req.Prompt)
	if err != nil {
		c.JSON(500, gin.H{
			"error": err.Error(),
		})
		return
	}

	go func() {
		// print content to console
		for content := range contentChan {
			fmt.Printf("Content: %s\n", content)
		}
	}()

	// TODO: Implement real-time chatbot
	c.JSON(200, gin.H{
		"content": "123",
	})
}
