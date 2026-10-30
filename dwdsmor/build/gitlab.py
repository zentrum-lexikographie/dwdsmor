from os import environ

from gitlab import Gitlab

gitlab_url = environ.get("GITLAB_URL", "https://gitlab.bbaw.science-berlin.de")

dwdswb_project_id = int(environ.get("GITLAB_DWDSWB_PROJECT_ID", "6"))
dwdsmor_project_id = int(environ.get("GITLAB_DWDSMOR_PROJECT_ID", "7"))

job_token = environ.get("CI_JOB_TOKEN")
private_token = environ.get("GITLAB_PAT")

api = Gitlab(
    gitlab_url,
    private_token=private_token,
    job_token=(job_token if not private_token else None),
)


def dwdswb_project():
    return api.projects.get(dwdswb_project_id, lazy=True)


def dwdswb_date():
    packages = dwdswb_project().packages.list(package_type="generic", get_all=True)
    versions = (
        p.attributes["version"] for p in packages if p.attributes["name"] == "dwdswb"
    )
    version, *_ = sorted(versions, reverse=True)
    return version


def dwdsmor_project():
    return api.projects.get(dwdsmor_project_id, lazy=True)


def dwdsmor_versions():
    packages = dwdsmor_project().packages.list(get_all=True)
    versions = {
        p.attributes["version"]
        for p in packages
        if p.attributes["name"].startswith("dwdsmor-dwds")
    }
    return versions
