#!/bin/bash
# cv.md + publications.md -> assets/CV_Taewoong_Yoon.pdf
set -e
cd "$(dirname "${BASH_SOURCE[0]}")"

python3 << 'PYEOF'
import re, subprocess, sys
from pathlib import Path

def strip_front_matter(text):
    """Remove Jekyll YAML front matter."""
    if text.startswith('---'):
        i = text.find('---', 3)
        if i != -1:
            return text[i + 3:].lstrip('\n')
    return text

root = Path.cwd()
cv = strip_front_matter((root / 'cv.md').read_text(encoding='utf-8'))
pub = strip_front_matter((root / 'publications.md').read_text(encoding='utf-8'))

# publications.md: <u>text</u> -> [text]{.underline}
pub = re.sub(r'<u>(.*?)</u>', r'[\1]{.underline}', pub)

# cv.md: remove web-only PDF download block
cv = re.sub(r'<p class="cv-download">.*?</p>\s*', '', cv, flags=re.DOTALL)

# cv.md: remove legacy section dividers
cv = cv.replace('\n---\n', '\n\n')

# Normalize heading levels for PDF output
cv = re.sub(r'^### ', '# ', cv, flags=re.MULTILINE)
cv = re.sub(r'^#### ', '## ', cv, flags=re.MULTILINE)

# Strip bold markers from headings (already bold in LaTeX)
cv = re.sub(r'^(#{1,6}) \*\*(.*?)\*\*$', r'\1 \2', cv, flags=re.MULTILINE)

# Build Publications section from publications.md
pub_section = '# Publications\n\n' + pub.strip() + '\n\n'

# Insert Publications between Honors and Presentations
m = re.search(r'^# Presentations', cv, re.MULTILINE)
if m:
    cv = cv[:m.start()] + pub_section + cv[m.start():]
else:
    cv = cv.rstrip() + '\n\n' + pub_section

# 최종 문서 조합
doc = (
    '---\n'
    'geometry: "top=1in, bottom=1in, left=1.1in, right=1.1in"\n'
    'fontsize: 11pt\n'
    'mainfont: "Times New Roman"\n'
    'colorlinks: true\n'
    'urlcolor: blue\n'
    '---\n\n'
) + cv.strip() + '\n'

temp_md = Path('/tmp/cv_combined.md')
temp_md.write_text(doc, encoding='utf-8')

header = root / '_cv_header.tex'
name = root / '_cv_name.tex'

r = subprocess.run(
    ['pandoc', str(temp_md),
     '-o', str(root / 'assets/CV_Taewoong_Yoon.pdf'),
     '--pdf-engine=xelatex',
     f'--include-in-header={header}',
     f'--include-before-body={name}'],
    capture_output=True, text=True
)
if r.returncode != 0:
    print(r.stderr, file=sys.stderr)
    sys.exit(1)
print('PDF generated: assets/CV_Taewoong_Yoon.pdf')
PYEOF
