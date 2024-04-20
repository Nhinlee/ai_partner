package main

import (
	"context"
	"fmt"
	"net/http"
	"os"
	"os/signal"
	"syscall"

	"ai_speaker/apis"
	"ai_speaker/configs"
	"ai_speaker/golibs/chat_bot/gemini"

	openai_tts "ai_speaker/golibs/tts/open_ai"

	openai "github.com/sashabaranov/go-openai"
	"github.com/zishang520/socket.io/v2/socket"
)

func main() {
	// load secret
	secret, err := configs.NewSecret()
	if err != nil {
		panic(err)
	}

	// new Gemini AI model
	ctx := context.Background()
	gemini, err := gemini.NewGemini(ctx, secret.AI.GenaiAPIKey)
	if err != nil {
		panic(err)
	}

	// new Open AI client
	client := openai.NewClient(secret.AI.OpenAiTTSKey)
	tts := openai_tts.NewOpenAiTTS(client)

	// Start SocketIO server
	go handleSocketIO()

	// Start HTTP server
	_, err = apis.NewServer(gemini, tts)
	if err != nil {
		panic(err)
	}
}

func handleSocketIO() {
	io := socket.NewServer(nil, nil)
	http.Handle("/socket.io/", io.ServeHandler(nil))
	go http.ListenAndServe(":8081", nil)

	io.On("connection", func(clients ...any) {
		fmt.Println("connected")

		client := clients[0].(*socket.Socket)

		// Listen on client events
		client.On("event", func(datas ...any) {
			fmt.Printf("event: %v\n", datas)

			// Emit events
			client.Emit("event", "Hello, world!")
		})

		client.On("disconnect", func(...any) {
			fmt.Println("disconnect")
		})
	})

	fmt.Printf("SocketIO server started at :8081\n")

	exit := make(chan struct{})
	SignalC := make(chan os.Signal)

	signal.Notify(SignalC, os.Interrupt, syscall.SIGHUP, syscall.SIGINT, syscall.SIGTERM, syscall.SIGQUIT)
	go func() {
		for s := range SignalC {
			switch s {
			case os.Interrupt, syscall.SIGHUP, syscall.SIGINT, syscall.SIGTERM, syscall.SIGQUIT:
				close(exit)
				return
			}
		}
	}()

	<-exit
	io.Close(nil)
	os.Exit(0)
}
