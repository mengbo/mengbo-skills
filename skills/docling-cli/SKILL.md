---
name: docling-cli
description: Convert documents to structured formats with OCR, table extraction, and AI-powered features. Use when working with PDF/DOCX/PPTX/images to Markdown/JSON/HTML conversion, table extraction, OCR on scanned PDFs, vision models for better extraction, or audio transcription.
---

# Docling CLI

Convert documents to structured formats with intelligent parsing, OCR, and AI enhancement.

## Installation

```bash
uv tool install docling[asr,vlm]
```

## Directory Setup

Create working directories in your project root:
```bash
mkdir -p import export
```

- `import/` - Source files to convert
- `export/` - Converted output files

**Note:** You can specify any output directory with `--output`, but examples below use `export/` for consistency.

## Quick Start

**Check complete options before using:**

```bash
docling --help
```

Basic conversion (most parameters have sensible defaults):

```bash
# Convert PDF to Markdown
docling --output export/ import/document.pdf

# Convert to JSON
docling --to json --output export/ import/document.pdf

# Batch convert entire directory
docling --output export/ import/
```

**Default behavior:**
- Input format: auto-detects (PDF, DOCX, PPTX, images, etc.)
- Output format: Markdown
- Output directory: current directory
- OCR: enabled
- Table extraction: enabled
- Image export: embedded

## Image Export Mode

**Choose image export mode based on your needs:**

| Mode | Description | When to use |
|------|-------------|-------------|
| `placeholder` | Only mark image positions | When user doesn't need images |
| `embedded` | Base64-encoded images (default) | When user needs images but wants single-file output |
| `referenced` | Export as PNG files, reference in document | When user needs separate image files |

```bash
docling --to json --image-export-mode referenced --output export/ import/document.pdf
```

## Platform Optimization

### macOS / Apple Silicon

**Recommend using VLM pipeline for better performance**, especially for scanned PDFs or documents with images:

```bash
docling --pipeline vlm --output export/ import/document.pdf
```

VLM pipeline with default model works well for documents with Chinese image content.

## Audio Transcription

Convert audio files to text using ASR models:

```bash
# Use default whisper_tiny model
docling --pipeline asr --output export/ import/audio.mp3

# For better accuracy with Chinese
docling --pipeline asr --asr-model whisper_large --output export/ import/audio.mp3
```
