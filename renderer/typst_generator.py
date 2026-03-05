"""Generate Typst resume files from YAML data."""
import os
import shutil
import subprocess
from functools import lru_cache
from pathlib import Path
from typing import Any, Dict

import requests
import yaml


@lru_cache(None)
def get_github_stars(repository: str) -> str:
    """Fetch GitHub stars with graceful fallback."""
    if not repository.startswith("https://github.com/"):
        return ""

    url = repository.replace("https://github.com", "https://api.github.com/repos")
    headers = {}
    github_token = os.environ.get("GITHUB_TOKEN")
    if github_token:
        headers["Authorization"] = f"token {github_token}"

    try:
        resp = requests.get(url, headers=headers, timeout=8)
        data = resp.json()
    except Exception:
        return ""

    stars_count = data.get("stargazers_count")
    if stars_count is None:
        return ""
    if stars_count > 1000:
        return f"{stars_count / 1000:.1f}k"
    return str(stars_count)


class TypstResumeGenerator:
    """Generator for Typst format resumes."""
    
    def __init__(self) -> None:
        self.root = Path(__file__).absolute().parent.parent
        self.data_dir = self.root / "data"
        self.template_file = self.root / "typst_template.typ"
        self.typst_bin = shutil.which("typst")
    
    def _escape_typst(self, text: str) -> str:
        """Escape special characters for Typst."""
        # Escape characters used in Typst string literals.
        return text.replace("\\", "\\\\").replace('"', '\\"')
    
    def _format_bio(self, bio: str) -> str:
        """Format bio bullets for Typst."""
        lines = bio.strip().split('\n')
        formatted_lines = []
        for line in lines:
            line = line.strip()
            if line:
                # Keep the bullet point format
                if not line.startswith('-') and not line.startswith('*'):
                    line = '- ' + line
                elif line.startswith('*'):
                    # Replace * with -
                    line = '-' + line[1:]
                formatted_lines.append(line)
        return '\n'.join(formatted_lines)
    
    def _format_work_content(self, content: str) -> str:
        """Format work experience content for Typst."""
        lines = content.strip().split('\n')
        formatted_lines = []
        for line in lines:
            line = line.strip()
            if line:
                # Ensure proper bullet formatting
                if not line.startswith('-') and not line.startswith('*'):
                    line = '  - ' + line
                elif line.startswith('*'):
                    # Replace * with - and add proper indentation
                    line = '  -' + line[1:]
                elif line.startswith('-'):
                    # Add proper indentation
                    line = '  ' + line
                formatted_lines.append(line)
        return '\n'.join(formatted_lines)
    
    def _generate_contact_info(self, data: Dict[str, Any], lang: str) -> str:
        """Generate contact information section."""
        contact_params = []
        
        if data.get("name"):
            author = self._escape_typst(str(data["name"]))
            contact_params.append(f'  author: "{author}",')
        
        if data.get("location"):
            location = self._escape_typst(str(data["location"]))
            contact_params.append(f'  location: "{location}",')
        
        if data.get("email"):
            email = self._escape_typst(str(data["email"]))
            contact_params.append(f'  email: "{email}",')
        
        if data.get("phone"):
            phone = self._escape_typst(str(data["phone"]))
            contact_params.append(f'  phone: "{phone}",')
        
        if data.get("github"):
            github_user = data["github"]
        else:
            # Try to extract from links
            github_user = ""
            for link in data.get("links", []):
                url = link.get("url", "")
                if "github.com" in url and "gitblog" not in url:
                    github_user = url.split("/")[-1]
                    break
        
        if github_user:
            github_user = self._escape_typst(github_user)
            contact_params.append(f'  github: "{github_user}",')
        
        if data.get("tg"):
            telegram = self._escape_typst(str(data["tg"]))
            contact_params.append(f'  telegram: "{telegram}",')
        
        # Extract personal site and blog from links
        personal_site = ""
        blog = ""
        for link in data.get("links", []):
            url = link.get("url", "")
            if "yihong.run" in url and not personal_site:
                personal_site = url
            elif "blog" in url and "gitblog" not in url and not blog:
                blog = url
        
        if personal_site:
            personal_site = self._escape_typst(personal_site)
            contact_params.append(f'  personal-site: "{personal_site}",')
        if blog:
            blog = self._escape_typst(blog)
            contact_params.append(f'  blog: "{blog}",')
        
        return "\n".join(contact_params)
    
    def _generate_bio_section(self, data: Dict[str, Any], lang: str) -> str:
        """Generate bio/about section."""
        title = "About Me" if lang == "en" else "个人简介"
        bio = self._format_bio(data.get("bio", ""))
        return f"== {title}\n\n{bio}"
    
    def _generate_work_section(self, data: Dict[str, Any], lang: str) -> str:
        """Generate work experience section."""
        t = data.get("t", {})
        title = t.get("work_experience", "Work Experience")
        
        work_entries = []
        for work in data.get("work_experience", []):
            company = self._escape_typst(str(work.get("company", "")))
            position = self._escape_typst(str(work.get("position", "")))
            start = work.get("start", "")
            end = work.get("end", "")
            if end.lower() == "now":
                end = "至今" if lang == "zh" else "Present"
            date = self._escape_typst(f"{start} - {end}")
            content = self._format_work_content(work.get("content", ""))
            
            entry = f'''#work(
  title: "{position}",
  location: "{company}",
  date: "{date}",
)[
{content}
]'''
            work_entries.append(entry)
        
        return f"== {title}\n\n" + "\n\n".join(work_entries)
    
    def _generate_skills_section(self, data: Dict[str, Any], lang: str) -> str:
        """Generate skills/stack section."""
        t = data.get("t", {})
        title = t.get("stack", "Technical Stack")
        
        skills = data.get("stack", [])
        skills_str = ", ".join(f'"{skill}"' for skill in skills)
        
        return f"== {title}\n\n#skills((\n  {skills_str}\n))"
    
    def _generate_opensource_section(self, data: Dict[str, Any], lang: str) -> str:
        """Generate open source projects section."""
        t = data.get("t", {})
        title = t.get("open_source", "Open Source Projects")
        
        project_entries = []
        for project in data.get("open_source", []):
            name = self._escape_typst(str(project.get("name", "")))
            url = str(project.get("repository", ""))
            escaped_url = self._escape_typst(url)
            description = self._escape_typst(str(project.get("description", "")))

            repo_label = ""
            if "github.com/" in url:
                repo_label = url.split("github.com/", 1)[-1]
            elif url:
                repo_label = (
                    url.replace("https://", "")
                    .replace("http://", "")
                    .rstrip("/")
                )
            repo_label = self._escape_typst(repo_label)

            stars = ""
            if "github.com/" in url:
                try:
                    stars = get_github_stars(url)
                except Exception:
                    stars = ""
            stars = self._escape_typst(stars)
            
            entry = f'''#project(
  name: "{name}",
  url: "{escaped_url}",
  repo_label: "{repo_label}",
  stars: "{stars}",
  description: "{description}",
)'''
            project_entries.append(entry)
        
        return f"== {title}\n\n" + "\n\n".join(project_entries)
    
    def _generate_education_section(self, data: Dict[str, Any], lang: str) -> str:
        """Generate education section."""
        t = data.get("t", {})
        title = t.get("education", "Education")
        
        edu_entries = []
        for edu in data.get("education", []):
            school = self._escape_typst(str(edu.get("school", "")))
            major = self._escape_typst(str(edu.get("major", "")))
            degree = self._escape_typst(str(edu.get("degree", "")))
            start = edu.get("start", "")
            end = edu.get("end", "")
            date = self._escape_typst(f"{start} - {end}")
            
            entry = f'''#education(
  institution: "{school}",
  major: "{major}",
  degree: "{degree}",
  date: "{date}",
)'''
            edu_entries.append(entry)
        
        return f"== {title}\n\n" + "\n\n".join(edu_entries)
    
    def generate_typst_file(self, locale: str) -> Path:
        """Generate a Typst file for the given locale."""
        yaml_file = self.data_dir / locale / "main.yaml"
        
        with open(yaml_file, encoding="utf-8") as f:
            data = yaml.safe_load(f)
        
        # Generate sections
        contact_info = self._generate_contact_info(data, locale)
        bio_section = self._generate_bio_section(data, locale)
        work_section = self._generate_work_section(data, locale)
        skills_section = self._generate_skills_section(data, locale)
        education_section = self._generate_education_section(data, locale)
        opensource_section = self._generate_opensource_section(data, locale)
        opensource_pagebreak = "#pagebreak()\n\n" if locale == "zh" else ""
        
        # Combine into full document
        typst_content = f'''#import "typst_template.typ": *

#show: resume.with(
{contact_info}
)

{bio_section}

{work_section}

{skills_section}

{education_section}

{opensource_pagebreak}{opensource_section}
'''
        
        # Write to file
        output_file = self.root / f"resume_{locale}.typ"
        with open(output_file, "w", encoding="utf-8") as f:
            f.write(typst_content)
        
        print(f"\x1b[32mGenerated\x1b[0m {output_file.name}")
        return output_file
    
    def compile_to_pdf(self, typst_file: Path) -> Path:
        """Compile a Typst file to PDF."""
        print(f"\x1b[32mCompiling\x1b[0m {typst_file.name} to PDF...")

        if not self.typst_bin:
            raise RuntimeError(
                "Typst CLI was not found in PATH. Install it first, for example:\n"
                "  macOS (Homebrew): brew install typst\n"
                "  or visit: https://github.com/typst/typst#installation"
            )

        result = subprocess.run(
            [self.typst_bin, "compile", str(typst_file)],
            capture_output=True,
            text=True,
        )
        
        if result.returncode != 0:
            print(f"\x1b[31mError\x1b[0m compiling {typst_file.name}:")
            print(result.stderr)
            raise RuntimeError(f"Failed to compile {typst_file.name}")
        
        pdf_file = typst_file.with_suffix(".pdf")
        
        # Get file size
        size = pdf_file.stat().st_size
        size_str = f"{size / 1024:.2f} KB" if size < 1024**2 else f"{size / 1024**2:.2f} MB"
        
        print(f" ↘ \x1b[32mSuccessful\x1b[0m, size: {size_str}")
        return pdf_file
    
    def generate_all(self) -> None:
        """Generate all Typst files and compile to PDF."""
        for locale_dir in self.data_dir.iterdir():
            if not locale_dir.is_dir():
                continue
            
            locale = locale_dir.name
            
            # Generate Typst file
            typst_file = self.generate_typst_file(locale)
            
            # Compile to PDF
            self.compile_to_pdf(typst_file)


def generate_pdf() -> None:
    """Main entry point for PDM script."""
    generator = TypstResumeGenerator()
    generator.generate_all()


if __name__ == "__main__":
    generate_pdf()
