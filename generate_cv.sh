#!/bin/bash
# cv.md + publications.md → assets/CV_Taewoong_Yoon.pdf
set -e
cd "$(dirname "${BASH_SOURCE[0]}")"

python3 << 'PYEOF'
import re, subprocess, sys

def strip_front_matter(text):
    """Jekyll YAML front matter 제거."""
    if text.startswith('---'):
        i = text.find('---', 3)
        if i != -1:
            return text[i + 3:].lstrip('\n')
    return text

cv  = strip_front_matter(open('cv.md').read())
pub = strip_front_matter(open('publications.md').read())

# publications.md: <u>text</u> → [text]{.underline}
pub = re.sub(r'<u>(.*?)</u>', r'[\1]{.underline}', pub)

# cv.md: "Download CV" 링크 블록 제거
cv = re.sub(r'You can download.*?\n\[Download CV\][^\n]*\n', '', cv, flags=re.DOTALL)

# cv.md: 섹션 사이 --- 구분자 제거 (섹션 제목 아래 rule로 대체)
cv = cv.replace('\n---\n', '\n\n')

# cv.md: Publications 섹션 제거 (publications.md로 대체)
cv = re.sub(r'### \*\*Publications\*\*.*?(?=### |\Z)', '', cv, flags=re.DOTALL)

# 헤딩 레벨 정규화: ### **Title** → # Title, #### → ##
cv = re.sub(r'^### \*\*(.+?)\*\*', r'# \1', cv, flags=re.MULTILINE)
cv = re.sub(r'^#### ', '## ', cv, flags=re.MULTILINE)

# Publications 섹션 구성 (publications.md 내용 사용)
pub_section = '# Publications\n\n' + pub.strip() + '\n\n'

# Conferences & Presentations 앞에 삽입
m = re.search(r'^# Conferences', cv, re.MULTILINE)
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

open('/tmp/cv_combined.md', 'w').write(doc)

import os
cwd = os.getcwd()
header = os.path.join(cwd, '_cv_header.tex')
name   = os.path.join(cwd, '_cv_name.tex')

r = subprocess.run(
    ['pandoc', '/tmp/cv_combined.md',
     '-o', 'assets/CV_Taewoong_Yoon.pdf',
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
