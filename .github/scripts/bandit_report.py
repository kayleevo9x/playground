import json
import sys
from jinja2 import Environment, FileSystemLoader
import os

MARKDOWN_FILE = "bandit_report.md"


def load_bandit_json(file_path: str) -> dict:
    try:
        with open(file_path, "r") as f:
            return json.load(f)
    except FileNotFoundError as e:
        print(f"Error loading Bandit JSON: {e}", file=sys.stderr)
        sys.exit(1)


def count_issues(results: dict) -> tuple:
    severity_list = ["UNDEFINED", "HIGH", "MEDIUM", "LOW"]
    total_lines = results.get("metrics", {}).get("_totals", {}).get("loc", 0)
    skipped_lines = results.get("metrics", {}).get("nosec", 0)

    total_data = results.get("metrics", {}).get("_totals", {})
    severity_count = {severity: total_data[f"SEVERITY.{severity}"] for severity in severity_list}
    confidence_count = {severity: total_data[f"CONFIDENCE.{severity}"] for severity in severity_list}

    grouped_result = {category: [issue for issue in results.get("results", []) if issue["issue_severity"] == category] for category in severity_list}
    return total_lines, skipped_lines, severity_count, confidence_count, grouped_result


def generate_markdown_report(results: dict) -> None:
    try:
        template_env = Environment(loader=FileSystemLoader("templates"))

        jinja_template = template_env.get_template(f"{MARKDOWN_FILE}.j2")

        total_lines, skipped_lines, severity_count, confidence_count, grouped_results = count_issues(results)
        rendered_template = jinja_template.render(
            grouped_results=grouped_results,
            total_lines=total_lines,
            skipped_lines=skipped_lines,
            severity_count=severity_count,
            confidence_count=confidence_count,
        )

        with open(
            f"{os.path.dirname(os.path.abspath(__file__))}/templates/{MARKDOWN_FILE}", "w"
        ) as file:
            file.write(rendered_template)
        print(f"Markdown report generated: {MARKDOWN_FILE}")
    except Exception as e:
        print(f"Error generating markdown report: {e}", file=sys.stderr)


def main():
    print("Bandit Pretty Report")
    if len(sys.argv) != 2:
        print(f"Usage: {sys.argv[0]} <bandit_json_file>")
        sys.exit(1)
    bandit_json_file = sys.argv[1]
    results = load_bandit_json(bandit_json_file)

    _, _, severity_count, _, _ = count_issues(results)
    generate_markdown_report(results)
    if severity_count["HIGH"] >= 3 and severity_count["MEDIUM"] >= 1 and severity_count["LOW"] >= 1:
        print("Build failed due to security vulnerabilities.", file=sys.stderr)
        sys.exit(1)
    print("Build passed with acceptable security levels.")
    sys.exit(0)


if __name__ == "__main__":
    main()
