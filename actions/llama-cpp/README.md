# Summary

Used to run the llama.cpp OpenAI-compatible server.

## Usage

```yaml
steps:
  - name:
    uses: neuralmagic/nm-actions/actions/llama-cpp@main
    with:
      port: 8000
      model: "aminkhalafi/Phi-3-mini-4k-instruct-Q4_K_M-GGUF"
      context-size: 2048
```
