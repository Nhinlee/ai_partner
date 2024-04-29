package utils

import (
	"strings"
)

const (
	ENDERS = "?.!" // sentence enders
)

// / Given: response stream strings from the AI model
// / Returns: sentences stream from the response strings
// TODO: add unit tests
func ToSentenceStream(textChannel chan string, maxSentencesPerM int) chan string {
	sentencesChan := make(chan string)

	go func() {
		defer close(sentencesChan)

		var paragraph string
		for s := range textChannel {
			paragraph += s
			sentences := splitToSentences(paragraph)
			n := len(sentences)

			countSentence := 0
			currentSentence := ""
			for i := 0; i < n-1; i++ {
				if countSentence >= maxSentencesPerM {
					// send the current sentence
					sentencesChan <- currentSentence
					currentSentence = ""
					countSentence = 0
				}

				currentSentence += sentences[i]
				countSentence++
			}

			// send the last sentence
			if currentSentence != "" {
				sentencesChan <- currentSentence
			}

			// append the last sentence to the paragraph
			if n > 0 {
				paragraph = sentences[n-1]
			}
		}

		// send the last sentence
		if paragraph != "" {
			sentencesChan <- paragraph
		}
	}()

	return sentencesChan
}

// TODO: add unit tests
func splitToSentences(paragraph string) []string {
	sentences := []string{}

	var current string
	for _, char := range paragraph {
		current += string(char)
		if strings.Contains(ENDERS, string(char)) {
			sentences = append(sentences, current)
			current = ""
		}
	}

	// append the last sentence
	if current != "" {
		sentences = append(sentences, current)
	}

	return sentences
}
