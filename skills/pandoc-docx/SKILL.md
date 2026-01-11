---
name: pandoc-docx
description: Universal document conversion using Pandoc with focus on DOCX format. Use when converting documents to or from DOCX format, including Markdown, HTML, PDF, and other formats. Supports: (1) Converting other formats to DOCX (Markdown, HTML, reStructuredText, etc.), (2) Converting DOCX to other formats, (3) Custom DOCX templates and styling, (4) Batch document processing
---

# Pandoc Docx

## Overview

Use Pandoc for reliable document format conversion to and from DOCX.

## Directory Conventions

Use project root directories (not skill directory):
- `import/` - Source files to convert (project root)
- `export/` - Converted output files (project root)

**Example from project root:**
```bash
pandoc import/report.md -o export/report.docx
```

## Convert to DOCX

Convert from Markdown, HTML, reStructuredText, or other Pandoc-supported formats:

```bash
pandoc input.md -o output.docx
```

**Common use cases:**
- `--reference-doc=template.docx` - Apply custom styling
- `--toc` - Generate table of contents
- `--toc-depth=2` - Set TOC depth
- `--metadata="title=My Document"` - Set document metadata

**Example:**
```bash
pandoc report.md -o report.docx --toc --reference-doc=brand-template.docx
```

**Use built-in Chinese template:**
The skill includes a Chinese template with:
- Title numbering
- List items with second-line indentation
- Code block highlighting
```bash
pandoc import/input.md -o export/output.docx --reference-doc=pandoc-docx/assets/templates.docx
```

## Convert from DOCX

Extract content from DOCX to other formats:

```bash
pandoc input.docx -o output.md
```

**Common use cases:**
- `--extract-media=media/` - Extract embedded images
- `-t markdown` - Output as Markdown
- `-t html` - Output as HTML
- `--standalone` - Create complete document

**Example:**
```bash
pandoc import/document.docx -o export/document.md --extract-media=export/images/
```

## Custom Templates

Create branded DOCX documents:

1. Generate default template:
   ```bash
   pandoc --print-default-data-file reference.docx > reference.docx
   ```

2. Edit styles in Word

3. Apply during conversion:
   ```bash
   pandoc import/input.md -o export/output.docx --reference-doc=reference.docx
   ```

## Batch Processing

Convert multiple files (run from project root):

```bash
for file in import/*.md; do
  pandoc "$file" -o "export/$(basename "${file%.md}").docx" --reference-doc=pandoc-docx/assets/templates.docx
done
```

## Resources

### assets/templates.docx
Chinese DOCX template with title numbering, formatted lists, and code highlighting.

### scripts/convert.sh
Run from project root directory (not skill directory):
```bash
./pandoc-docx/scripts/convert.sh report.md report.docx
./pandoc-docx/scripts/convert.sh report.md report.docx --toc --reference-doc=pandoc-docx/assets/templates.docx

# Absolute paths work as usual
./pandoc-docx/scripts/convert.sh /path/to/input.md /path/to/output.docx
```

### references/pandoc-options.md
Complete reference for Pandoc options and advanced patterns.
